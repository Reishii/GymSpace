import 'logic/user.dart';
import 'logic/group.dart';
import 'logic/meal.dart';
import 'logic/exercise.dart';
import 'logic/workout.dart';
import 'logic/workout_plan.dart';
import 'logic/friend.dart';


Exercise bicepCurls = new Exercise(
  name: "bicep curls", 
  bodyPart: "arms",
  sets: 3,
  reps: 8 
);
Exercise tricepPulldown = new Exercise(
  name: "tricep pulldowns", 
  bodyPart: "arms",
  sets: 3,
  reps: 8  
);
Exercise benchPress = new Exercise(
  name: "bench press", 
  bodyPart: "chest",
  sets: 5,
  reps: 5  
);

Workout pushDay = new Workout(
  name: "push day",
  author: "Rolly Lacap",
  muscleGroup: "chest, shoulders, triceps",
  description: "This workout is designed for push exercises. Be ready to get a huge pump in your chest and triceps!",
  exercises: [benchPress, tricepPulldown, bicepCurls, benchPress]
);

Workout pullDay = new Workout(
  name: "pull day",
  author: "Rolly Lacap",
  muscleGroup: "back, biceps",
  exercises: [bicepCurls]
);

WorkoutPlan broPlan = new WorkoutPlan(
  name: "bro",
  author: "Rolly Lacap",
  description: "A workout plan for the bros! This 3 day split includes: a push day, pull day, and a leg day.",
  workouts: [pushDay, pullDay]
);
WorkoutPlan bodyBuilding = new WorkoutPlan(
  name: "body buliding",
  author: "Rolly Lacap",
  description: "This workout plan is for the serious body builders. Get that lean and cut muscle in no time!",
  workouts: [pushDay]
);

WorkoutPlan powerLifting = new WorkoutPlan(
  name: "power lifting",
  author: "Rolly Lacap",
  description: "",
  workouts: [pushDay]
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
