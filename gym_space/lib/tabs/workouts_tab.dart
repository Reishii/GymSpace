import 'package:flutter/material.dart';
import 'widget_tab.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/global.dart';
import 'package:GymSpace/logic/workout_plan.dart';
import 'package:GymSpace/widgets/workout_plan_widget.dart';
// import 'package:GymSpace/logic/workout.dart';


class WorkoutsTab extends WidgetTab {

  WorkoutsTab(String title) : super(title, mainColor: GSColors.darkBlue);

  @override
  Widget build(BuildContext context) {
    return _buildWorkoutPlans();
  }

  Widget _buildWorkoutPlans() {
    return Container(
      margin: EdgeInsets.all(20),
      child: _buildList(),
    );
  }

  Widget _buildList() {
    var workoutPlans = GlobalSettings.currentTestUser.workoutPlans;
    
    return new ListView.builder(
      itemCount: workoutPlans.length,
      itemBuilder: (BuildContext context, int i) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: WorkoutPlanWidget(workoutPlans[i])
        );
      },
    );
  }
}