import 'package:find_my_senior/authentication/fill_details.dart';
import 'package:find_my_senior/home_page.dart';
import 'package:find_my_senior/services/auth_service.dart';
import 'package:find_my_senior/services/shared_preferences.dart';
import 'package:flutter/material.dart';

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
                bool result = await _auth.signInGoogle();
                if (result != false) {
                  getUid();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FillDetails(uid)));
                } else {
                  print('error occured');
                }
              },
            ),
            RaisedButton(
              child: Text('Sign In with Google',
                  style: TextStyle(
                    fontSize: 20,
                  )),
              onPressed: () async {
                bool result = await _auth.signInGoogle();
                if (result != false) {
                  getUid();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                } else {
                  print('error occured');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
