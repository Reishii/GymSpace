import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:GymSpace/misc/colors.dart';

class PageHeader extends StatelessWidget {
  final Widget child;
  final String title;
  final Color color;

  PageHeader(this.title, this.color, {Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppBar(
        backgroundColor: color,
        title: Text(title),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(40))
        ),
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left, 
            color: GSColors.darkBlue, 
            size: 30
          ),
          onPressed: () {Navigator.pop(context);},
        ),
        bottom: PreferredSize(
          child: Container(
            margin: EdgeInsets.only(bottom: 40),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                fontSize: 26,
                letterSpacing: 4
              ),
            ),
          ),
        )
      ),
    );
  }
}