import 'package:GymSpace/global.dart';
import 'package:GymSpace/logic/workout.dart';
import 'package:GymSpace/logic/workout_plan.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/page_header.dart';
import 'package:GymSpace/widgets/workout_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WorkoutPlanPage extends StatelessWidget {
  final Widget child;
  final WorkoutPlan workoutPlan;
  final GlobalKey<FormState> _workoutFormKey = GlobalKey<FormState>();
  Future<DocumentSnapshot>_futureUser = DatabaseHelper.getUserSnapshot(DatabaseHelper.currentUserID);

  WorkoutPlanPage({
    @required this.workoutPlan, Key key, this.child
  }) : super(key: key);

  void _addPressed(BuildContext currentContext) {
    showDialog(
      context: currentContext,
      builder: (context) {
        Workout newWorkout = Workout();
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
                      onPressed: () {
                        if (_workoutFormKey.currentState.validate()) {
                          _workoutFormKey.currentState.save();
                          print("Adding Workout to database");
                          _addWorkoutToDB(newWorkout);
                          Navigator.pop(context);
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

  void _addWorkoutToDB(Workout workout) async {
    DocumentReference workoutDocument = await Firestore.instance.collection('workouts')
      .add(workout.toJSON()).then((ds) {
        print('Added ' + workout.name + ' to the database with id: ' + ds.documentID);
        return ds;
      }).catchError((e) => print('Error: $e'));

    _futureUser.then((ds) {
      Firestore.instance.collection('workoutPlans').document(workoutPlan.documentID)
        .updateData({'workouts': FieldValue.arrayUnion([workoutDocument.documentID])});
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
        return WorkoutWidget(workout: workoutPlan.workouts[i]);
      },
    );
  }
}