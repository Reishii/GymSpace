import 'workout.dart';

class WorkoutPlan {
  String name = ""; 
  String author = "";
  String muscleGroup = "";
  String description = "";
  List<Workout> workouts = List();

  WorkoutPlan({String name = "", String author = "", String muscleGroup = "", String description = "", List<Workout> workouts}) {
    this.name = name;
    this.author = author;
    this.muscleGroup = muscleGroup;
    this.description = description;
    this.workouts = workouts;
  }
}