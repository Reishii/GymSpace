import 'package:flutter/material.dart';
import 'package:GymSpace/logic/workout_plan.dart';
import 'package:GymSpace/colors.dart';

class WorkoutPlanWidget extends StatelessWidget {
  final WorkoutPlan _workoutPlan;

  WorkoutPlanWidget(this._workoutPlan, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Card (
        elevation: 3,
        child: InkWell(
          onTap: _displayWorkoutPlan,
          child: Container(
            child: Center (
              child: Text (
                _workoutPlan.getName(),
                style: TextStyle(
                  letterSpacing: 2,
                  fontFamily: 'Roboto',
                  fontSize: 20
                ),
              )
            )
          )
        ),
      )
    );
  }

  void _displayWorkoutPlan() {
    
  }
}