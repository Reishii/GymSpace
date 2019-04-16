import 'exercise.dart';

class Workout {
  String name;
  String author;
  String muscleGroup;
  String description;
  List<Exercise> exercises = List();
  
  Workout({String name = "", String author = "", String muscleGroup = "", String description = "", List<Exercise> exercises}) {
    this.name = name;
    this.author = author;
    this.muscleGroup = muscleGroup;
    this.description = description;
    this.exercises = exercises;
  }
} 