import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialmediainform8/constants.dart';
import 'package:socialmediainform8/input_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseUser user;
final firestoreInstance = Firestore.instance;

class SavedData extends StatefulWidget {
  @override
  _SavedDataState createState() => _SavedDataState();
}

class _SavedDataState extends State<SavedData> {
  List<Widget> allNodes = [];

  void initState() {
    // ignore: unnecessary_statements
      super.initState();
      getCurrentUser();
      firestoreInstance.collection("users").document(user.uid).get().then((value){
        allNodes.add(ItemType(value.data));
      });
  }

  void getCurrentUser() async{
    user = await _auth.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: allNodes,
    );
  }
}

class ItemType extends StatelessWidget {
  ItemType(this.data);

  final Map data;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(data["platform"] + " " + data["node"]),
              RaisedButton(
                child: Text("Go"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder:
                      (context) => ResultsScreen(data["data"],data["platform"],data["node"])
                  ));
                },
              )
          ]),
        ),
        color: platformColors[data["platform"]],
      ),
    );
  }
}

