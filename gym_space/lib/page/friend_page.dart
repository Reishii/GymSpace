import 'package:GymSpace/widgets/page_header.dart';
import 'package:flutter/material.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:GymSpace/test_users.dart';
import 'package:GymSpace/logic/friend.dart';
import 'package:GymSpace/page/friend_profile_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FriendPage extends StatelessWidget {
  final Widget child;

  FriendPage({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(startPage: 4,),
      backgroundColor: GSColors.blue,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: PageHeader(
          'Friends', 
          Colors.white, 
          showDrawer: true,
          menuColor: GSColors.darkBlue,
        ),  
      ),
      // body: Text("data", style: TextStyle(color: Colors.white)),
      body: Stack(
        children: <Widget>[
          _buildFriendBackground(),
          _buildFriendList(),
        ],
      )
    );
  }

  Widget _buildFriendBackground() {
    return ListView(
      children: <Widget>[
        Container(
          height: (150 * 5.0),
          margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            ),
          )
        ),
      ],  
    );
  }

  Widget _buildFriendList() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 20),
      itemCount: 5,
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
                  _buildFriendProfile();
                }
              ));
            },
          )
        );
      }
    );
  }

  Widget _buildFriendProfile() {
    return Scaffold(

    );
  }
}