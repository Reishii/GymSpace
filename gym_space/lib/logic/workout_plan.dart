import 'workout.dart';

class WorkoutPlan {
  String name = ""; 
  String author = "";
  String muscleGroup = "";
  String description = "";
  List<Workout> workouts = List();

  WorkoutPlan({
    this.name = "",
    this.author = "",
    this.muscleGroup = "",
    this.description = "",
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
}