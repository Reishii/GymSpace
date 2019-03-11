import 'package:flutter/material.dart';
import 'package:GymSpace/logic/workout.dart';
import 'package:GymSpace/logic/exercise.dart';

class WorkoutWidget extends StatelessWidget {
  final Workout _workout;

  WorkoutWidget(this._workout, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ExpansionTile (
        title: Text(_workout.getName()),
        children: _buildExercises()
      ),
    );
  }

  List<Widget> _buildExercises() {
    List<Widget> exercises;

    for (Exercise exercise in _workout.exercises) {
      Text exerciseWidget = Text(exercise.getName());
      exercises.add(exerciseWidget);
    }
  }
}