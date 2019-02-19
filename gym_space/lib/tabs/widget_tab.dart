import 'package:flutter/material.dart';

abstract class WidgetTab extends StatelessWidget {
  final String _title;
  final Color mainColor;

  // WidgetTab();
  WidgetTab(this._title, {this.mainColor = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  String getTitle() => _title;
}