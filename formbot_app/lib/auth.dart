import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebaseAuthPackage;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:formbot_app/bloc.dart';

import 'package:formbot_app/widgets/error_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';





class AuthenticationManager extends Bloc {
    static FirebaseBloc _firebaseBloc;
    MultiStreamController<FormScriberError> _formscriberErrorStream;
  AuthenticationManager(this._formscriberErrorStream) {
    _firebaseBloc = FirebaseBloc(_formscriberErrorStream);
  }

  static Future<bool> signIn() async {
      authenticateWithProvider();
  }
  static AuthCredential authenticateWithProvider() {
    AuthenticationProviderWindow(_firebaseBloc);
  }

  static Future<bool> signOut() {
    _firebaseBloc.signOut();
  }

  @override
  void dispose() {
    _formscriberErrorStream.close();

  }
}
class AuthorizationManager {
  // static Future<bool> checkForAuthorization() {
  //   _firebaseAuth.currentUser.
  // }
  // static Future<void>


}



//need to figure out if i can make firebaseBlock private and have it read by state
class AuthenticationProviderWindow extends StatefulWidget {
  List<AuthenticationProvider> providerList;
  FirebaseBloc firebaseBloc;

  AuthenticationProviderWindow(this.firebaseBloc, [this.providerList]) {
    if (providerList.isEmpty) {
      providerList.add(GoogleAuthentication(firebaseBloc));
    }
  }
  @override
  _AuthenticationProviderWindowState createState() => _AuthenticationProviderWindowState();
}
class _AuthenticationProviderWindowState extends State<AuthenticationProviderWindow>{
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Choose a login provider'),
      children: _getProviderItems(this.widget.providerList, this.widget.firebaseBloc),
    );
  }
  List<AuthenticationProviderWindowItem> _getProviderItems( List<AuthenticationProvider> providerList, FirebaseBloc _firebaseBloc) {
    List<AuthenticationProviderWindowItem> providerItemList = List.empty(
        growable: true);
    for (AuthenticationProvider provider in providerList) {
      if (provider._providerLogo != null) {
        providerItemList.add(AuthenticationProviderWindowItem(
            signInDisplayedPhrase: provider._providerSignInDisplayedPhrase,
            signInFunction: provider.signIn(_firebaseBloc),
            providerLogo: provider._providerLogo));
      } else {
        providerItemList.add(AuthenticationProviderWindowItem(
            signInDisplayedPhrase: provider._providerSignInDisplayedPhrase,
            signInFunction: provider.signIn(_firebaseBloc)));
      }
    }
    return providerItemList;
  }
}



class AuthenticationProviderWindowItem extends StatelessWidget {
  String signInDisplayedPhrase;
  Image providerLogo;
  Function signInFunction;
  // Make signInDisplayedPhrase and signInFunctionRequired.
  AuthenticationProviderWindowItem({Key key, String signInDisplayedPhrase,  Function signInFunction, Image providerLogo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(onPressed: signInFunction, child: Row(
    children: <Widget>[providerLogo, Text(signInDisplayedPhrase)]));
  }

}

abstract class AuthenticationProvider {
  // The AuthProviders that are supported by Flutterfire can be
  // found in the firebase_auth package:
  // https://github.com/FirebaseExtended/flutterfire/tree/master/packages/firebase_auth
  String _providerName;
  String _providerSignInDisplayedPhrase;
  Image _providerLogo;
  signIn(FirebaseBloc firebaseBloc);
}

class GoogleAuthentication extends AuthenticationProvider {
   GoogleSignIn _googleSignIn;
  GoogleAuthentication(FirebaseBloc firebaseBloc) {
    _providerName = "Google";
    _providerSignInDisplayedPhrase = "Sign in with Google";
    _googleSignIn = GoogleSignIn(
        scopes: ['email']
    );
  }
    Future<bool> signInSilently() async {
    var account = await _googleSignIn.signInSilently();
    return account != null;
  }

  @override
    signIn(FirebaseBloc firebaseBloc) async {
    final googleAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleAccount.authentication;
    if(googleSignInAuthentication != null) {
        //May not need a response if not authenticated? awaiting googlesignin might enforce sign in with null if not authenticated
    } else {
      firebaseBloc.signIn(googleSignInAuthentication.idToken, googleSignInAuthentication.accessToken, this);
    }
  }
}
class FirebaseBloc extends Bloc{
  FirebaseApp _firebaseApp;
  firebaseAuthPackage.FirebaseAuth _firebaseAuth;
  MultiStreamController<FormScriberError> _formscriberErrorStream;

  FirebaseBloc(this._formscriberErrorStream) {
    _initializeFirebaseResources();
  }
  _initializeFirebaseResources() async {
      await _initializeFirebaseAppInstance();
      _initializeFirebaseAuthInstance();
  }
  _initializeFirebaseAppInstance() async {
    try {
      _firebaseApp =  await Firebase.initializeApp();
    } catch(error) {
      _formscriberErrorStream.add(FormScriberError("FirebaseApp error", "A FirebaseApp instance could not be created from the FirebaseApp instance! You will not be able to use the application without a working FirebaseApp instance. Press the \"Retry\" button to try creating the FirebaseApp instance again. If this step continues to fail, please contact your FormScriber app administrators."));
    }
  }
  _initializeFirebaseAuthInstance() {
    _firebaseAuth =  firebaseAuthPackage.FirebaseAuth.instance;
    if(_firebaseAuth == null) {
      _formscriberErrorStream.add(FormScriberError("FirebaseAuth error", "A FirebaseAuth instance could not be created from the FirebaseApp instance! You will not be able to use the application without a working FirebaseAuth instance. Press the \"Retry\" button to try creating the FirebaseAuth instance again. If this step continues to fail, please contact your FormScriber app administrators."));
    }
  }
   signIn(String idTokenFromProvider, String accessTokenFromProvider, AuthenticationProvider authenticationProvider) async {
      AuthCredential _authCredential;

      switch(authenticationProvider._providerName) {
        //
        case "Google":
          _authCredential = GoogleAuthProvider.credential(idToken: idTokenFromProvider, accessToken: accessTokenFromProvider);
          break;
        // Additional AuthProvider credentials can be created by adding switch cases
        // below this comment block.
      }
    try {
        await _firebaseAuth.signInWithCredential(_authCredential);
    } catch (error) {
      _formscriberErrorStream.add(FormScriberError("Firebase authentication failure","Error! Authentication with Firebase failed! Please confirm "
            "with your FormScriber app administrators that you have the proper authorization"
            "to use this Firebase instance."));
    }
  }
    signOut() async {
    if (_firebaseAuth != null && _firebaseAuth.currentUser != null) {
      await _firebaseAuth.signOut();
     // if(_firebaseAuth.userChanges().) {
     //   // need to figure out how to do check correctly
     // }else {
     // _formscriberErrorStream.add(FormScriberError("Sign-out failure", "Error! Could not sign-out of the application!"));
     // }
    }
    Future<Stream<firebaseAuthPackage.User>> userChanges() async {
      if(_firebaseAuth != null && _firebaseAuth.currentUser != null) {
          return await _firebaseAuth.userChanges();
      }
    }
  }

  @override
  void dispose() {
    _firebaseApp.delete();
  }

}