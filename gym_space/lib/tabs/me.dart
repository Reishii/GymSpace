import 'package:flutter/material.dart';
import 'widget_tab.dart';
import 'package:GymSpace/logic/profile.dart';
import 'package:GymSpace/logic/user.dart';

class MeTab extends WidgetTab {
  final User _me = new User("rollininrice", "rollininrice@gmail.com");

  MeTab(String title) : super(title, mainColor: Colors.green);

  @override
  Widget build(BuildContext context) {
    return Profile(_me);
  }
}
