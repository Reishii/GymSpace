import 'package:flutter/material.dart';
import 'widget_tab.dart';
import 'package:GymSpace/colors.dart';
import 'package:GymSpace/widgets/your_workouts_widget.dart';

class WorkoutsTab extends WidgetTab {

  WorkoutsTab(String title) : super(title, mainColor: GSColors.darkBlue);

  @override
  Widget build(BuildContext context) {
    return YourWorkouts();
  }
}