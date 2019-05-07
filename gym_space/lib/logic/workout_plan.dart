import 'package:GymSpace/global.dart';
import 'package:GymSpace/logic/workout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class WorkoutPlan {
  String name = ""; 
  String author = "";
  String muscleGroup = "";
  String description = "";
  String documentID = "";
  String groupID = "";
  String shareKey = '';
  List<String> workouts = List();
  bool private = false;

  WorkoutPlan({
    this.name = "",
    this.author = "",
    this.muscleGroup = "",
    this.description = "",
    this.documentID = "",
    this.groupID = "",
    this.shareKey = '',
    this.private = false,
    this.workouts,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      'name': name,
      'author': author,
      'muscleGroup': muscleGroup,
      'description': description,
      'groupID': groupID,
      'shareKey': shareKey,
      'private': private,
      'workouts': workouts ?? [],
    };
  }

  // static Future<List<Workout>> getWorkouts(List<String> workoutIDS) async {
  //   List<Workout> workouts = [];
    
  //   for (String id in workoutIDS) {
  //     DocumentSnapshot ds = await DatabaseHelper.getWorkoutSnapshot(id);
  //     Workout workout = Workout.jsonToWorkout(ds.data);
  //     workout.documentID = id;
  //     workouts.add(workout);
  //   }

  //   return workouts;
  // }

  static WorkoutPlan jsonToWorkoutPlan(Map<String, dynamic> data) {
    return WorkoutPlan(
      author: data['author'],
      name: data['name'],
      description: data['description'],
      muscleGroup: data['muscleGroup'],
      groupID: data['groupID'],
      shareKey: data['shareKey'],
      private: data['private'],
      workouts: data['workouts'].cast<String>().toList(),
    );
  }
}