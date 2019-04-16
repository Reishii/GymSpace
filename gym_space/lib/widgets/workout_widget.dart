import 'package:flutter/material.dart';
import 'package:GymSpace/logic/workout.dart';
import 'package:GymSpace/logic/exercise.dart';
import 'package:GymSpace/misc/colors.dart';

class WorkoutWidget extends StatelessWidget {
  final Workout _workout;

  WorkoutWidget(this._workout, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ExpansionTile (
        title: Text(_workout.name),
        children: _buildExercises()
      ),
    );
  }

  List<Widget> _buildExercises() {
    List<Widget> exercises = new List();

    for (Exercise exercise in _workout.exercises) {
      exercises.add(_buildExercise(exercise));
    }

    return exercises;
  }

  Widget _buildExercise(Exercise exercise) {
    return Column (
      children: <Widget>[
        Container(
          alignment: Alignment.topLeft,
          height: 60,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: GSColors.darkBlue,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Container(
            child: InkWell(
              onTap: () {},
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        exercise.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      )
                    )
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(left: 40),
                      child: Text(
                        exercise.sets.toString() + ' x ' + exercise.reps.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ),
          ),
        ),
        
      ],
    );
  }
}