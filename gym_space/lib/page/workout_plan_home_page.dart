import 'dart:async';
import 'package:GymSpace/logic/workout.dart';
import 'package:GymSpace/widgets/workout_plan_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:GymSpace/global.dart';
import 'package:GymSpace/page/workout_plan_page.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/logic/workout_plan.dart';
import 'package:GymSpace/widgets/page_header.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:GymSpace/notification_page.dart';

class WorkoutPlanHomePage extends StatefulWidget {
  WorkoutPlanHomePage({Key key, this.child}) : super(key: key);

  final Widget child;

  _WorkoutPlanHomePageState createState() => _WorkoutPlanHomePageState();
}

class _WorkoutPlanHomePageState extends State<WorkoutPlanHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<DocumentSnapshot> _futureUser =  DatabaseHelper.getUserSnapshot(DatabaseHelper.currentUserID);
  final localNotify = FlutterLocalNotificationsPlugin();
  // Local Notification Plugin
  @override
  void initState() {
    super.initState();
    final settingsAndriod = AndroidInitializationSettings('@mipmap/ic_launcher');
    final settingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) =>
        onSelectNotification(payload));
    localNotify.initialize(InitializationSettings(settingsAndriod, settingsIOS),
      onSelectNotification: onSelectNotification);
  }
  Future onSelectNotification(String payload) async  {
    Navigator.pop(context);
    print("==============OnSelect WAS CALLED===========");
    await Navigator.push(context, new MaterialPageRoute(builder: (context) => NotificationPage()));
  } 
  final TextEditingController _shareKeyController = TextEditingController();
  List<String> deadWorkoutPlansIDs = List();
  String get currentUserID => DatabaseHelper.currentUserID;

  void _addPressed(BuildContext currentContext) {
    showDialog(
      context: currentContext,
  Future<void> _validateShareKey() async {
    if (_shareKeyController.text.length != 6) {
      Fluttertoast.showToast(msg: 'Invalid Key: Must be 6 characters!');
      return;
    }

    Fluttertoast.showToast(msg: 'Validating key...');
    // search DB for key
    DocumentSnapshot ds = await DatabaseHelper.findWorkoutPlanByKey(_shareKeyController.text);
    if (ds == null) {
      Fluttertoast.showToast(msg: 'Invalid Key: Keys are case sensitive');
      return;
    } else if (ds.data['private']) {
      Fluttertoast.showToast(msg: 'This workout plan is private (not shareable)');
      return;
    } 
    
    DocumentSnapshot userSnap = await DatabaseHelper.getUserSnapshot(currentUserID);
    if (userSnap.data['workoutPlans'].contains(ds.documentID)) {
      Fluttertoast.showToast(msg: 'Already have workout plan: ${ds.data['name']}');
      return;
    }
    
    Fluttertoast.showToast(msg: 'Adding workout plan: ${ds.data['name']}');
    await DatabaseHelper.updateUser(currentUserID, {'workoutPlans': FieldValue.arrayUnion([ds.documentID])});
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.pop(context);
  }

  void _showShareKeySheet(WorkoutPlan workoutPlan) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          margin: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: _shareKeyController,
                  decoration: InputDecoration(
                    hintText: 'Enter 6 character share key (case-sensitive)',
                    suffixIcon: IconButton(
                      color: GSColors.lightBlue,
                      icon: Icon(Icons.add),
                      onPressed: _validateShareKey,
                    )
                  ),
                )
              ),
            ],
          ) 
        );
      }
    );
  }

  void _addPressed() {
    WorkoutPlan newWorkoutPlan = WorkoutPlan();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          margin: MediaQuery.of(context).viewInsets,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: _buildForm(newWorkoutPlan),
                // margin: EdgeInsets.only(bottom: 20),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () => _showShareKeySheet(newWorkoutPlan),
                      child: Text(
                        'Have a share key?',
                        style: TextStyle(
                          color: GSColors.green,
                          fontSize: 16
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _formKey.currentState.save();
                            print("Adding Workout Plan to database");
                            _addWorkoutPlanToDB(newWorkoutPlan);
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

  void _addWorkoutPlanToDB(WorkoutPlan workoutPlan) async {
    workoutPlan.shareKey = randomAlphaNumeric(Defaults.SHARE_KEY_LENGTH);
    workoutPlan.author = currentUserID;
    while (await DatabaseHelper.findWorkoutPlanByKey(workoutPlan.shareKey) != null) {
      workoutPlan.shareKey = randomAlphaNumeric(Defaults.SHARE_KEY_LENGTH);
    }
    
    DocumentReference workoutPlanDocument = await Firestore.instance.collection('workoutPlans').add(workoutPlan.toJSON());
    DatabaseHelper.updateUser(currentUserID, {'workoutPlans': FieldValue.arrayUnion([workoutPlanDocument.documentID])});
  }

  Widget _buildForm(WorkoutPlan workoutPlan) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      // padding: EdgeInsets.symmetric(vertical: 10),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField( // name
              decoration: InputDecoration(
                hintText: "e.g. Best workout plan!",
                labelText: "Plan Name",
              ),
              onSaved: (name) => workoutPlan.name = name,
              validator: (value) => value.isEmpty ? "This field cannot be empty" : null,
            ),
            TextFormField( // muscleGroup
              decoration: InputDecoration(
                hintText: "e.g. Chest",
                labelText: "Muscle Group",
              ),
              onSaved: (muscleGroup) => workoutPlan.muscleGroup = muscleGroup,
            ),
          ],
        ),
      ),
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
    return StreamBuilder(
      stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        List<String> userWorkoutPlansIDs = snapshot.data['workoutPlans'].cast<String>().toList();
        deadWorkoutPlansIDs = List();
        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: userWorkoutPlansIDs.length,
          itemBuilder: (BuildContext context, int i) {
            if (deadWorkoutPlansIDs.isNotEmpty) {
              deadWorkoutPlansIDs.forEach((id) => print('$id not found in the DB. Must have been recently deleted. Removing from list.'));
              DatabaseHelper.updateUser(currentUserID, {'workoutPlans': FieldValue.arrayRemove(deadWorkoutPlansIDs)});
            }

            return FutureBuilder(
              future: DatabaseHelper.getWorkoutPlanSnapshot(userWorkoutPlansIDs[i]),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }

                if (snapshot.data.data == null) {
                  deadWorkoutPlansIDs.add(snapshot.data.documentID);
                  return Container();
                }
                
                WorkoutPlan workoutPlan = WorkoutPlan.jsonToWorkoutPlan(snapshot.data.data);
                workoutPlan.documentID = snapshot.data.documentID;
                return _buildWorkoutPlanItem(workoutPlan);
              },
            );
          },
        );
      }
    );
  }

  void _planTapped(WorkoutPlan workoutPlan) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => WorkoutPlanPage(workoutPlan: workoutPlan,)
    ));
  }

  void _planLongPressed(WorkoutPlan workoutPlan) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton.icon(
                textColor: GSColors.red,
                icon: Icon(Icons.delete, color: GSColors.red,),
                label: Text('Delete'),
                // onPressed: () => _deletePressed(workoutPlan),
                onPressed: () => _deletePressed(workoutPlan),
              ),
              // FlatButton.icon(
              //   textColor: GSColors.green,
              //   icon: Icon(Icons.share, color: GSColors.green,),
              //   label: Text('Remove'),
              //   onPressed: () {},
              // ),
              FlatButton.icon(
                textColor: GSColors.green,
                icon: Icon(Icons.share,),
                label: Text('Share',),
                onPressed: () => _sharePressed(workoutPlan),
              ),
            ],
          ),
        );
      }
    );
  }

  void _sharePressed(WorkoutPlan workoutPlan) {
    Navigator.pop(context);

    List<Widget> items = List();
    if (workoutPlan.private) {
      items.add(
        FlatButton.icon(
          onPressed: () => _changePlanPrivacy(workoutPlan),
          textColor: GSColors.yellow,
          label: Text('Make plan shareable'),
          icon: Icon(Icons.lock_open),
        )
      );
    } else {
      items.addAll([
        FlatButton.icon(
          textColor: GSColors.yellow,
          label: Text('Make plan private'),
          icon: Icon(Icons.lock_outline),
          onPressed: () => _changePlanPrivacy(workoutPlan),
        ),
        FlatButton.icon(
          textColor: GSColors.green,
          label: Text(' ${workoutPlan.shareKey}'),
          icon: Icon(Icons.vpn_key),
          onPressed: () => _copyKeyToClipboard(workoutPlan.shareKey)
        ),
      ]);
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: items,
          ),
        );
      }
    );
  }

  void _deletePressed(WorkoutPlan workoutPlan) {
    Navigator.pop(context);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Are you sure?'),
              FlatButton.icon(
                textColor: GSColors.red,
                icon: Icon(Icons.cancel),
                label: Text('No'),
                onPressed: () {Navigator.pop(context);},
              ),
              FlatButton.icon(
                textColor: GSColors.green,
                icon: Icon(Icons.check),
                label: Text('Yes'),
                onPressed: () => _deleteWorkoutPlan(workoutPlan),
              ),
            ],
          ),
        );
      }
    );
  }

  Future<void> _deleteWorkoutPlan(WorkoutPlan workoutPlan) async {
    Navigator.pop(context);
    await DatabaseHelper.updateUser(currentUserID, {'workoutPlans': FieldValue.arrayRemove([workoutPlan.documentID])});
    Fluttertoast.showToast(msg: 'Removed workout plan');

    if (workoutPlan.author == currentUserID) {
      await Firestore.instance.collection('workoutPlans').document(workoutPlan.documentID).delete()
      .then((_) => Fluttertoast.showToast(msg: 'Deleted workout plan'));
    }
  }

  Future<void> _changePlanPrivacy(WorkoutPlan workoutPlan) async {
    await DatabaseHelper.updateWorkoutPlan(workoutPlan.documentID, {'private': !workoutPlan.private})
      .then((_) {
        workoutPlan.private = !workoutPlan.private;
        String private = !workoutPlan.private ? 'shareable!' : 'private!';
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'Plan is now $private');
      });
  }

  void _copyKeyToClipboard(String key) {
    ClipboardManager.copyToClipBoard(key)
      .then((_) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'Copied key clipboard');
      });
  }

  Widget _buildWorkoutPlanItem(WorkoutPlan workoutPlan) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () => _planTapped(workoutPlan),
        onLongPress: () => _planLongPressed(workoutPlan),
        child: WorkoutPlanWidget(workoutPlan: workoutPlan),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      drawer: AppDrawer(startPage: 1,),
      backgroundColor: GSColors.darkBlue,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          FontAwesomeIcons.plus,
          size: 14,
          color: Colors.white
        ),
        backgroundColor: GSColors.purple,
        onPressed: _addPressed,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: _buildAppBar(),
      body: Container(
        child: _buildWorkoutPlansList(),
      )
    );
  }
}