import 'logic/user.dart';
import 'logic/group.dart';
import 'logic/meal.dart';

List<Meal> rollyTodayDiet = [
  Meal(protein: 100, carbs: 700, fats: 300),
  Meal(protein: 200, carbs: 300, fats: 200),
  Meal(protein: 300, carbs: 600, fats: 400),
];

Map rollyDiet = {
  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day) : rollyTodayDiet,
};

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

