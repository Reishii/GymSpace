import 'package:GymSpace/logic/workout.dart';
import 'package:GymSpace/logic/workout_plan.dart';
import 'package:meta/meta.dart';

class Group {
  String admin;
  String name;
  String bio;
  String photoURL;
  String status;
  String startDate; //yyyy-mm-dd
  String endDate;

  int likes;

  // Workout currentWorkout;
  // WorkoutPlan currentWorkoutPlan;

  List<String> members;
  List<String> workoutPlans;

  Group({
    @required this.admin,
    @required this.name,
    this.bio = "",
    this.photoURL = "",
    this.status = "",
    this.startDate = "",
    this.endDate = "",
    this.likes = 0,
    this.members,
    this.workoutPlans,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic> {
      'admin': admin,
      'name': name,
      'bio': bio,
      'photoURL': photoURL,
      'status': status,
      'startDate': startDate,
      'endDate': endDate,
      'likes': likes,
      'members': members ?? [],
      'workoutPlans': workoutPlans ?? [],
    };
  }

  static Group jsonToUser(Map<String, dynamic> data) {
    return Group(
      admin: data['admin'],
      name: data['name'],
      bio: data['bio'],
      photoURL: data['photoURL'],
      status: data['status'],
      startDate: data['startDate'],
      endDate: data['endDate'],
      likes: data['likes'],
      members: data['members'].cast<String>(),
      workoutPlans: data['workoutPlans'].cast<String>(),
    );
  }
}