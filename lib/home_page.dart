import 'package:find_my_senior/root.dart';
import 'package:find_my_senior/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:find_my_senior/services/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();
  String userName;
  getUserName() async {
    userName = await SharedPreferencesUtil.getUserName();
    setState(() {
      print(userName);
    });
  }

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find My Senior'),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: null,
              accountName: Text(
                userName,
                style: TextStyle(fontSize: 20.0),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  userName.substring(0, 1),
                  style: TextStyle(fontSize: 30.0),
                ),
              ),
            ),
            ListTile(
              title: Text('Edit Profile'),
              trailing: Icon(Icons.account_circle),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Log Out'),
              trailing: Icon(Icons.exit_to_app),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
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
