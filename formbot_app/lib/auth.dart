import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:formbot_app/bloc.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';


GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      DriveApi.driveScope
    ]
);

class AuthManager extends Bloc {
  static FirebaseAuth _firebaseAuth;
  static Future<bool> signIn() async {
    try {
      final googleAccount = await googleSignIn.signIn();
      final FirebaseApp initializedApp = await Firebase.initializeApp();
      _firebaseAuth = FirebaseAuth.instance;
      if(googleAccount != null && _firebaseAuth != null) {
        GoogleSignInAuthentication googleSignInAuthentication = await googleAccount.authentication;
        //this is where we pass auth code to firebase
         UserCredential userCredential = await _firebaseAuth.signInWithCredential(GoogleAuthProvider.credential( idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken,));
         if(userCredential != null) {
           // Uncomment the statement below to display user info in the console when you are logging in
           //print('The user is currently signed in as   ${userCredential.user}');
           return true;
         }
         return false;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  static Future<GoogleSignInAccount> signInSilently() async {
    var account = await googleSignIn.signInSilently();
    print('account: $account');
    return account;
  }

  static Future<bool> signOut() async {
    try {
      if(_firebaseAuth != null && _firebaseAuth.currentUser != null) {
        _firebaseAuth.signOut();
        return true;
      }
      return false;
    } catch (error) {
      print(error);
    }
  }

  @override
  void dispose() {

  }
}