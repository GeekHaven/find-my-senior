import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_senior/root.dart';
import 'package:find_my_senior/services/auth_service.dart';
import 'package:find_my_senior/services/searchservice.dart';
import 'package:flutter/material.dart';
import 'package:find_my_senior/services/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool searchState = false;
  var queryResultSet = [];
  var tempSearchStore = [];
  final AuthService _auth = AuthService();
  String userName;
  intiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
        }
        setState(() {
          tempSearchStore = queryResultSet;
        });
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['name'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

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
        title: !searchState
            ? Text('Find My Senior')
            : TextFormField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.black),
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.white),
                ),
                onChanged: (val) {
                  intiateSearch(val);
                },
              ),
        actions: <Widget>[
          !searchState
              ? IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      searchState = !searchState;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.cancel, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      searchState = !searchState;
                    });
                  },
                ),
        ],
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
              onTap: () async {
                _auth.signOutUser();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Root()));
              },
            ),
          ],
        ),
      ),
      body: ListView(children: [
        SizedBox(
          height: 20.0,
        ),
        GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
            primary: false,
            shrinkWrap: true,
            children: tempSearchStore.map((element) {
              return buildResultCard(element);
            }).toList())
      ]),
    );
  }
}

Widget buildResultCard(data) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    elevation: 2.0,
    child: Container(
      child: Text(
        data['name'],
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
        ),
      ),
    ),
  );
}
