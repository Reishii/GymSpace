import 'home.dart';
import 'logic/status.dart';
import 'logic/auth.dart';
import 'misc/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:GymSpace/page/profile_page.dart';

void main() => runApp(GymSpace());

class GymSpace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymSpace',
      theme: ThemeData(
        primaryColor: GSColors.darkBlue,
      ),
      routes: <String, WidgetBuilder> { 
        '/home': (BuildContext context) => new Home()
      },
      // home: new StatusPage(auth: new Auth())
      home: ProfilePage(),
    );
  }
}
