import 'meal.dart';
import 'group.dart';
import 'workout_plan.dart';

class User {
  String _name;
  final String _username;
  String _liftingType;
  final String _email;
  int _points = 0;
  int _age = 0;
  double _height = 0;
  double _weight = 0;
  Map _goals = { // maybe change to an array
    'time': 0,
    'targetWeight': 0,
    'liftingWeight': 0
  };
  
  List<Group> joinedGroups = new List();
  Map diet = new Map();
  List<User> friends = new List(); // new from UML
  List<WorkoutPlan> workoutPlans = new List();

  User(
    this._username,
    this._email,
    [
      this._name, 
      this._liftingType,
      this._points,
      this._height,
      this._weight,
      this._age,
      this._goals,
      this.joinedGroups,
      this.diet,
      this.friends,
      this.workoutPlans,
    ]);

  String getName() => _name;
  String getUsername() => _username;
  String getEmail() => _email;
  String getLiftingType() => _liftingType;
  int getPoints() => _points;
  int getAge() => _age;
  double getHeight() => _height;
  double getWeight() => _weight;
  Map getGoals() => _goals; // new from UML
  void setName(String name) => _name = name;
  void setLiftingType(String type) => _liftingType = type;
  void updatePoints(int points) => _points += points;
  void setAge(int age) => _age = age;
  void setHeight(double height) => _height = height;
  void setWeight(double weight) => _weight = weight;
}