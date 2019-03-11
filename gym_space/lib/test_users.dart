import 'logic/user.dart';
import 'logic/group.dart';
import 'logic/meal.dart';
import 'logic/exercise.dart';
import 'logic/workout.dart';
import 'logic/workout_plan.dart';
import 'global.dart';


Exercise bicepCurls = new Exercise("bicep curls", "arms");
Exercise tricepPulldown = new Exercise("tricep pulldowns", "arms");
Exercise benchPress = new Exercise("bench press", "chest");

Workout pushDay = new Workout(
  "push day",
  "Rolly Lacap",
  "chest, shoulders, triceps",
  [tricepPulldown, benchPress]
);

Workout pullDay = new Workout(
  "pull day",
  "Rolly Lacap",
  "back, biceps",
  [bicepCurls]
);

WorkoutPlan broPlan = new WorkoutPlan(
  "bro",
  "Rolly Lacap",
  "",
  [pushDay, pullDay]
);
WorkoutPlan bodyBuilding = new WorkoutPlan(
  "body buliding",
  "Rolly Lacap",
  "",
  [pushDay]
);

WorkoutPlan powerLifting = new WorkoutPlan(
  "power lifting",
  "Rolly Lacap",
  "",
  [pushDay]
);

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
  rollyGoals,   // goals
  rollyGroups,  // groups
  rollyDiet,    // diet
  [],           // friends
  [broPlan, bodyBuilding, powerLifting]     // workout plans
);

User john = new User('johnd', 'john@gmail.com');
