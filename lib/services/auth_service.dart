import 'package:find_my_senior/services/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthResult result;
  FirebaseUser user;
  Future<bool> signInGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount account = await googleSignIn.signIn();
      if (account == null) {
        return false;
      } else {
        result = await _auth.signInWithCredential(
            GoogleAuthProvider.getCredential(
                idToken: (await account.authentication).idToken,
                accessToken: (await account.authentication).accessToken));
        if (result.user == null) {
          return false;
        } else {
          user = result.user;
          SharedPreferencesUtil.saveUserName(user.displayName);
          SharedPreferencesUtil.saveUserUid(user.uid);
          SharedPreferencesUtil.saveUserEmail(user.email);
          return true;
        }
      }
    } catch (error) {
      print(error);
      return false;
    }
  }

  signOutUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
    await _auth.signOut();
  }
}
