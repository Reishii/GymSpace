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
  String documentID = "";
  List<String> buddies = List();
  List<String> photos = List();
  int points = 0;
  int age = 0;
  double startingWeight = 0;
  double currentWeight= 0;
  double height = 0;
  List<Group> joinedGroups = List();
  Map diet = Map();
  List<WorkoutPlan> workoutPlans = List();
  List<int> challengeStatus = List();
  int caloricGoal = 0;
  String fcmToken ="";
  bool private = true;
  bool location = true;
  bool notification = true;
  User({
    this.firstName = "",
    this.lastName = "",
    this.email = "",
    this.bio = "",
    this.liftingType = "",
    this.photoURL = "",
    this.buddies,
    this.photos,
    this.points = 0,
    this.age = 0,
    this.startingWeight = 0,
    this.currentWeight = 0,
    this.height = 0,
    this.joinedGroups,
    this.diet,
    this.workoutPlans,
    this.challengeStatus,
    this.caloricGoal = 0,
    this.fcmToken = "",
    this.private,
    this.location,
    this.notification
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
      'photos': photos == null ? [] : photos,
      'points': points,
      'age': age,
      'startingWeight': startingWeight,
      'currentWeight': currentWeight,
      'height': height,
      'joinedGroups': joinedGroups == null ? [] : joinedGroups,
      'diet': diet == null ? Map() : diet,
      'workoutPlans': workoutPlans == null ? [] : workoutPlans,
      'challengeStatus' : challengeStatus == null ? [0, 0, 0] : challengeStatus,
      'caloricGoal' : caloricGoal,
      'fcmToken' : fcmToken,
      'private' : private,
      'location' : location,
      'notification': notification
    };
  }

  static User jsonToUser(Map<String, dynamic> data) {
    return User(
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      liftingType: data['liftingType'],
      photoURL: data['photoURL'],
      bio: data['bio'],
      buddies: data['buddies'].cast<String>(),
      //photos: data['photos'].cast<String>(),
      points: data['points'].round(),
      age: data['age'].round(),
      startingWeight: data['startingWeight'].toDouble(),
      currentWeight: data['currentWeight'].toDouble(),
      height: data['height'].toDouble(),
      // joinedGroups: data['joinedGroups'],
      diet: data['diet'],
      // workoutPlans: {}}
      challengeStatus: data['challengeStatus'].cast<int>(),
      caloricGoal: data['caloricGoal'].round(),
      fcmToken: data['fcmToken'],
      private: data['private'],
      location: data['location'],
      notification: data['notification'],
    );
  }
}