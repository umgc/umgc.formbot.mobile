import 'package:googleapis/drive/v3.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      DriveApi.driveScope
    ]
);

class AuthManager {
  static Future<GoogleSignInAccount> signIn() async {
    try {
      final account = await googleSignIn.signIn();
      print('account: ${account?.toString()}');
      return account;
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

  static Future<void> signOut() async {
    try {
      googleSignIn.disconnect();
    } catch (error) {
      print(error);
    }
  }
}