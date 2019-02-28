import 'package:flutter/material.dart';
import 'package:GymSpace/colors.dart';

class YourWorkouts extends StatefulWidget {

  YourWorkouts({Key key}) : super(key: key);

  YourWorkoutsState createState() => YourWorkoutsState();
}

class YourWorkoutsState extends State<YourWorkouts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add),
      ),
      body: ListView(
        children: <Widget>[
          
        ],
      ),
    );
  }
}