import 'package:flutter/material.dart';
import 'widget_tab.dart';

class MeTab extends WidgetTab {
  MeTab(String title) : super(title, mainColor: Colors.green);

  @override
  Widget build(BuildContext context) {

    return Container(
      color: mainColor,
    );
  }
}