// import 'home.dart';
import 'dart:async';
import 'misc/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:GymSpace/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'database.dart';


Future<void> main() async{
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'gymspace',
    options: DatabaseConnections.database // our database 
  );

  /*
  Paul: disabled to make messages work...
  
  final Firestore firestore = Firestore(app: app);
  await firestore.settings(timestampsInSnapshotsEnabled: true);
  
  */
  
  runApp(GymSpace());
}

class GymSpace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymSpace',
      theme: ThemeData(
        primaryColor: GSColors.darkBlue,
      ),
      home: Home(),
    );
  }
}
