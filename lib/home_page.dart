import 'package:find_my_senior/root.dart';
import 'package:find_my_senior/services/auth_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () async {
            _auth.signOutUser();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Root()));
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
