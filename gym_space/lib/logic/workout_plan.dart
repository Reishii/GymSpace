import 'workout.dart';

class WorkoutPlan {
  String _name; 
  String _author;
  String _muscleGroup;
  List<Workout> workouts;

  WorkoutPlan([this._name, this._author, this._muscleGroup, this.workouts]);
  
  String getName() => _name;
  String getAuthor() => _author;
  String getMuscleGroup() => _muscleGroup;
  void setName(String name) => _name = name;
  void setAuthor(String author) => _author = author;
  void setMuscleGroup(String muscleGroup) => _muscleGroup = muscleGroup;
}