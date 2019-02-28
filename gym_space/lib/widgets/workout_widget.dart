import 'package:flutter/material.dart';

class WorkoutWidget extends StatefulWidget {
  final Widget child;

  WorkoutWidget({Key key, this.child}) : super(key: key);

  _WorkoutWidgetState createState() => _WorkoutWidgetState();
}

class _WorkoutWidgetState extends State<WorkoutWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: widget.child,
    );
  }
}