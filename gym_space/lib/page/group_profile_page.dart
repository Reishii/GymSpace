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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



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
      Fluttertoast.showToast(
        msg: 'Already Liked!', 
        fontSize: 14, 
        backgroundColor: GSColors.purple,
        textColor: Colors.white,
      );
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
          Container(
            height: 40,
            decoration: ShapeDecoration(
              color: _currentTab == 0 ? GSColors.lightBlue : GSColors.darkBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
              child: MaterialButton( // overview
              onPressed: () { 
                if (_currentTab != 0) {
                  setState(() => _currentTab = 0);
                }
              },
              child: Text(
                'Overview',
                style: TextStyle(
                color: _currentTab == 0 ? GSColors.darkBlue : Colors.white,
                fontSize: 14,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w700,
              )),
            ),
          ),

          _joined ? Container(
            height: 40,
            decoration: ShapeDecoration(
              color: _currentTab == 1 ? GSColors.lightBlue : GSColors.darkBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            child: MaterialButton( // Challenges
              onPressed: () { 
                if (_currentTab != 1) {
                  setState(() => _currentTab = 1);
                }
              },
              child: Text(
                'Challenges',
                style: TextStyle(
                color: _currentTab == 1 ? GSColors.darkBlue : Colors.white,
                fontSize: 14,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w700,
              )),
            ),
          ) : Container(),

          _joined ? Container(
            height: 40,
            decoration: ShapeDecoration(
              color: _currentTab == 2 ? GSColors.lightBlue : GSColors.darkBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            child: MaterialButton( // Discussion
              onPressed: () { 
                if (_currentTab != 2) {
                  setState(() => _currentTab = 2);
                }
              },
              child: Text(
                'Discussion',
                style: TextStyle(
                color: _currentTab == 2 ? GSColors.darkBlue : Colors.white,
                fontSize: 14,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w700,
              )),
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
      String _challengeKey = getChallengeKey(); //challenge weekly date
      String challengeTitle, challengeUnits;
      int challengeGoal, challengePoints;
      GlobalKey<FormState> formKey = GlobalKey();

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
                ), 
                //check if admin
               _isAdmin ? 
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context){
                        TextEditingController _challengeTitleController = TextEditingController();
                        return AlertDialog(
                          title: Text("For Week:  " + _challengeKey),
                          content:
                            Container(
                              height: 450,
                              width: 350,
                              //child: Scrollbar(
                              child: ListView(
                                children: <Widget>[
                                  Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      
                                      TextFormField(//challenge Title
                                        decoration: InputDecoration(
                                          icon: Icon( FontAwesomeIcons.angleRight,
                                          color: GSColors.darkBlue,
                                          size: 30,),
                                          hintText: "e.g Run 20 miles",
                                          labelText: "Challenge Name"
                                        ),
                                        onSaved: (name) => challengeTitle = name,
                                        validator: (value) => value.isEmpty ? "This field cannot be empty" : null,
                                        textCapitalization: TextCapitalization.sentences
                                      ),

                                      TextFormField(//units
                                        decoration: InputDecoration(
                                          icon: Icon( FontAwesomeIcons.angleRight,
                                          color: GSColors.darkBlue,
                                          size: 30,),
                                          hintText: "e.g Miles",
                                          labelText: "Units"
                                        ),
                                        onSaved: (units) => challengeUnits = units,
                                        validator: (value) => value.isEmpty ? "This field cannot be empty" : null,
                                        textCapitalization: TextCapitalization.sentences,
                                      ), 

                                      TextFormField(//goal
                                        decoration: InputDecoration(
                                          icon: Icon( FontAwesomeIcons.angleRight,
                                          color: GSColors.darkBlue,
                                          size: 30,),
                                          hintText: "e.g 20",
                                          labelText: "Goal"
                                        ),
                                        onSaved: (goal) => challengeGoal = int.parse(goal),
                                        validator: (value) => value.isEmpty ? "This field cannot be empty" : null,
                                        textCapitalization: TextCapitalization.sentences,
                                        keyboardType: TextInputType.number

                                      ), 

                                       TextFormField(//points
                                        decoration: InputDecoration(
                                          icon: Icon( FontAwesomeIcons.angleRight,
                                          color: GSColors.darkBlue,
                                          size: 30,),
                                          hintText: "e.g 100",
                                          labelText: "Points upon completion"
                                        ),
                                        onSaved: (points) => challengePoints = int.parse(points),
                                        validator: (value) => value.isEmpty ? "This field cannot be empty" : null,
                                        textCapitalization: TextCapitalization.sentences,
                                        keyboardType: TextInputType.number
                                      ), 
                                        // Container(
                                        //   padding: EdgeInsets.all(15.0),
                                        //   child: TextField(
                                        //       controller: _challengeTitleController,
                                        //       decoration: InputDecoration(
                                        //         labelText: 'Challenge Title',
                                        //         labelStyle: TextStyle(
                                        //           fontSize: 18.0,
                                        //           color: GSColors.darkBlue
                                        //         ),
                                        //         hintText: 'E.g. Run 20 miles',
                                        //         hintStyle: TextStyle(
                                        //           fontSize: 16.0,
                                        //           color: GSColors.lightBlue
                                        //         ),
                                        //         contentPadding: EdgeInsets.all(10.0)
                                        //       ),
                                        //       onChanged: (text) {
                                        //         (text!= null) ? challengeTitle = text : challengeTitle = 'error0';
                                        //       },
                                        //     )
                                        // ),

                                        // Container(
                                        //   padding: EdgeInsets.all(15.0),
                                        //   child: TextField(
                                        //       decoration: InputDecoration(
                                        //         labelText: 'Units',
                                        //         labelStyle: TextStyle(
                                        //           fontSize: 18.0,
                                        //           color: GSColors.darkBlue
                                        //         ),
                                        //         hintText: 'E.g. Miles',
                                        //         hintStyle: TextStyle(
                                        //           fontSize: 16.0,
                                        //           color: GSColors.lightBlue
                                        //         ),
                                        //         contentPadding: EdgeInsets.all(10.0)
                                        //       ),
                                        //       onChanged: (text){
                                        //        (text!= null) ? challengeUnits = text : challengeUnits = 'error1';
                                        //       },
                                        //     )
                                        // ),

                                        //  Container(
                                        //   padding: EdgeInsets.all(15.0),
                                        //   child: TextField(
                                              
                                        //       keyboardType: TextInputType.number,
                                        //       decoration: InputDecoration(
                                        //         labelText: 'Goal (number)',
                                        //         labelStyle: TextStyle(
                                        //           fontSize: 18.0,
                                        //           color: GSColors.darkBlue
                                        //         ),
                                        //         hintText: 'E.g. 60',
                                        //         hintStyle: TextStyle(
                                        //           fontSize: 16.0,
                                        //           color: GSColors.lightBlue
                                        //         ),
                                        //         contentPadding: EdgeInsets.all(10.0)
                                        //       ),
                                        //       onChanged: (text){
                                        //         (text!= null) ? challengeGoal = int.parse(text) : challengeGoal = -9999;
                                        //       },
                                        //     )
                                        // ),

                                        //  Container(
                                        //   padding: EdgeInsets.all(15.0),
                                        //   child: TextField(
                                        //       keyboardType: TextInputType.number,
                                        //       decoration: InputDecoration(
                                        //         labelText: 'Points on completion (number)',
                                        //         labelStyle: TextStyle(
                                        //           fontSize: 18.0,
                                        //           color: GSColors.darkBlue
                                        //         ),
                                        //         hintText: 'E.g. 20',
                                        //         hintStyle: TextStyle(
                                        //           fontSize: 16.0,
                                        //           color: GSColors.lightBlue
                                        //         ),
                                        //         contentPadding: EdgeInsets.all(10.0)
                                        //       ),
                                        //       onChanged: (text){
                                        //         (text!= null) ? challengePoints = int.parse(text) : challengePoints = -9999;
                                        //       },
                                        //     )
                                        // ),

                                    ],
                                  )
                                  )
                                ],
                              ),
                             // )
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: const Text('Cancel'),
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: const Text('Save'),
                                onPressed: (){
                                  // if(_challengeTitleController.text.isEmpty) {
                                  //   _challengeTitleController.text = 'INVALID';
                                  //   _challengeTit
                                  // }

                                  // if(challengeTitle == 'error0' || challengeUnits == 'error1' || challengeGoal == -9999 || challengePoints == -9999)
                                  // {
                                  //  //send toast error message 
                                  // } 

                                  //else
                                  if(formKey.currentState.validate())
                                  {
                                    formKey.currentState.save();
                                    Map<String, dynamic> newGroupChallenge;    
                                    //List<Map> membersMapList = List();
                                    Map<String, dynamic> membersMap = Map();
                                    // Map<String, dynamic> tempMap = Map();

                                    for(int i = 0; i < group.members.length; i++)
                                      {
                                        membersMap[group.members[i]] = {'points': 0, 'progress' : 0};
                                        //tempMap = {group.members[i]: {'points' : 0, 'progress' : 0}};
                                        //membersMapList.add(tempMap);
                                        //membersMapList.add(membersMap);
                                      }

                                    newGroupChallenge =  
                                        {'points' : challengePoints, 
                                          'units' : challengeUnits,
                                          'goal' : challengeGoal,
                                          'members' : membersMap//membersMapList
                                          };         

                                    print("*****************************************************************************************************************");
                                    print(challengeTitle);
                                    print(challengeUnits);
                                    print(challengeGoal);
                                    print(challengePoints);

                                    _uploadGroupChallenge(newGroupChallenge, _challengeKey, challengeTitle);
                                    Navigator.pop(context);
                                  }
                                }
                              )
                            ],
                        );
                      }
                    );
                  },
                )
               : Container(),
              ],
            ),
          ),
          //Container(
          InkWell(
            onTap: (){
              showDialog(
                context: context,
                builder: (BuildContext context)
                {
                  List<int> inputList = List();
                  List<String> challengeNames = List();
                  return AlertDialog(
                    title: Text(
                      "Update your progress on your group's weekly challenges"),
                    content: 
                    Container(
                      height: 450,
                      width: 350,
                      child: Scrollbar(
                        child: StreamBuilder(
                          stream:  DatabaseHelper.getGroupStreamSnapshot(group.documentID),
                          builder: (context, snapshotGroup){
                            if(snapshotGroup.data == null)
                            {
                              return Container();
                            }
                            else
                            {
                              List<Widget> challengeList = [];
                              // int userIndex;
                              snapshotGroup.data.data['challenges'][_challengeKey].cast<String, dynamic>().forEach((title, value){                          
                              
                                // for(int i = 0; i < group.members.length; i++)
                                // {
                                //   if(value['members'][i] == DatabaseHelper.currentUserID)
                                //     userIndex = i;
                                // }
                                challengeList.add(
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: title,
                                      labelStyle: TextStyle(
                                        fontSize: 18.0,
                                        color: GSColors.darkBlue
                                        ),
                                      contentPadding: EdgeInsets.all(10.0),
                                      hintText: '${value['members'][DatabaseHelper.currentUserID]['progress'].toString()}/${value['goal'].toString()} ${value['units']} Completed',
                                      hintStyle: TextStyle(
                                        color: GSColors.lightBlue,
                                        fontWeight: FontWeight.bold,
                                        ) 
                                      ),
                                      maxLength: 5,
                                      onChanged: (text){
                                        (text != null) ? inputList.add(int.parse(text)) : inputList.add(-999999);
                                        challengeNames.add(title);
                                      },
                                  )
                                );
                              });
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: challengeList,
                              );

                            }
                          }
                        ),
                        // child: ListView(),
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: const Text('Cancel'),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: const Text('Save'),
                        onPressed: (){
                          // int temp;
                          // for(int j = 0; j < inputList.length; j++)
                          // {
                          //   if(inputList[j] != -999999)
                          //   {
                          //     inputList[j] = 0;
                          //   }

                          // temp = inputList[j] + 

                          // }
                          _updateMemberChallengeProgress(inputList, challengeNames);
                          _buildChallenges();
                          Navigator.pop(context);
                        },
                      )

                    ],
                  );
                }
              );
            },
            child: Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: ShapeDecoration(
              color: GSColors.darkBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              )
            ),

             //child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // StreamBuilder( 
                  //   stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                  //   builder: (context, snapshotUser){
                  //     if(!snapshotUser.hasData){
                  //       return Container();
                  //     }
                      //else{
                        //return 
                        StreamBuilder(
                          stream: DatabaseHelper.getGroupStreamSnapshot(group.documentID),
                          builder: (context, snapshotGroup){
                            if(!snapshotGroup.hasData)
                            {
                              return Container();
                            }
                            Map tmpMap = Map();
                            tmpMap = snapshotGroup.data.data['challenges'];
                            if(tmpMap.length == 0)
                            {
                              return Container();
                            }
                            else
                            {
                              // User user = User.jsonToUser(snapshotUser.data.data);
                              List<Widget> challengeList = [];
                              snapshotGroup.data.data['challenges'][_challengeKey].cast<String, Map>().forEach((title, value)
                              {
                                if(value['members'][DatabaseHelper.currentUserID]['progress'] == value['goal'])
                                {
                                  challengeList.add(
                                    Container(
                                    margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                                    child :Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                      Container(
                                        child: Text(
                                          title,
                                          style: TextStyle(
                                            color: GSColors.cloud,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Container(
                                          height: 20,
                                          child: (LinearPercentIndicator(
                                          width: 330,
                                          lineHeight: 14.0,
                                          percent: 1.0,
                                          backgroundColor: Colors.green,
                                          progressColor: Colors.green,
                                          center: Text("100%")
                                          )  
                                        ),  
                                      )
                                    ]
                                  )
                                    )
                                  );
                                }
                                else{
                                  challengeList.add(
                                    Container(
                                    margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                                    child :Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                      Container(
                                        child: Text(
                                          title,
                                          style: TextStyle(
                                            color: GSColors.cloud,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Container(
                                          height: 20,
                                          child: (LinearPercentIndicator(
                                          width: 330,
                                          lineHeight: 14.0,
                                          percent: value['members'][DatabaseHelper.currentUserID]['progress']/value['goal'],
                                          backgroundColor: GSColors.darkCloud,
                                          progressColor: GSColors.lightBlue,
                                          center: Text((value['members'][DatabaseHelper.currentUserID]['progress']/value['goal'] * 100).toStringAsFixed(0) + "%")
                                          )  
                                        ),  
                                      )
                                    ]
                                  )
                                    )
                                  );
                                }                   
                              });               
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: challengeList,
                                  
                                  // Container(
                                  //   height: 20,
                                  //   child: (LinearPercentIndicator(
                                  //     width: 350,
                                  //     lineHeight: 14.0,
                                  //     percent: 0.5,
                                  //     backgroundColor: GSColors.darkCloud,
                                  //     progressColor: GSColors.lightBlue,
                                  //     center: Text("50%")
                                  //     )  
                                  //   ),

                                  // )
                                
                              );
                            }
                          },
                        )
                      //}
                    //}
                  // )
                ],
              ),
            )
          )
        ],
      ),
    );
  }

Future<void> _updateMemberChallengeProgress(List<int> progressList, List<String> challengeName) async{
  DocumentSnapshot groupChallenge = await Firestore.instance.collection('groups').document(group.documentID).get();
  int temp, userPoints, groupPoints, newProgress;
  String _challengeKey = getChallengeKey(); //challenge weekly date
  //DocumentSnapshot userInfo = await Firestore.instance.collection('user').document(DatabaseHelper.currentUserID).get();
  DocumentSnapshot userInfo = await DatabaseHelper.getUserSnapshot(DatabaseHelper.currentUserID);

  Map challengeMap = groupChallenge.data['challenges'];// = groupChallenge.data['challenges'][_challengeKey];

  for(int i = 0; i < progressList.length; i++)
  {
    if(progressList[i] == -999999)
      progressList[i] = 0;

      //print(challengeName[0]);
      print(challengeName.length);

      temp = progressList[i] + groupChallenge.data['challenges'][_challengeKey][challengeName[i]]['members'][DatabaseHelper.currentUserID]['progress'];

      if(progressList[i] != 0 && temp >= groupChallenge.data['challenges'][_challengeKey][challengeName[i]]['goal'] && groupChallenge.data['challenges'][_challengeKey][challengeName[i]]['members'][DatabaseHelper.currentUserID]['progress'] != groupChallenge.data['challenges'][_challengeKey][challengeName[i]]['goal'])
      {
        userPoints = groupChallenge.data['challenges'][_challengeKey][challengeName[i]]['points'] + userInfo.data['points'];
        groupPoints = groupChallenge.data['challenges'][_challengeKey][challengeName[i]]['points'];
        newProgress = groupChallenge.data['challenges'][_challengeKey][challengeName[i]]['goal'];
        
        challengeMap[_challengeKey][challengeName[i]]['members'][DatabaseHelper.currentUserID]['points'] = groupPoints;
        challengeMap[_challengeKey][challengeName[i]]['members'][DatabaseHelper.currentUserID]['progress'] = newProgress;


        Firestore.instance.collection('groups').document(group.documentID).updateData(
          {'challenges' : challengeMap}
          );
        Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).updateData(
          {'points' : userPoints}
          );
      }

      else if(progressList[i] != 0 && groupChallenge.data['challenges'][_challengeKey][challengeName[i]]['goal'] != groupChallenge.data['challenges'][_challengeKey][challengeName[i]]['members'][DatabaseHelper.currentUserID]['progress'])
      {
        newProgress = groupChallenge.data['challenges'][_challengeKey][challengeName[i]]['members'][DatabaseHelper.currentUserID]['progress']
                    + progressList[i];

        challengeMap[_challengeKey][challengeName[i]]['members'][DatabaseHelper.currentUserID]['progress'] = newProgress;
        Firestore.instance.collection('groups').document(group.documentID).updateData(
          {'challenges' : challengeMap}
          );
      }
    
    //  Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).updateData(
    //   {'points' : newPoints}
    // );

  }
}

  Future<void> _uploadGroupChallenge(Map challengeInfo, String challengeKey, String challengeTitle) async
  {
    DocumentSnapshot groupChallengeSnap = await Firestore.instance.collection('groups').document(group.documentID).get();
    Map<String, dynamic> challengeMap = groupChallengeSnap.data['challenges'].cast<String, dynamic>();
    Map<String, dynamic> newWeekMap = Map();

    if(challengeMap[challengeKey] == null)
    {
      newWeekMap = {challengeKey: {}};
      Firestore.instance.collection('groups').document(group.documentID).updateData(
      {'challenges' : newWeekMap  }
      );

      _uploadGroupChallenge(challengeInfo, challengeKey, challengeTitle);
    }

    else{
    challengeMap[challengeKey][challengeTitle] = challengeInfo;
    
    Firestore.instance.collection('groups').document(group.documentID).updateData(
      {'challenges' : challengeMap}
      );
    }
  }


  String getChallengeKey(){
  
  DateTime now = DateTime.now();
  int sunday = 7;

  while(now.weekday != sunday)
  {
    now = now.subtract(Duration(days: 1));
  }

  return now.toString().substring(0,10);
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