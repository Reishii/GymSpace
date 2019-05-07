import 'dart:async';
import 'package:GymSpace/global.dart';
import 'package:GymSpace/logic/workout.dart';
import 'package:GymSpace/logic/workout_plan.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/page_header.dart';
import 'package:GymSpace/widgets/workout_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  String get currentUserID => DatabaseHelper.currentUserID;
  
  void _addPressed() {
    Workout newWorkout = Workout();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          margin: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: _buildForm(newWorkout),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        if (_workoutFormKey.currentState.validate()) {
                          setState(() {
                            _workoutFormKey.currentState.save();
                            print("Adding Workout to database");
                            _addWorkoutToDB(newWorkout);
                            Navigator.pop(context);});
                          }
                      },
                      child: Text(
                        'Create',
                        style: TextStyle(
                          color: GSColors.lightBlue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
        );
      }
    );
  }

  Future<void> _addWorkoutToDB(Workout workout) async {
    workout.author = currentUserID;
    await Firestore.instance.collection('workouts').add(workout.toJSON()).then((ds) async {
        print('-> Added ' + workout.name + ' to the database with id: ' + ds.documentID);
        await DatabaseHelper.updateWorkoutPlan(workoutPlan.documentID, {'workouts': FieldValue.arrayUnion([ds.documentID])})
          .then((_) => Fluttertoast.showToast(msg: 'Added workout to workout plan'));
      });
  }

  Widget _buildForm(Workout workout) {
    return Form(
      key: _workoutFormKey,
      child: Column(
        children: <Widget>[
          TextFormField( // name
            decoration: InputDecoration(
              hintText: "e.g. Back Day",
              labelText: "Workout Name",
            ),
            onSaved: (name) => workout.name = name,
            validator: (value) => value.isEmpty ? "This field cannot be empty" : null,
          ),
          TextFormField( // muscleGroup
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "e.g. This workout consists of exercises for back and biceps. The main motion is pulling.",
              labelText: "Description",
            ),
            onSaved: (muscleGroup) => workout.muscleGroup = muscleGroup,
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
        onPressed: _addPressed,
        backgroundColor: GSColors.purple,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildWorkoutsList() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: StreamBuilder(
        stream: DatabaseHelper.getWorkoutPlanStreamSnapshot(workoutPlan.documentID),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          List<String> workoutIDs = snapshot.data.data['workouts'].cast<String>().toList();

          return ListView.builder(
            itemCount: workoutIDs.length,
            itemBuilder: (context, i) {
              return StreamBuilder(
                stream: DatabaseHelper.getWorkoutStreamSnapshot(workoutIDs[i]),
                builder: (context, workoutSnap) {
                  if (!workoutSnap.hasData) {
                    return Container();
                  }

                  Workout workout = Workout.jsonToWorkout(workoutSnap.data.data);
                  workout.documentID = snapshot.data.documentID;
                  return _buildWorkoutItem(workout);
                }
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildWorkoutItem(Workout workout) {
    return Container(
      // margin: EdgeInsets.all(6),
      child: InkWell(
        onTap: () => _workoutTapped(workout),
        child: WorkoutWidget(workout: workout,),
      ),
    );
  }

  void _workoutTapped(Workout workout) {
    // show
  }

  Future<void> _removeWorkoutFromDB(Workout workout) async {
    // may need to query to get ALL workout plans that contain this workout
    print('Removing workout from the workout plan');
    await Firestore.instance.collection('workoutPlans').document(workoutPlan.documentID)
      .updateData({'workouts': FieldValue.arrayRemove([workout.documentID])})
      .then((_) => print('-> Removed workout from workout plan'))
      .catchError((e) => print('-> Failed to remove workout from workout plan.\nError: $e'));

    // if (false) { // This feature is currently off. Before removing, must check to see if the current user is the author of the workout
    //   await Firestore.instance.collection('workouts').document(workout.documentID).delete()
    //     .then((_) => print('-> Removed workout from collection.'))
    //     .catchError((e) => print('-> Failed to remove workout from colection.\nError: $e'));
    // }

    workoutPlan.workouts.remove(workout);
  }
}