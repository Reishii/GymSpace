import 'meal.dart';
import 'group.dart';

class User {
  String _name;
  String _username;
  String _liftingType;
  String _email;
  int _points = 0;
  int _age = 0;
  double _height = 0;
  double _weight = 0;
  Map _goals = { // maybe change to an array
    'time': 0,
    'targetWeight': 0,
    'liftingWeight': 0
  };
  
  List<Group> _joinedGroups = new List();
  List<Meal> _diet = new List();
  List<User> _friends = new List(); // new from UML

  User([
    this._name, 
    this._username,
    this._liftingType,
    this._email,
    this._points,
    this._height,
    this._weight,
    this._age,
    this._goals,
    this._joinedGroups,
    this._diet
    ]);

  String getName() => _name;
  String getUsername() => _username;
  String getLiftingType() => _liftingType;
  int getPoints() => _points;
  int getAge() => _age;
  double getHeight() => _height;
  double getWeight() => _weight;
  Map getGoals() => _goals;
  List<Group> getJoinedGroups() => _joinedGroups;
  List<Meal> getDiet() => _diet;
  List<User> getFriends() => _friends; // new from UML
}