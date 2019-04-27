import 'package:GymSpace/global.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:flutter/material.dart';
import 'package:GymSpace/logic/group.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GroupProfilePage extends StatefulWidget {
  Group group;

  GroupProfilePage({
    this.group,
    Key key}) : super(key: key);

  _GroupProfilePageState createState() => _GroupProfilePageState();
}

class _GroupProfilePageState extends State<GroupProfilePage> {
  Group get group => widget.group;

  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      child: ListView(
        children: <Widget>[
          _buildHeader(),
          _buildPillNavigator(),
          _currentTab == 0 ? _buildOverview() 
            : _currentTab == 1 ? _buildProgress() 
            : _buildDiscussion(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            height: 340,
            decoration: ShapeDecoration(
              color: GSColors.lightBlue,
              shadows: [BoxShadow(blurRadius: 1)],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60))
              )
            ),
            child: Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  group.startDate.isEmpty ? Container() :
                  Text(
                    'Start Date ${group.startDate}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.thumb_up, color: Colors.white,),
                      Text(
                        '  ${group.likes} Likes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12
                        ),
                      ),
                    ],
                  ),
                  group.endDate.isEmpty ? Container() :
                  Text(
                    'End Date ${group.endDate}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: ShapeDecoration(
              color: GSColors.darkBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60))
              )
            ),
            height: 300,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment,
              children: <Widget>[
                Container( // group photo
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(group.photoURL.isNotEmpty ? group.photoURL : Defaults.photoURL),
                    radius: 80,
                  ),
                ),
                Divider(color: Colors.transparent, height: 4,),
                Container( // name
                  child: Text(
                    group.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ),
                Divider(color: Colors.transparent, height: 4,),
                Container( // instructor
                  child: FutureBuilder(
                    future: DatabaseHelper.getUserSnapshot(group.admin),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Instructed by ${snapshot.data['firstName']} ${snapshot.data['lastName']}  ',
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          Container(
                            child: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(snapshot.data['photoURL']),
                              radius: 10,
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
                Divider(color: Colors.transparent,),
                Container( // status
                  margin: EdgeInsets.symmetric(horizontal: 80),
                  child: Text(
                    group.status,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillNavigator() {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: ShapeDecoration(
        color: GSColors.darkBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40)
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          MaterialButton( // overview
            onPressed: () { 
              if (_currentTab != 0) {
                setState(() => _currentTab = 0);
              }
            },
            child: Text(
              'Overview',
              style: TextStyle(
                color: _currentTab == 0 ? Colors.white : Colors.white54,
                fontSize: 12,
              ),
            ),
          ),
          MaterialButton( // Progress
            onPressed: () { 
              if (_currentTab != 1) {
                setState(() => _currentTab = 1);
              }
            },
            child: Text(
              'Progress',
              style: TextStyle(
                color: _currentTab == 1 ? Colors.white : Colors.white54,
                fontSize: 12,
              ),
            ),
          ),
          MaterialButton( // Discussion
            onPressed: () { 
              if (_currentTab != 2) {
                setState(() => _currentTab = 2);
              }
            },
            child: Text(
              'Discussion',
              style: TextStyle(
                color: _currentTab == 2 ? Colors.white : Colors.white54,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverview() {
    return Container(
      child: Column(
        children: <Widget>[
          _buildAbout(),
        ],
      )
    );
  }

  Widget _buildAbout() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20,),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
        color: GSColors.darkBlue,
      ),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              'About',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Text(
              group.bio,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                height: 1.5,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Container(
      child: Text('this is progress')      
    );
  }

  Widget _buildDiscussion() {
    return Container(
      child: Text('this is disccusion')
    );
  }
}