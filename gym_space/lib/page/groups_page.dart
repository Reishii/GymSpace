import 'package:GymSpace/global.dart';
import 'package:GymSpace/logic/group.dart';
import 'package:GymSpace/page/group_profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:GymSpace/widgets/page_header.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:GymSpace/widgets/page_header.dart';

class GroupsPage extends StatelessWidget {
  final Widget child;

  GroupsPage({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(startPage: 4),
      // backgroundColor: GSColors.olive,
      appBar: _buildAppBar(),
      // body: _buildGroupBackground(),
      body: _buildBody(context),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: PageHeader(
        title: 'Your Groups',
        backgroundColor: GSColors.darkBlue,
        showDrawer: true,
        showSearch: true,
        titleColor: Colors.white,
      )
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      // color: Colors.white
      child: ListView(
        children: <Widget>[
          _buildGroupItem('groupID', context),
        ],
      )
    );
  }

  Widget _buildGroupItem(String groupID, context) {
    Group group = Group(name: 'Shredded in 3 months', admin: DatabaseHelper.currentUserID);
    group.photoURL = 'https://images.pexels.com/photos/1092877/pexels-photo-1092877.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260';
    group.status = 'Keep it up guys! We only have a few weeks left! ';
    group.startDate = '2019-04-26';
    group.endDate = '2019-07-26';
    group.bio = 'Looking to get rid of that dad bod? With this program, I guarentee that I can get you Summer ready in just 3 months. We will start this program on exactly 4/26/2019 and end on 7/26/2019.';
    group.members = List();
    group.members.addAll([
      'TzlVADVHVaTZrJ3gUyRJirhgyiV2',
      'XKgmeU51sxgmMig8ExV5J8JKq6n1',
      'eyo4X5qYD9gQeWK1eef3t7yKFee2',
      'mb6MLqrSAbVsSoXpoCtzZP0af1V2',
    ]);
    

    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: ShapeDecoration(
        color: GSColors.darkBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        )
      ),
      child: InkWell(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text( // name
                group.name,
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              _buildMembersList(['uK1idFKmD9RdNKdLg6bULCsA1N53']),
            ],
          ),
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (context) => GroupProfilePage(group: group,) 
          )
        ),
      ),
    );
  }

  Widget _buildMembersList(List<String> members) {
    members.add(members[0]);
    
    // for testing
    List<String> memberPics = List();
    memberPics.add('https://firebasestorage.googleapis.com/v0/b/gymspace.appspot.com/o/1556315362504?alt=media&token=120a1bbc-9c3c-4f00-83f0-6512a709f250');
    memberPics.add(memberPics[0]);
    memberPics.add(memberPics[0]);
    memberPics.add(memberPics[0]);
    memberPics.add(memberPics[0]);
    memberPics.add(memberPics[0]);
    memberPics.add(memberPics[0]);
    
    List<Widget> memberIcons = List();
    for(int i = 0; i < memberPics.length; i++) {
      memberIcons.add(
        Positioned(
          left: (30.0 * i),
          child: Container(
            margin: EdgeInsets.only(left: 20),
            decoration: ShapeDecoration(
              shape: CircleBorder(
                side: BorderSide(color: Colors.white, width: 1.5),
              )
            ),
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(memberPics[i]),
              radius: 20,
            ),
          ),
        )
      );
    }

    memberIcons.add(
      Positioned(
        right: 20,
        child: Container(
          child: CircleAvatar(
            backgroundColor: GSColors.purple,
            radius: 20 + 1.5,
            child: Text(
              '+37',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      )
    );

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      height: 50,
      child: Stack(
        children: memberIcons,
      ),
    );
  }

  Widget _buildGroupBackground() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 20),
      itemCount: 5,
      itemBuilder: (BuildContext context, int i) {
        return Container(
          height: 200, 
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (context) {
                  //_buildGroupProfile();
                }
              ));
            }
          ),
        );
      }
    );
  }

}