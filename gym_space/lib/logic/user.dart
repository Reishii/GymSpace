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
    this.firstName = "",
    this.lastName = "",
    this.email = "",
    this.bio = "",
    this.liftingType = "",
    this.photoURL = "",
    this.buddies,
    this.points = 0,
    this.age = 0,
    this.startingWeight = 0,
    this.currentWeight = 0,
    this.height = 0,
    this.joinedGroups,
    this.diet,
    this.workoutPlans,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic> {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'liftingType': liftingType,
      'photoURL': photoURL,
      'bio': bio,
      'buddies': buddies == null ? [] : buddies,
      'points': points,
      'age': age,
      'startingWeight': startingWeight,
      'currentWeight': currentWeight,
      'height': height,
      'joinedGroups': joinedGroups == null ? [] : joinedGroups,
      'diet': diet == null ? Map() : diet,
      'workoutPlans': workoutPlans == null ? [] : workoutPlans,
    };
  }
}