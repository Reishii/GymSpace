import 'dart:async';
import 'package:GymSpace/global.dart';
import 'package:GymSpace/logic/workout.dart';
import 'package:GymSpace/logic/workout_plan.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/page_header.dart';
import 'package:GymSpace/widgets/workout_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WorkoutPlanPage extends StatefulWidget {
  final Widget child;
  final WorkoutPlan workoutPlan;

  WorkoutPlanPage({
    @required this.workoutPlan, Key key, this.child
  }) : super(key: key);

  @override
  _WorkoutPlanPageState createState() => _WorkoutPlanPageState();
}

class _WorkoutPlanPageState extends State<WorkoutPlanPage> {

  WorkoutPlan get workoutPlan => widget.workoutPlan;
  final GlobalKey<FormState> _workoutFormKey = GlobalKey<FormState>();
  Future<DocumentSnapshot>_futureUser = DatabaseHelper.getUserSnapshot(DatabaseHelper.currentUserID);
  
  void _addPressed(BuildContext currentContext) {
    showDialog(
      context: currentContext,
      builder: (context) {
        Workout newWorkout = Workout();
        newWorkout.exercises = Map();
        return SafeArea(
          child: SimpleDialog(
            title: Text("Add Workout", textAlign: TextAlign.center),
            titlePadding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  color: GSColors.darkBlue,
                  height: 1,
                ),
              ),
              SafeArea(
                child: Container(
                  margin: EdgeInsets.only(left: 16, right: 40),
                  height: 260,
                  width: double.maxFinite,
                  child: _buildForm(newWorkout),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SimpleDialogOption(
                    child: MaterialButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        print("Resetting form");
                        _workoutFormKey.currentState.reset();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SimpleDialogOption(
                    child: MaterialButton(
                      child: Text("Add"),
                      onPressed: () async {
                        if (_workoutFormKey.currentState.validate()) {
                          print("Adding Workout to database");
                          _workoutFormKey.currentState.save();
                          await _addWorkoutToDB(newWorkout);
                          setState(() {
                            Navigator.pop(context);
                          });
                        }
                      },
                    ),
                  )
                ],
              )
            ],
          )
        );
      },
    );
  }

  Future<void> _addWorkoutToDB(Workout workout) async {
    // add to collection
    DocumentReference workoutDocument = await Firestore.instance.collection('workouts')
      .add(workout.toJSON()).then((ds) {
        print('-> Added ' + workout.name + ' to the database with id: ' + ds.documentID);
        return ds;
      }).catchError((e) => print('Error: $e'));

    // add to workout plan
    _futureUser.then((ds) {
      Firestore.instance.collection('workoutPlans').document(workoutPlan.documentID)
        .updateData({'workouts': FieldValue.arrayUnion([workoutDocument.documentID])});
        workoutPlan.workouts.add(workout);
    });

    _futureUser = DatabaseHelper.getUserSnapshot(DatabaseHelper.currentUserID);
  }

  Widget _buildForm(Workout workout) {
    return Form(
      key: _workoutFormKey,
      child: ListView(
        children: <Widget>[
          TextFormField( // name
            decoration: InputDecoration(
              icon: Icon(
                FontAwesomeIcons.angleRight,
                color: GSColors.darkBlue,
                size: 30,
              ),
              hintText: "e.g. Best workout!",
              labelText: "Name",
            ),
            onSaved: (name) => workout.name = name,
            validator: (value) => value.isEmpty ? "This field cannot be empty" : null,
          ),
          TextFormField( // muscleGroup
            decoration: InputDecoration(
              icon: Icon(
                FontAwesomeIcons.angleRight,
                color: GSColors.darkBlue,
                size: 30,
              ),
              hintText: "e.g. Chest",
              labelText: "Muscle Group",
            ),
            onSaved: (muscleGroup) => workout.muscleGroup = muscleGroup,
            validator: (value) => value.isEmpty ? "This field cannot be empty" : null,
          ),
          TextFormField( // description
            decoration: InputDecoration(
              icon: Icon(
                FontAwesomeIcons.angleRight,
                color: GSColors.darkBlue,
                size: 30,
              ),
              hintText: "e.g. This workout is for chest day.",
              labelText: "Description",
            ),
            onSaved: (desc) => workout.description = desc,
            validator: (value) => value.isEmpty ? "This field cannot be empty" : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GSColors.darkBlue,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: PageHeader(
          title: workoutPlan.name, 
          backgroundColor: Colors.white,
          titleColor: GSColors.darkBlue,
        ),
      ),
      body: _buildWorkoutsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addPressed(context),
        backgroundColor: GSColors.purple,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildWorkoutsList() {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: workoutPlan.workouts.length,
      itemBuilder: (BuildContext context, int i) {
        // print("Currently there are $count workouts in this plan.");
        Workout workout = workoutPlan.workouts[i];
        return InkWell(
          onLongPress: () {
            _showWorkoutDialog(context, workout);
          },
          child: WorkoutWidget(workout: workout),
        );
      },
    );
  }

  Future<void> _removeWorkoutFromDB(Workout workout) async {
    // may need to query to get ALL workout plans that contain this workout
    print('Removing workout from the workout plan');
    await Firestore.instance.collection('workoutPlans').document(workoutPlan.documentID)
      .updateData({'workouts': FieldValue.arrayRemove([workout.documentID])})
      .then((_) => print('-> Removed workout from workout plan'))
      .catchError((e) => print('-> Failed to remove workout from workout plan.\nError: $e'));

    if (false) { // This feature is currently off. Before removing, must check to see if the current user is the author of the workout
      await Firestore.instance.collection('workouts').document(workout.documentID).delete()
        .then((_) => print('-> Removed workout from collection.'))
        .catchError((e) => print('-> Failed to remove workout from colection.\nError: $e'));
    }

    workoutPlan.workouts.remove(workout);
  }

  void _showWorkoutDialog(BuildContext context, Workout workout) {
    void _deletePressed() {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Are you sure you want to delete ' + workout.name + '?'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              MaterialButton(
                child: Text('Delete'),
                onPressed: () async  {
                  await _removeWorkoutFromDB(workout).then((_) {
                  // now pop the dialog and refresh the list of workouts
                    setState(() {
                      Navigator.pop(context);
                    });
                  });
                },
              ),
            ],
          );
        }
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
          // contentPadding: EdgeInsets.all(30),
          content: Text(
            workout.description,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text("Close"),
              onPressed: () => Navigator.pop(context),
            ),
            MaterialButton(
              child: Text("Delete"),
              onPressed: () {
                _deletePressed();
              },
            )
          ],
          // children: <Widget>[
          //   Text(
          //     workout.description,
          //     textAlign: TextAlign.left,
          //     style: TextStyle(
          //       fontWeight: FontWeight.w300,
          //     ),
          //   )
          // ],
        );
      }
    );
  }
}