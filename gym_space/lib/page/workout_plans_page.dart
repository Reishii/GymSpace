import 'package:flutter/material.dart';
// import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:GymSpace/widgets/page_header.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/test_users.dart';
import 'package:GymSpace/logic/workout_plan.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:GymSpace/logic/workout.dart';
import 'package:GymSpace/logic/exercise.dart';
import 'package:GymSpace/widgets/app_drawer.dart';

class WorkoutPlanHomePage extends StatelessWidget {
  final Widget child;

  WorkoutPlanHomePage({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      backgroundColor: GSColors.darkBlue,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140),
        child: PageHeader(
          'Workout Plans', 
          Colors.white, 
          // showDrawer: true,
          menuColor: GSColors.darkBlue,
        ),
      ),
      // body: Text("data", style: TextStyle(color: Colors.white)),
      body: Container(
        child: _buildWorkoutPlansList(),
      )
    );
  }

  Widget _buildWorkoutPlansList() {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: rolly.workoutPlans.length,
      itemBuilder: (BuildContext context, int i) {
        // return WorkoutPlanWidget(rolly.workoutPlans[i]);
        return Container(
          height: 200,
          margin: EdgeInsets.symmetric(vertical: 16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            )
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (context) {
                  return WorkoutPlanPage(rolly.workoutPlans[i]);
                }
              ));
            },
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Center(
                  child: Text(
                    rolly.workoutPlans[i].name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 2,
                    ),
                  ),
                )
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    rolly.workoutPlans[i].description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1.5
                    ),
                  ),
                ),
              )
              ],
            ),
          ),
        ); 
      },
    );
  }
}

class WorkoutPlanPage extends StatelessWidget {
  final Widget child;
  final WorkoutPlan _workoutPlan;
  bool isExpanded = false;

  WorkoutPlanPage(this._workoutPlan, {Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GSColors.darkBlue,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140),
        child: PageHeader(_workoutPlan.name, Colors.white),
      ),
      body: _buildWorkoutsList(),
    );
  }

  Widget _buildWorkoutsList() {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: _workoutPlan.workouts.length,
      itemBuilder: (BuildContext context, int i) {
        return WorkoutWidget(_workoutPlan.workouts[i]);
      },
    );
  }
}

class WorkoutWidget extends StatefulWidget {
  final Widget child;
  final Workout _workout;

  WorkoutWidget(this._workout, {Key key, this.child}) : super(key: key);

  _WorkoutWidgetState createState() => _WorkoutWidgetState(_workout);
}

class _WorkoutWidgetState extends State<WorkoutWidget> {
  final Workout workout;
  bool isExpanded = false;

  _WorkoutWidgetState(this.workout);

  @override
  Widget build(BuildContext context) {
    return Container(
       height: isExpanded ? 60.0 + workout.exercises.length * 70 : 60,
       margin: EdgeInsets.symmetric(vertical: 16),
       decoration: ShapeDecoration(
         color: Colors.white,
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(20),
         )
       ),
       child: InkWell(
         onTap: () {
           setState(() {
             isExpanded = !isExpanded;
           });
         },
         onLongPress: _showWorkoutDialog,
         child: Column(
           children: <Widget>[
             Row(
               children: <Widget>[
                 Expanded(
                   flex: 2,
                   child: Container(
                    margin: EdgeInsets.only(top: 16, left: 50),
                    child: Text(
                      workout.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 2,
                      ),
                    )
                   ),
                 ),
                 Expanded(
                   flex: 1,
                   child: Container(
                     margin: EdgeInsets.only(top: 16),
                     child: Icon(
                      isExpanded ? FontAwesomeIcons.caretUp : FontAwesomeIcons.caretDown, 
                      color: Colors.black26
                     ),
                   ),
                 ),
               ],
             ),
            isExpanded ? _expandWidget() : Container()
           ],
         ),
       ),
    );
  }

  Widget _expandWidget() {
    List<Widget> exercises = List();
    
    for (Exercise exercise in workout.exercises) {
      exercises.add(
        Container(
          margin: EdgeInsets.only(top: 20, left: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                exercise.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, left: 20),
                child: Text(
                  exercise.sets.toString() + " sets of " + exercise.reps.toString() + " reps",
                  style:TextStyle(
                    fontSize: 14,
                    fontWeight:FontWeight.w200,
                  ),
                ),
              )
            ]
          ),
        )
      );
    }

    return Container(
      // margin: EdgeInsets.only(left: 70),
      alignment: FractionalOffset.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: exercises,
      ),
    );
  }

  void _showWorkoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Row(
            children: <Widget>[
              Container(
                child: Text(workout.name),
              ),
              Container(
                margin: EdgeInsets.only(left: 140),
                child: Text(
                  workout.author,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              )
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          contentPadding: EdgeInsets.all(30),
          children: <Widget>[
            Text(
              workout.description,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
            )
          ],
        );
      }
    );
  }
}