import 'workout.dart';
import 'package:GymSpace/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'workout.dart';
import 'dart:async';

class WorkoutPlan {
  String name = ""; 
  String author = "";
  String muscleGroup = "";
  String description = "";
  String documentID = "";
  List<Workout> workouts = List();

  WorkoutPlan({
    this.name = "",
    this.author = "",
    this.muscleGroup = "",
    this.description = "",
    this.documentID = "",
    this.workouts,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      'name': name,
      'author': author,
      'muscleGroup': muscleGroup,
      'description': description,
      'workouts': workouts == null ? [] : workouts,
    };
  }

  static Future<List<Workout>> getWorkouts(List<String> workoutIDS) async {
    List<Workout> workouts = [];
    
    for (String id in workoutIDS) {
      DocumentSnapshot ds = await DatabaseHelper.getWorkoutSnapshot(id);
      Workout workout = Workout.jsonToWorkout(ds.data);
      workout.documentID = id;
      workouts.add(workout);
    }

    return workouts;
  }

  static Future<WorkoutPlan> jsonToWorkoutPlan(Map<String, dynamic> data, String workoutPlanID) async {
    // pull workout IDs and make Workout
    List<String> workoutIDs = data['workouts'].cast<String>();
    List<Workout> workouts = await getWorkouts(workoutIDs);

    return WorkoutPlan(
        author: data['author'],
        name: data['name'],
        description: data['description'],
        muscleGroup: data['muscleGroup'],
        documentID: workoutPlanID,
        workouts: workouts,
      );
  }
}