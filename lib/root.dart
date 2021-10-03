import 'package:find_my_senior/authentication/authentication.dart';
import 'package:find_my_senior/home_page.dart';
import 'package:find_my_senior/services/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Root extends StatefulWidget {
  const Root();
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  String uid;
  String userName;
  getUid() async {
    uid = await SharedPreferencesUtil.getUserUid();
  }

  @override
  void initState() {
    super.initState();
    getUid();
    var auth = FirebaseAuth.instance;
    auth.onAuthStateChanged.listen((user) {
      if (user != null) {
        print("user is logged in");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        print("user is not logged in");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Authentication()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
