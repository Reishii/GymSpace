// tab
import 'home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// colors
// import 'colors.dart' as _colors;

// misc
import 'package:flutter/material.dart';

void main() => runApp(GymSpace());

class GymSpace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymSpace',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}