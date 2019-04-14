import 'package:GymSpace/widgets/page_header.dart';
import 'package:flutter/material.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:GymSpace/widgets/buddy_widget.dart';
import 'package:GymSpace/test_users.dart';
import 'package:GymSpace/logic/buddy.dart';
import 'package:GymSpace/page/buddy_profile_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BuddyPage extends StatelessWidget {
  final Widget child;

  BuddyPage({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(startPage: 4,),
      backgroundColor: GSColors.blue,
      appBar: _buildAppBar(),
      body: _buildBuddyBackground(),
      );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: PageHeader(
        'Buddies', 
        Colors.white, 
        showDrawer: true,
        menuColor: GSColors.darkBlue,
      )
    );  
  }

  Widget _buildBuddyBackground() {
    return Stack(
      children: <Widget>[
        _whiteBackground(),

        // Meant to be scalable
        // Plan to insert a List<BuddyWidget> that takes the itemCount.length of your buddies as input to show how many to print
        BuddyWidget(
          'David Rose',
          "I'm the leading man",
          Image.asset('assets/armshake.jpg'),
        ),
      ]
    );
  }

Widget _whiteBackground() {
  return Container(
    height: (150 * 7.0),
    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    decoration: ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
    ),
  );
}

  Widget _buildBuddyProfile() {
    return Scaffold(

    );
  }
}