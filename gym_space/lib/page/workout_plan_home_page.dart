import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:GymSpace/global.dart';
import 'package:GymSpace/page/workout_plan_page.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/logic/workout_plan.dart';
import 'package:GymSpace/widgets/page_header.dart';
import 'package:GymSpace/widgets/app_drawer.dart';

class WorkoutPlanHomePage extends StatefulWidget {
  final Widget child;

  WorkoutPlanHomePage({Key key, this.child}) : super(key: key);
  _WorkoutPlanHomePageState createState() => _WorkoutPlanHomePageState();

}

class _WorkoutPlanHomePageState extends State<WorkoutPlanHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<DocumentSnapshot> _futureUser =  DatabaseHelper.getUserSnapshot(DatabaseHelper.currentUserID);


  void _addPressed(BuildContext currentContext) {
    showDialog(
      context: currentContext,
      builder: (context) {
        WorkoutPlan newWorkoutPlan = WorkoutPlan(author:  DatabaseHelper.currentUserID);

        return SafeArea(
          child: SimpleDialog(
            title: Text("Add Workout Plan", textAlign: TextAlign.center),
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
                  child: _buildForm(newWorkoutPlan),
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
                        _formKey.currentState.reset();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SimpleDialogOption(
                    child: MaterialButton(
                      child: Text("Add"),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _formKey.currentState.save();
                            print("Adding Workout Plan to database");
                            _addWorkoutPlanToDB(newWorkoutPlan);
                            Navigator.pop(context);});
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

  void _addWorkoutPlanToDB(WorkoutPlan workoutPlan) async {
    DocumentReference workoutPlanDocument = await Firestore.instance.collection('workoutPlans').add(workoutPlan.toJSON());
    _futureUser.then((ds) {
      // update id of workoutPlan
      workoutPlanDocument.updateData({'documentID': workoutPlanDocument.documentID})
        .then((_) =>
          print('-> Added ' + workoutPlan.name + ' to the database with id: ' + workoutPlanDocument.documentID))
        .catchError((e) =>
          print('-> Failed to add workoutPlan to the database.\nError: $e')
        );

      // add new workout plan to users
      Firestore.instance.collection('users').document( DatabaseHelper.currentUserID)
        .updateData({'workoutPlans': FieldValue.arrayUnion([workoutPlanDocument.documentID])});
    });
    _futureUser = DatabaseHelper.getUserSnapshot(DatabaseHelper.currentUserID);
  }

  Widget _buildForm(WorkoutPlan workoutPlan) {
    return Form(
      key: _formKey,
      // autovalidate: true,
      child: Column(
        children: <Widget>[
          TextFormField( // name
            decoration: InputDecoration(
              icon: Icon(
                FontAwesomeIcons.angleRight,
                color: GSColors.darkBlue,
                size: 30,
              ),
              hintText: "e.g. Best workout plan!",
              labelText: "Name",
            ),
            onSaved: (name) => workoutPlan.name = name,
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
            onSaved: (muscleGroup) => workoutPlan.muscleGroup = muscleGroup,
            validator: (value) => value.isEmpty ? "This field cannot be empty" : null,
          ),
          TextFormField( // description
            decoration: InputDecoration(
              icon: Icon(
                FontAwesomeIcons.angleRight,
                color: GSColors.darkBlue,
                size: 30,
              ),
              hintText: "e.g. This plan is to get you ripped fast day.",
              labelText: "Description",
            ),
            onSaved: (desc) => workoutPlan.description = desc,
            validator: (value) => value.isEmpty ? "This field cannot be empty" : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(startPage: 1,),
      backgroundColor: GSColors.darkBlue,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          FontAwesomeIcons.plus,
          size: 14,
          color: Colors.white
        ),
        backgroundColor: GSColors.purple,
        onPressed: () => _addPressed(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: _buildAppBar(),
      body: Container(
        child: _buildWorkoutPlansList(),
      )
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: PageHeader(
        title: 'Workout Plans', 
        backgroundColor: Colors.white,
        showDrawer: true,
        titleColor: GSColors.darkBlue,
      ),
    );
  }

  Widget _buildWorkoutPlansList() {
    return FutureBuilder(
      // stream: _futureUser.asStream(),
      future: DatabaseHelper.getUserSnapshot(DatabaseHelper.currentUserID),
      builder: (context, snapshot) {
         var userWorkoutPlansIDs = snapshot.hasData && snapshot.data['workoutPlans'] != null 
          ? snapshot.data['workoutPlans'] : List();

        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: userWorkoutPlansIDs.length,
          itemBuilder: (BuildContext context, int i) {
            return FutureBuilder(
              // stream: DatabaseHelper.getWorkoutPlanSnapshot(userWorkoutPlansIDs[i]).asStream(),
              future: DatabaseHelper.getWorkoutPlanSnapshot(userWorkoutPlansIDs[i]),
              builder: (context, snapshot) {
                return snapshot.hasData
                  ? FutureBuilder(
                    future: WorkoutPlan.jsonToWorkoutPlan(snapshot.data.data, snapshot.data.documentID),
                    builder: (context, snapshot) => _buildWorkoutPlanItem(context, snapshot.data),
                  )
                  : Container();
              },
            );
          },
        );
      }
    );
  }

  Widget _buildWorkoutPlanItem(BuildContext context, WorkoutPlan workoutPlan) {
    if (workoutPlan == null) {
      return Container();
    }

    void _planTapped(BuildContext context) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => WorkoutPlanPage(workoutPlan: workoutPlan,)
      ));
    }

    Future<void> _removeWorkoutPlanFromDB() async {
      await Firestore.instance.collection('users').document(DatabaseHelper.currentUserID)
        .updateData({'workoutPlans': FieldValue.arrayRemove([workoutPlan.documentID])})
        .then((_) => print('-> Removed workout plan from current users workoutPlans'))
        .catchError((e) => print('-> Failed to remove workout plan from user.\nError: $e'));

      print('Removing workoutPlan from collection');
      await Firestore.instance.collection('workoutPlans').document(workoutPlan.documentID)
        .delete().then((_) => print("-> Removed workout plan from workoutPlans collection"))
        .catchError((e) => print('-> Failed to remove workout plan from collection.\nError: $e'));
    }

    void _planLongPressed(BuildContext context) async {
      // remove from database
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete workout plan?'),
            content: Text('Tap Delete to remove ' + workoutPlan.name),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text('Delete'),
                onPressed: () {
                    setState((){
                      _removeWorkoutPlanFromDB().then((_) {
                      // now close dialog and refresh list
                        Navigator.pop(context);
                    });
                  });
                },
              )
            ],
          );
        },
      );
    }

    return InkWell(
      onTap: () { _planTapped(context);},
      onLongPress: () { _planLongPressed(context);},
      child: Container(
        height: 200,
        margin: EdgeInsets.symmetric(vertical: 16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  workoutPlan.name,
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
                  workoutPlan.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.5
                  ),
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    workoutPlan.workouts.length.toString() + ' workouts'
                  ),
                  FutureBuilder(
                    future: DatabaseHelper.getUserSnapshot(workoutPlan.author),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        String name = snapshot.data['firstName'] + ' ' + snapshot.data['lastName'];
                        return Text('By: $name');
                      }
                      
                      return Container();
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}