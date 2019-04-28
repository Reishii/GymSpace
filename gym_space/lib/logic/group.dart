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
  String documentID;

  // Workout currentWorkout;
  // WorkoutPlan currentWorkoutPlan;

  List<String> likes = List();
  List<String> members = List();
  List<String> workoutPlans = List();

  Group({
    @required this.admin,
    @required this.name,
    this.bio = "",
    this.photoURL = "",
    this.status = "",
    this.startDate = "",
    this.endDate = "",
    this.documentID,
    this.likes,
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
      'likes': likes ?? [],
      'members': members ?? [],
      'workoutPlans': workoutPlans ?? [],
    };
  }

  static Group jsonToGroup(Map<String, dynamic> data) {
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