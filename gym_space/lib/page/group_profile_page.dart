import 'dart:async';

import 'package:GymSpace/global.dart';
import 'package:GymSpace/logic/user.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/page/group_members_page.dart';
import 'package:GymSpace/page/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String get currentUserID => DatabaseHelper.currentUserID;

  int _currentTab = 0;
  bool _loadingMembers = true;
  bool _joined = false;
  bool _isAdmin = false;

  List<User> members = List();

  Future<void> _likeGroup() async {
    if (group.likes.contains(DatabaseHelper.currentUserID)) {
      return;
    }

    Firestore.instance.collection('groups').document(group.documentID).updateData({'likes': FieldValue.arrayUnion([DatabaseHelper.currentUserID])});

    setState(() => group.likes.add(currentUserID));
  }

  void _joinGroup() {
    Firestore.instance.collection('users').document(currentUserID).updateData({'joinedGroups': FieldValue.arrayUnion([group.documentID])})
      .then((_) => setState(() {
        _joined = true;
      }));
  }

  void _leaveGroup() {
    Firestore.instance.collection('users').document(currentUserID).updateData({'joinedGroups': FieldValue.arrayRemove([group.documentID])})
      .then((_) => setState(() {
        group.members.remove(currentUserID);
        _joined = false;
      }));
  }

  @override
  void initState() {
    super.initState();
    if (group.admin == DatabaseHelper.currentUserID) {
      setState(() => _isAdmin = true);
    }

    if (_isAdmin || group.members.contains(DatabaseHelper.currentUserID)) {
      setState(() {
        _joined = true;
      });
    }

    group.members.forEach((member) {
      DatabaseHelper.getUserSnapshot(member).then((ds) {
        User user = User.jsonToUser(ds.data);
        user.documentID = member;
        members.add(user);
        if (members.length == group.members.length) {
          setState(() {
            _loadingMembers = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppbar() {
    return AppBar(
      elevation: 0,
      actions: <Widget>[
        _isAdmin ?
        Container(
          margin: EdgeInsets.all(10),
          child: FlatButton.icon(
            icon: Icon(Icons.add),
            label: Text('Disable Group'),
            textColor: Colors.white,
            color: GSColors.yellow,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {}),
        ) : _joined ? Container(
          margin: EdgeInsets.all(10),
          child: FlatButton.icon(
            icon: Icon(Icons.add),
            label: Text('Leave'),
            textColor: Colors.white,
            color: GSColors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: _leaveGroup,
          ),
        ) : Container(
          margin: EdgeInsets.all(10),
          child: FlatButton.icon(
            icon: Icon(Icons.add),
            label: Text('Join'),
            textColor: Colors.white,
            color: GSColors.lightBlue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: _joinGroup,
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Container(
      child: ListView(
        children: <Widget>[
          _buildHeader(),
          _buildPillNavigator(),
          _currentTab == 0 ? _buildOverviewTab() 
            : _currentTab == 1 ? _buildChallengesTab() 
            : _buildDiscussionTab(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            height: 320,
            decoration: ShapeDecoration(
              color: GSColors.lightBlue,
              shadows: [BoxShadow(blurRadius: 1)],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60))
              )
            ),
            child: Container(
              alignment: Alignment.bottomCenter,
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
                  FlatButton.icon(
                    icon: Icon(Icons.thumb_up),
                    textColor: Colors.white,
                    label: Text('${group.likes.length} Likes'),
                    onPressed: _likeGroup,
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     Icon(Icons.thumb_up, color: Colors.white,),
                  //     Text(
                  //       '  ${group.likes.length} Likes',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 12
                  //       ),
                  //     ),
                  //   ],
                  // ),
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
            height: 280,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment,
              children: <Widget>[
                Container( // group photo
                  decoration: ShapeDecoration(
                    shape: CircleBorder(
                      side: BorderSide(color: Colors.white, width: 1),
                    ),
                  ),
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
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ProfilePage(forUserID: group.admin,)
                                ));
                              },
                              child: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(snapshot.data['photoURL']),
                                radius: 10,
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
                Divider(color: Colors.transparent, height: 2),
                Container( // status
                  margin: EdgeInsets.symmetric(horizontal: 80),
                  child: Text(
                    group.status,
                    maxLines: 3,
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
        mainAxisAlignment: _joined ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
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
          _joined ? MaterialButton( // Challenges
            onPressed: () { 
              if (_currentTab != 1) {
                setState(() => _currentTab = 1);
              }
            },
            child: Text(
              'Challenges',
              style: TextStyle(
                color: _currentTab == 1 ? Colors.white : Colors.white54,
                fontSize: 12,
              ),
            ),
          ) : Container(),
          _joined ? MaterialButton( // Discussion
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
          ) : Container(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Container(
      child: Column(
        children: <Widget>[
          _buildAbout(),
          _buildMembersList(),
          _buildWorkouts(),
        ],
      )
    );
  }

  Widget _buildAbout() {
    return Container(
      width: double.maxFinite,
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

  Widget _buildMembersList() {
    return InkWell(
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: ShapeDecoration(
          color: GSColors.darkBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          )
        ),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                'Members',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.2,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: _loadingMembers ? 
              CircularProgressIndicator(
                strokeWidth: 1,
                valueColor: AlwaysStoppedAnimation<Color>(GSColors.babyPowder), 
              ) :
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildMemberAvatars(),
              )
            )
          ],
        ),
      ),
      onTap: () => _loadingMembers ? null : Navigator.push(context, MaterialPageRoute(
        builder: (context) => GroupMembersPage(group: group, members: members),
      )),
    );
  }

  List<Widget> _buildMemberAvatars() {
    List<Widget> memberAvatars = List();

    for (User member in members) {
      memberAvatars.add(
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: ShapeDecoration(
            shape: CircleBorder(
              side: BorderSide(color: Colors.white)
            )
          ),
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              member.photoURL.isEmpty ? Defaults.photoURL : member.photoURL
            ),
            radius: 20,
          ),
        )
      );

      if (memberAvatars.length == 5) {
        break;
      }
    }

    if (members.length <= 5) {
      return memberAvatars;
    }

    memberAvatars.add(
      Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        child: CircleAvatar(
          backgroundColor: GSColors.purple,
          child: Text(
            '+${members.length - 4}',
            style: TextStyle(
              color: Colors.white
            ),
          ),
          radius: 21, // 21 because border of circle avatars were of width 1
        ),
      )
    );

    return memberAvatars;
  }

  Widget _buildWorkouts() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Workouts',
            style: TextStyle(
              fontSize: 24,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.keyboard_arrow_right),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Widget _buildChallengesTab() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          _buildChallenges(),
          _buildLeaderboard(),
        ],
      ),
    );
  }

  Widget _buildChallenges() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                Text(
                  'Challenges',
                  style: TextStyle(
                    fontSize: 22,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold
                  ),
                ), _isAdmin ? 
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {},
                )
                : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboard() {
    return Container(
      height: 200,
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: ShapeDecoration(
        color: GSColors.darkBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        )
      ),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Leaderboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          // SHOW ACTUAL CONTENT HERE
        ],
      ),
    );
  }

  Widget _buildDiscussionTab() {
    return Container(
      child: Text('this is disccusion')
    );
  }
}