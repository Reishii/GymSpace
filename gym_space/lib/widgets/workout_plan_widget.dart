import 'package:flutter/material.dart';
import 'package:GymSpace/logic/workout_plan.dart';
import 'workout_widget.dart';


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
          onTap: () => _displayWorkoutPlan(context),
          child: Container(
            child: Center (
              child: Text (
                _workoutPlan.name,
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

  void _displayWorkoutPlan(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WorkoutPlanPage(_workoutPlan)
      )
    );
  }
}

class WorkoutPlanPage extends StatelessWidget {
  final WorkoutPlan _workoutPlan;

  WorkoutPlanPage(this._workoutPlan, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_workoutPlan.name),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      margin: EdgeInsets.all(20),
      child: ListView.builder(
        itemCount: _workoutPlan.workouts.length,
        itemBuilder: (BuildContext context, int i) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: WorkoutWidget(workout: _workoutPlan.workouts[i]),
          );
        },
      )
    );
  }
}