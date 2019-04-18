import 'dart:async';
import 'misc/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'database.dart';
import 'package:GymSpace/page/login_page.dart';
import 'package:GymSpace/global.dart';
import 'package:GymSpace/page/me_page.dart';


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


  String loggedIn = await AuthSettings.auth.currentUser();
  Widget _defaultHome = loggedIn == null ? LoginPage(
    auth: AuthSettings.auth,
    authStatus: AuthSettings.authStatus,
  ) : MePage();
  
  runApp(GymSpace(_defaultHome));
}

class GymSpace extends StatelessWidget {
  final Widget home;

  GymSpace(this.home);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymSpace',
      theme: ThemeData(
        primaryColor: GSColors.darkBlue,
      ),
      home: home,
    );
  }
}
