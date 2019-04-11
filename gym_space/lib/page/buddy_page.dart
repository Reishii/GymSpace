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

  Widget _buildBuddyList() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 20),
      itemCount: 7,
      itemBuilder: (BuildContext context, int i) {
        return Container(
          height: 100,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          decoration: ShapeDecoration(
            color: GSColors.darkBlue,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
            )
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (context) {
                  _buildBuddyProfile();
                }
              ));
            },
          )
        );
      }
    );
  }

  Widget _buildBuddyProfile() {
    return Scaffold(

    );
  }
}