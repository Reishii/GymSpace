import 'logic/user.dart';
import 'logic/group.dart';
import 'logic/meal.dart';

List<Meal> rollyDiet = [
  Meal(),
  Meal(),
  Meal(),
];

Map rollyGoals = {};
List<Group> rollyGroups = [];
String rollyImage = 'https://cdn.pixabay.com/photo/2016/12/13/16/17/dancer-1904467_960_720.png';

User rolly = new User(
  'rollininrice', 
  'rolly@gmail.com',
  'Rolly Lacap',
  'body building',
  200,  // points
  178,  // height
  200,  // weight
  22,   // age
  rollyGoals,
  rollyGroups,
  rollyDiet
  );

User john = new User('johnd', 'john@gmail.com');

