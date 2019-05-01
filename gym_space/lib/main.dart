import 'dart:async';
import 'misc/colors.dart';
// import 'package:algolia/algolia.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:GymSpace/database.dart';
import 'package:GymSpace/global.dart';
import 'package:GymSpace/page/login_page.dart';
import 'package:GymSpace/page/me_page.dart';
import 'package:GymSpace/page/profile_page.dart';


Future<void> main() async{
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'gymspace',
    options: DatabaseConnections.database // our database 
  );

  DatabaseConnections.algolia = DatabaseConnections.initAlgolia;
  
  // Paul: disabled to make messages work...
  
  // final Firestore firestore = Firestore(app: app);
  // await firestore.settings(timestampsInSnapshotsEnabled: true);
  
  String _userID = await AuthSettings.auth.currentUser();
  Widget _defaultHome = LoginPage(auth: AuthSettings.auth, authStatus: AuthSettings.authStatus,);
  if (_userID != null) {
     DatabaseHelper.currentUserID = _userID;
    _defaultHome = MePage();
  }

  // _defaultHome = testProfile();
  
  runApp(GymSpace(_defaultHome));
}

Widget testProfile() {
  return ProfilePage(forUserID: 'XKgmeU51sxgmMig8ExV5J8JKq6n1',);
}

class GymSpace extends StatelessWidget {
  final Widget home;

  GymSpace(this.home);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymSpace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: GSColors.darkBlue,
      ),
      home: home,
    );
  }
}
