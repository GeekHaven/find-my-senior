import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_senior/authentication/fill_details.dart';
import 'package:find_my_senior/home_page.dart';
import 'package:find_my_senior/services/auth_service.dart';
import 'package:find_my_senior/services/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
String useremail;

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  String uid;

  getUid() async {
    uid = await SharedPreferencesUtil.getUserUid();
  }

  @override
  Widget build(BuildContext context) {
    AuthService _auth = AuthService();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text('Register with Google',
                  style: TextStyle(
                    fontSize: 20,
                  )),
              onPressed: () async {
                signInWithGoogle().then((result) {
                  if (result != false) {
                    getUid();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FillDetails(uid)));
                  } else {
                    print('error occured');
                  }
                });
              }
              ),
            RaisedButton(
              child: Text('Sign In with Google',
                  style: TextStyle(
                    fontSize: 20,
                  )),
              onPressed: () async {
                  bool result=await _auth.signInGoogle();
                  if (result != false) {
                    getUid();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  } else {
                    print('error occured');
                  }
              },
            )
          ],
        ),
      ),
    );
  }
}

Future<FirebaseUser> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult =
  await _firebaseAuth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  final FirebaseUser currentUser = await _firebaseAuth.currentUser();
  if (currentUser != null) {
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where("id", isEqualTo: currentUser.uid)
        .getDocuments();
    final List<DocumentSnapshot> document = result.documents;
    if (document.length == 0) {
      Firestore.instance
          .collection('users')
          .document(currentUser.uid)
          .setData({
        'id': currentUser.uid,
        'useremail': currentUser.email,
      });
    } else {}
  }
  return user;
}