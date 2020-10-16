import 'package:find_my_senior/authentication/fill_details.dart';
import 'package:find_my_senior/home_page.dart';
import 'package:find_my_senior/services/auth_service.dart';
import 'package:find_my_senior/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: CircleAvatar(
                  radius: 120.0,
                  child: Image(image: AssetImage('logo/FindMySenior.png'))),
            ),
            Center(
              child: TypewriterAnimatedTextKit(
                textStyle: TextStyle(
                    fontSize: 25.0,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold),
                text: ['Find My Seniors'],
                isRepeatingAnimation: true,
              ),
            ),
            SizedBox(height: 50.0),
            OutlineButton(
              splashColor: Colors.grey,
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              highlightElevation: 0,
              borderSide: BorderSide(color: Colors.grey, width: 2.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                        image: AssetImage("logo/google_logo.png"),
                        height: 25.0),
                    SizedBox(width: 30.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            OutlineButton(
              splashColor: Colors.grey,
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              highlightElevation: 0,
              borderSide: BorderSide(color: Colors.grey, width: 2.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                        image: AssetImage("logo/google_logo.png"),
                        height: 25.0),
                    SizedBox(width: 30.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Register with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
