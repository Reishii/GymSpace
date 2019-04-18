import 'meal.dart';
import 'group.dart';
import 'workout_plan.dart';

class User {
  String firstName = "";
  String lastName = "";
  String email = "";
  String liftingType = "";
  String photoURL = "";
  String bio = "";
  List<String> buddies = List();
  int points = 0;
  int age = 0;
  double startingWeight = 0;
  double currentWeight= 0;
  double height = 0;
  List<Group> joinedGroups = List();
  Map diet = Map();
  List<WorkoutPlan> workoutPlans = List();
  
  User({
    this.firstName,
    this.lastName,
    this.email,
    this.bio,
    this.liftingType,
    this.photoURL,
    this.buddies,
    this.points,
    this.age,
    this.startingWeight,
    this.currentWeight,
    this.height,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic> {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'liftingType': liftingType,
      'photoURL': photoURL,
      'bio': bio,
      'buddies': buddies,
      'points': points,
      'age': age,
      'startingWeight': startingWeight,
      'currentWeight': currentWeight,
      'height': height,
      'joinedGroups': joinedGroups,
      'diet': diet,
      'workoutPlans': workoutPlans,
    };
  }
}