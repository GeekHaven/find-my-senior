import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_senior/home_page.dart';
import 'package:find_my_senior/services/database_services.dart';
import 'package:find_my_senior/services/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../models/multi_select_chip.dart';

class FillDetails extends StatefulWidget {
  final String uid;
  FillDetails(this.uid);
  @override
  _FillDetailsState createState() => _FillDetailsState();
}

class _FillDetailsState extends State<FillDetails> {
  bool isRegistered = true;
  int batch;
  String branch = "";
  _setBranch() {
    if (_valueOfBranch == 1)
      branch = "IT";
    else if (_valueOfBranch == 2)
      branch = "IT BI";
    else
      branch = "ECE";
  }

  int _valueOfBranch = 1;

  List<String> technicalInterests = [
    "App Dev",
    "Web Dev",
    "ML/AI",
    "Cyber Sec",
    "Competitive Coding",
    "Designing",
    "FOSS",
    "IoT",
    "Robotics"
  ];
  List<String> technicalSelected = [];

  List<String> societies = [
    "Sarasva",
    "AMS",
    "Gravity",
    "Tesla",
    "Nimriti",
    "Rangtarangini",
    "Virtuosi",
    "GeekHaven",
  ];
  List<String> societiesSelected = [];

  _showSelectionDialog(
      String title, List<String> list, String action, List<String> selected) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: MultiSelectChip(
              list,
              selected,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selected = selectedList;
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(action),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20.0),
                child: DropdownButton(
                    value: _valueOfBranch,
                    items: <DropdownMenuItem<int>>[
                      DropdownMenuItem(
                        child: Text("IT"),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text("IT BI"),
                        value: 2,
                      ),
                      DropdownMenuItem(child: Text("ECE"), value: 3),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _valueOfBranch = value;
                        _setBranch();
                      });
                    }),
              ),
              RaisedButton(
                  onPressed: () {
                    _showSelectionDialog("Technical Interests",
                        technicalInterests, 'Save', technicalSelected);
                  },
                  child: Text('Click to Select Technical Interests')),
              Text(technicalSelected.join(" , ")),
              RaisedButton(
                  onPressed: () => _showSelectionDialog(
                      "Societies", societies, 'Save', societiesSelected),
                  child: Text('Click to Select Societies')),
              Text(societiesSelected.join(" , ")),
              TextField(
                keyboardType: TextInputType.number,
                enabled: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Enter year of admission',
                ),
                onChanged: (text) {
                  setState(() {
                    batch = int.tryParse(text);
                  });
                },
              ),
              RaisedButton(
                  onPressed: () async {
                    _setBranch();
                    await SharedPreferencesUtil.saveUserBranch(branch);
                    await SharedPreferencesUtil.saveUserBatch(batch);
                    await DatabaseServices(widget.uid)
                        .createUser(technicalSelected, societiesSelected);
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: Text('Submit and Continue'))
            ],
          ),
        ),
      ),
    );
  }
}
