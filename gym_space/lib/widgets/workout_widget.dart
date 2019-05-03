import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:GymSpace/logic/workout.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:GymSpace/global.dart';

class WorkoutWidget extends StatefulWidget {
  final Widget child;
  final Workout workout;

  WorkoutWidget({@required this.workout, Key key, this.child}) : super(key: key);

  _WorkoutWidgetState createState() => _WorkoutWidgetState();
}

class _WorkoutWidgetState extends State<WorkoutWidget> {
  Workout get workout => widget.workout;
  String _newExericseName = "";
  bool _isExpanded = false;
  double height = 60;
  GlobalKey<FormState> _exerciseFormKey = GlobalKey<FormState>();

  void _addPressed() {
    showDialog(
      context: context,
      builder: (context) {
        Map<String, dynamic> exercise = Map();
        return SimpleDialog(
          title: Text("New Exercise", textAlign: TextAlign.center),
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
            Container(
              margin: EdgeInsets.only(left: 16, right: 40),
              height: 370,
              width: double.maxFinite,
              child: _buildForm(exercise),
            ),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SimpleDialogOption(
                child: MaterialButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    print("Resetting form");
                    _exerciseFormKey.currentState.reset();
                    Navigator.pop(context);
                  },
                ),
              ),
              SimpleDialogOption(
                child: MaterialButton(
                  child: Text("Add"),
                  onPressed: () {
                    if (_exerciseFormKey.currentState.validate()) {
                      _exerciseFormKey.currentState.save();
                      print("Adding Exercise to workout");
                      workout.exercises[_newExericseName] = exercise;
                      _updateWorkout(exercise);
                      setState(() {
                        height = _isExpanded ? 60.0 * 1.5 + workout.exercises.length * 70 : 60;
                      });
                      Navigator.pop(context);
                    }
                  },
                ),
                )
              ],
            )
          ],
        );
      }
    );
  }

  void _updateWorkout(var exercise) async {
    DocumentSnapshot workoutDocument = await DatabaseHelper.getWorkoutSnapshot(workout.documentID);
    var list = workoutDocument.data['exercises'];
    list[_newExericseName] = exercise;
    Firestore.instance.collection('workouts').document(workout.documentID).updateData(
      {'exercises': list});
    // var newValue = workoutDocument.data.update('exercises', list);
  }

  Widget _buildForm(Map<String, dynamic> exercise) {
    return Form(
      key: _exerciseFormKey,
      child: Column(
        children: <Widget>[
          TextFormField( // name
            decoration: InputDecoration(
              icon: Icon(
                FontAwesomeIcons.angleRight,
                color: GSColors.darkBlue,
                size: 30,
              ),
              hintText: "e.g. bench press",
              labelText: "Name",
            ),
            onSaved: (name) => _newExericseName = name,
            validator: (value) => value.isEmpty ? "This field cannot be empty" : null,
          ),
          TextFormField( // sets
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              icon: Icon(
                FontAwesomeIcons.angleRight,
                color: GSColors.darkBlue,
                size: 30,
              ),
              hintText: "e.g. 3",
              labelText: "Sets",
            ),
            onSaved: (sets) => exercise['sets'] = int.parse(sets),
            validator: (value) => value.isEmpty ? "This field cannot be empty" : null,
          ),
          TextFormField( // reps
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              icon: Icon(
                FontAwesomeIcons.angleRight,
                color: GSColors.darkBlue,
                size: 30,
              ),
              hintText: "e.g. 8",
              labelText: "Reps",
            ),
            onSaved: (reps) => exercise['reps'] = int.parse(reps),
            validator: (value) => value.isEmpty ? "This field cannot be empty" : null,
          ),
          TextFormField( // bodyPart
            decoration: InputDecoration(
              icon: Icon(
                FontAwesomeIcons.angleRight,
                color: GSColors.darkBlue,
                size: 30,
              ),
              hintText: "e.g. bicep",
              labelText: "Body part",
            ),
            onSaved: (bodyPart) => exercise['bodyPart'] = bodyPart,
          ),
          TextFormField( // description
            decoration: InputDecoration(
              icon: Icon(
                FontAwesomeIcons.angleRight,
                color: GSColors.darkBlue,
                size: 30,
              ),
              hintText: "e.g. this is for biceps",
              labelText: "Description",
            ),
            onSaved: (description) => exercise['description'] = description,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       height: height,
       margin: EdgeInsets.symmetric(vertical: 16),
       decoration: ShapeDecoration(
         color: Colors.white,
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(20),
         )
       ),
       child: InkWell( // button to expand
         onTap: () {
           setState(() {
              _isExpanded = !_isExpanded;
              height = _isExpanded ? 60.0 * 1.5 + workout.exercises.length * 70 : 60;
           });
         },
        //  onLongPress: _showWorkoutDialog,
         child: Column(
           children: <Widget>[
             Row(
               children: <Widget>[
                 Expanded(
                   flex: 2,
                   child: Container(
                    margin: EdgeInsets.only(top: 16, left: 40),
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
                     margin: EdgeInsets.only(top: 16, left: 40),
                     child: Icon(
                      _isExpanded ? FontAwesomeIcons.caretUp : FontAwesomeIcons.caretDown, 
                      color: Colors.black26
                     ),
                   ),
                 ),
               ],
             ),
            _isExpanded ? _showExercises() : Container()
           ],
         ),
       ),
    );
  }

  Widget _showExercises() {
    List<Widget> exerciseWidgets = List();

    workout.exercises.forEach((exercise, data) {
      exerciseWidgets.add(
        Container(
          margin: EdgeInsets.only(top: 20, left: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget> [
                  // Container(
                  //   margin: EdgeInsets.only(right: 5),
                  //   child: Icon(
                  //     Icons.lens,
                  //     size: 8,
                  //   ),
                  // ),
                  Text(
                    exercise,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10, left: 40),
                child: Text(
                  data['sets'].toString() + " sets of " + data['reps'].toString() + " reps",
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

      if (exerciseWidgets.isEmpty) {
        print("No workouts!");
      }
    });
      // add exercise button
      exerciseWidgets.add(
        Container(
          alignment: Alignment.topRight,
          // margin: EdgeInsets.only(bottom: ),
          // color: Colors.red,
          child: MaterialButton(
            child: Icon(
              Icons.add_circle,
              color: GSColors.darkBlue.withAlpha(220),
            ),
            onPressed: _addPressed,
          )
        )
      );

    // for (Map exercise in exercises) {
    //   exerciseWidgets.add(
    //     Container(
    //       margin: EdgeInsets.only(top: 20, left: 80),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: <Widget>[
    //           Text(
    //             exercise.name,
    //             style: TextStyle(
    //               fontSize: 16,
    //               fontWeight: FontWeight.w300
    //             ),
    //           ),
    //           Container(
    //             margin: EdgeInsets.only(top: 10, left: 20),
    //             child: Text(
    //               exercise.sets.toString() + " sets of " + exercise.reps.toString() + " reps",
    //               style:TextStyle(
    //                 fontSize: 14,
    //                 fontWeight:FontWeight.w200,
    //               ),
    //             ),
    //           )
    //         ]
    //       ),
    //     )
    //   );
    // }

    return Container(
      // margin: EdgeInsets.only(left: 70),
      alignment: FractionalOffset.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: exerciseWidgets,
      ),
    );
  }


  // void _showWorkoutDialog() {
  //   void _deletePressed() {
  //     Navigator.pop(context);
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text('Are you sure you want to delete ' + workout.name + '?'),
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(20)
  //           ),
  //           actions: <Widget>[
  //             MaterialButton(
  //               child: Text('Cancel'),
  //               onPressed: () => Navigator.pop(context),
  //             ),
  //             MaterialButton(
  //               child: Text('Delete'),
  //               onPressed: () {
  //                 _removeWorkoutFromDB().then((_) {
  //                   Navigator.pop(context);
  //                   setState((){});
  //                 });
  //               },
  //             ),
  //           ],
  //         );
  //       }
  //     );
  //   }

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Row(
  //           children: <Widget>[
  //             Container(
  //               child: Text(workout.name),
  //             ),
  //             Container(
  //               margin: EdgeInsets.only(left: 140),
  //               child: Text(
  //                 workout.author,
  //                 style: TextStyle(
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.w300,
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10)
  //         ),
  //         // contentPadding: EdgeInsets.all(30),
  //         content: Text(
  //           workout.description,
  //           textAlign: TextAlign.left,
  //           style: TextStyle(
  //             fontWeight: FontWeight.w300,
  //           ),
  //         ),
  //         actions: <Widget>[
  //           MaterialButton(
  //             child: Text("Close"),
  //             onPressed: () => Navigator.pop(context),
  //           ),
  //           MaterialButton(
  //             child: Text("Delete"),
  //             onPressed: () {
  //               print("Delete pressed");
  //               _deletePressed();
  //             },
  //           )
  //         ],
  //         // children: <Widget>[
  //         //   Text(
  //         //     workout.description,
  //         //     textAlign: TextAlign.left,
  //         //     style: TextStyle(
  //         //       fontWeight: FontWeight.w300,
  //         //     ),
  //         //   )
  //         // ],
  //       );
  //     }
  //   );
  // }
}