import 'package:flutter/material.dart';
import 'widget_tab.dart';
import 'package:GymSpace/colors.dart';

class NewsFeedTab extends WidgetTab {
  NewsFeedTab(String title) : super(title, mainColor: GSColors.darkBlue);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          // online friends list
          Text("THIS IS A PLACE HOLDER FOR FRIENDS LIST (WIP)")
          // actual news feed
        ],
      ),
    );
  }
}