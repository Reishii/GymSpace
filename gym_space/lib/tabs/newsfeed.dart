import 'package:flutter/material.dart';
import 'widget_tab.dart';

class NewsFeedTab extends WidgetTab {
  NewsFeedTab(String title) : super(title, mainColor: Colors.blue);


  @override
  Widget build(BuildContext context) {
    return Container(
      color: mainColor,
    );
  }
}