// import 'home.dart';
import 'dart:async';
import 'misc/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:GymSpace/newHome.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async{
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'gymspace',
    options: const FirebaseOptions(
      googleAppID: '1:936699691309:android:3aeae822367bc185',
      apiKey: 'AIzaSyD-Q_wLERYdlEBK97oe3qdHz7BVGMRKxFY',
      projectID: 'gymspace',
    ),
  );
  final Firestore firestore = Firestore(app: app);
  await firestore.settings(timestampsInSnapshotsEnabled: true);

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
      // routes: <String, WidgetBuilder> { 
      //   '/home': (BuildContext context) => new Home()
      // },
      // builder: (context, child) {
      //   return Scaffold(
      //     drawer: AppDrawer(),
      //     body: child,
      //   );
      // },
      // home: new StatusPage(auth: new Auth())
      home: Home(),
      // home:ProfilePage()
    );
  }
}
