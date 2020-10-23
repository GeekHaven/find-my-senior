import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_senior/root.dart';
import 'package:find_my_senior/services/auth_service.dart';
import 'package:find_my_senior/services/searchservice.dart';
import 'package:flutter/material.dart';
import 'package:find_my_senior/services/shared_preferences.dart';


import 'services/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future getUser() async {
    Firestore firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection('profiles')
        .where('batch', isGreaterThan: batch)
        .getDocuments();
    return qn.documents;
  }

  bool searchState = false;
  var queryResultSet = [];
  var tempSearchStore = [];
  final AuthService _auth = AuthService();
  String userName;
  String email;
  String photoUrl;
  int batch;
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

  getUserEmail() async {
    email = await SharedPreferencesUtil.getUserEmail();
    setState(() {
      print(email);
    });
  }

  getUserBatch() async {
    batch = await SharedPreferencesUtil.getUserBatch();
    setState(() {
      print(batch);
    });
  }

  getUserPhoto() async{
    photoUrl = await SharedPreferencesUtil.getUserPhoto();
    setState(() {
      print(photoUrl);
    });
  }


  @override
  void initState() {
    super.initState();
    getUserName();
    getUserEmail();
    getUserBatch();
    getUserPhoto();
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
              accountEmail: Text(
                email,
                style: TextStyle(fontSize: 10.0),
              ),
              accountName: Text(
                userName,
                style: TextStyle(fontSize: 20.0),
              ),
              currentAccountPicture: CircleAvatar(
                radius: 10.0,
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
      body: Container(
          child: !searchState
              ? FutureBuilder(
                  future: getUser(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Text('Loading...'),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (_, index) {
                            return ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 10.0),
                              title: Text(snapshot.data[index].data["name"]),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(

                                    imageUrl: "$photoUrl",
                                    imageBuilder: (context, imageProvider) => Container(
                                             decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                     image: imageProvider,
                                                     fit: BoxFit.cover,
                                                     colorFilter:
                                                     ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
                                                     ),
                                        ),
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                  Text("Branch : " +
                                      snapshot.data[index].data["branch"]),
                                  Text("Batch : " +
                                      snapshot.data[index].data["batch"]
                                          .toString()),
                                ],
                              ),
                            );
                          });
                    }
                  },
                )
              : ListView(children: [
                  GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                      primary: false,
                      shrinkWrap: true,
                      children: tempSearchStore.map((element) {
                        return buildResultCard(element);
                      }).toList())
                ])),
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

class UrlImage extends StatefulWidget {
  @override
  _UrlImageState createState() => _UrlImageState();
}

class _UrlImageState extends State<UrlImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}