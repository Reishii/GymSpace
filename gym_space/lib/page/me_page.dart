import 'dart:async';

import 'package:GymSpace/logic/user.dart';
import 'package:GymSpace/page/nutrition_page.dart';
import 'package:GymSpace/widgets/image_widget.dart';
import 'package:GymSpace/widgets/media_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:GymSpace/global.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MePage extends StatefulWidget {
  User user;

  MePage({Key key}) : super(key: key);

  MePage.thisUser(this.user, {Key key});
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {

  final Future<DocumentSnapshot> _futureUser =  DatabaseHelper.getUserSnapshot(DatabaseHelper.currentUserID);
  final myController = TextEditingController();
  String filePath;
  String mediaUrl, profileImageUrl;
  String _dietKey = DateTime.now().toString().substring(0,10);
  String _challengeKey;
  int _currentTab = 0;
  User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(startPage: 
      2,),
      // appBar: _buildAppBar(context),
      appBar: AppBar(elevation: 0,),
      body: _buildBody(context),
    );
  }

  Widget _buildProfileHeading() {
    return Container(
      child: Container(
        decoration: ShapeDecoration(
          color: GSColors.darkBlue,
          shadows: [BoxShadow(blurRadius: 3)],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
          )
        ),
        child: StreamBuilder(
          stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }

            User user = User.jsonToUser(snapshot.data.data);
            
            return Container(
              margin: EdgeInsets.only(top: 10),
              decoration: ShapeDecoration(
                // color: Colors.red,
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  stops: [.25, .25, .25],
                  colors: [GSColors.darkBlue, Colors.white, GSColors.babyPowder],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0))
                )
              ),
              child: Column(
                children: <Widget>[
                  FlatButton( // profile pic
                    onPressed: () => Navigator.push(context, MaterialPageRoute<void> (
                      builder: (BuildContext context) {
                        return ImageWidget(user.photoURL, context, false);
                      })
                    ),
                    child: Container(
                      decoration: ShapeDecoration(
                        shadows: [BoxShadow(color: Colors.black, blurRadius: 4, spreadRadius: 2)],
                        shape: CircleBorder(
                          side: BorderSide(color: Colors.white, width: .5)
                        )
                      ),
                      child: CircleAvatar(
                        backgroundImage: user.photoURL.isNotEmpty ? CachedNetworkImageProvider(user.photoURL, errorListener: () => print('Failed to download')) 
                        : AssetImage(Defaults.userPhoto),
                        backgroundColor: Colors.white,
                        radius: 70,
                      ),
                    ),
                  ),
                  Divider(color: Colors.transparent),
                  Row( // name, points
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: TextStyle(
                          // color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.stars,
                          size: 14,
                          color: GSColors.green,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 4),
                        child: Text(
                          user.points.toString(),
                          style: TextStyle(
                            color: GSColors.green,
                            fontSize: 14
                          ),
                        )
                      )
                    ],
                  ),
                  Divider(color: Colors.transparent),
                  user.liftingType.isEmpty ? Container() : Text( // lifting type
                    user.liftingType,
                    style: TextStyle(
                      // color: Colors.white,
                      fontWeight: FontWeight.w300
                    ),
                  ),
                  Divider(color: Colors.transparent),
                  user.liftingType.isEmpty ? Container() : Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: Text( // bio
                      user.bio,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        // color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                  ),
                  Divider(color: Colors.transparent),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          _buildProfileHeading(),
          _buildPillNavigator(),
          _currentTab == 0 ? _buildInfoTab(context) 
            : _currentTab == 1 ? MediaTab(context)
            : _buildPostsTab(context)
        ],
      ),
    );
  }

  Widget _buildPillNavigator() {
    return Container(
      height: 40,
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      decoration: ShapeDecoration(
        color: GSColors.darkBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40)
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            child: MaterialButton( // overview
              onPressed: () { 
                if (_currentTab != 0) {
                  setState(() => _currentTab = 0);
                }
              },
            child: Text(
              'Overview',
              style: TextStyle(
                color: _currentTab == 0 ? Colors.white : Colors.white54,
                fontSize: 14,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w700,
              )),
            ),
          ),

          // Media
          Container(
            child: MaterialButton( 
            onPressed: () { 
              if (_currentTab != 1) {
                setState(() => _currentTab = 1);
              }
            },
            child: Text(
              'Media',
              style: TextStyle(
                color: _currentTab == 1 ? Colors.white : Colors.white54,
                fontSize: 14,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w700,
              )),
            ),
          ), 

          // Posts
          Container(
            child: MaterialButton( 
            onPressed: () { 
              if (_currentTab != 2) {
                setState(() => _currentTab = 2);
              }
            },
            child: Text(
              'Posts',
              style: TextStyle(
                color: _currentTab == 2 ? Colors.white : Colors.white54,
                fontSize: 14,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w700,
              )),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoTab(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _buildNutritionLabel(),
          _buildNutritionInfo(context),
          _buildWeightInfo(context),
          _buildTodaysEventsLabel(),
          _buildTodaysEventsInfo(),
          _buildChallengesLabel(),
          _buildChallengesInfo(context),
          _buildChallengeProgess(context)
        ],
      ),
    );
  }

  Widget _buildPostsTab(BuildContext context) {
    return Container();
  }

  Widget _buildNutritionLabel() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[ 
          Expanded(
            flex: 2,
            child: Container(
              height: 40,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Daily Nutrition",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                )),
                decoration: ShapeDecoration(
                  color: GSColors.darkBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topRight: Radius.circular(20)
                    )
                  )
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );
  }

  Future<void> _checkDailyMacrosExist() async{
  List<int> newMacros = new List(4);

  DocumentSnapshot macroDoc = await Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).get();//await Firestore.instance.collection('user').document(DatabaseHelper.currentUserID);
  Map<String, dynamic> macroFromDB = macroDoc.data['diet'].cast<String, dynamic>();
 
  if(macroFromDB[_dietKey] == null)
  {
    newMacros[0] = 0;   //protein
    newMacros[1] = 0;   //carbs
    newMacros[2] = 0;   //fats
    newMacros[3] = 0;   //current calories
    //newMacros[4] = 0;   //caloric goal
    macroFromDB[_dietKey] = newMacros;

    Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).updateData(
              {'diet': macroFromDB});
  }
}

  Widget _buildNutritionInfo(BuildContext context) {
  _checkDailyMacrosExist();
    return InkWell(
      //onTap: () => print("Open nutrition info"),
      child: Container(
        margin: EdgeInsets.only(top: 30),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                height: 180,
                child: Container(
                  child: StreamBuilder(
                    stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                    builder: (context, snapshot){ 
                      if(!snapshot.hasData)
                      {
                        return Container();
                      }
                      User user = User.jsonToUser(snapshot.data.data);
                      
                      //if(user.diet[_dietKey] != null && snapshot.data['diet'][_dietKey][4] > 0)
                      if(user.diet[_dietKey] != null && snapshot.data['caloricGoal'] > 0 && user.diet[_dietKey][3] <= snapshot.data['caloricGoal'])
                      {
                        return CircularPercentIndicator(
                          animation: true,
                          radius: 130.0,
                          lineWidth: 17,
                          percent: snapshot.data['diet'][_dietKey][3] / snapshot.data['caloricGoal'],
                          progressColor: GSColors.green,
                          backgroundColor: GSColors.darkCloud,
                          circularStrokeCap: CircularStrokeCap.round,
                          footer:   
                            Text(
                              "Calories Consumed",
                              style: TextStyle(fontSize: 16.0),
                            ),
                          center: 
                            Text(
                              '${user.diet[_dietKey][3]}',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0),

                          ),
                        );
                      }
                      
                      else if(user.diet[_dietKey] != null && snapshot.data['caloricGoal'] > 0 && user.diet[_dietKey][3] > snapshot.data['caloricGoal'])
                      {
                        return CircularPercentIndicator(
                          radius: 130.0,
                          lineWidth: 17,  
                          percent: 1.0,
                          progressColor: GSColors.green,
                          backgroundColor: GSColors.darkCloud,
                          center: Text ( 
                            '${user.diet[_dietKey][3]}',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0),
                          ),
                          footer:   
                            Text(
                              "Calories Consumed",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                          
                        );
                      }
                      else if(user.diet[_dietKey] != null && snapshot.data['caloricGoal'] == 0)
                      {
                        return CircularPercentIndicator(
                          radius: 130.0,
                          lineWidth: 17,  
                          percent: 0.0,
                          progressColor: GSColors.darkCloud,
                          backgroundColor: GSColors.darkCloud,
                          center: Text ( 
                            '${user.diet[_dietKey][3]}',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0),
                          ),
                          footer:   
                            Text(
                              "Calories Consumed",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                        );
                      }

                      else
                      {
                        return CircularPercentIndicator(
                          radius: 130.0,
                          lineWidth: 17,  
                          percent: 0,
                          progressColor: GSColors.darkCloud,
                          backgroundColor: GSColors.darkCloud,
                          footer:   
                            Text(
                              "Calories Consumed",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                        );
                      }
    
                    }
                  )
                )
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin:EdgeInsets.only(top: 10, bottom: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Proteins: ",
                                      style: TextStyle(fontSize: 16)),
                            StreamBuilder(
                              stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                User user = User.jsonToUser(snapshot.data.data);

                                if(user.diet[_dietKey] == null)
                                {
                                  return Text(
                                    '0 g ',
                                      style: TextStyle(fontSize: 16),
                                  );                        
                                }
                                else
                                {
                                  return Text(
                                    '${user.diet[_dietKey][0].toString()} g ',
                                      style: TextStyle(fontSize: 16),
                                  );
                                }
                              
                              }
                            )
                          ],
                        )
                      ),
                      Container(
                        margin:EdgeInsets.only(bottom: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Carbs: ",
                                      style: TextStyle(fontSize: 16)),
                            StreamBuilder(
                              stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                User user = User.jsonToUser(snapshot.data.data);
                               
                               if(user.diet[_dietKey] == null)
                                {
                                  return Text(  
                                    '0 g ',
                                      style: TextStyle(fontSize: 16),
                                  );                        
                                }
                                else
                                {
                                  return Text(
                                    '${user.diet[_dietKey][1].toString()} g ',
                                      style: TextStyle(fontSize: 16),
                                  );
                                } 
                              }
                            )
                          ],
                        )
                      ),
                      Container(
                        margin:EdgeInsets.only(bottom: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Fats: " ,
                                      style: TextStyle(fontSize: 16)),
                            StreamBuilder(
                              stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                User user = User.jsonToUser(snapshot.data.data);
                                
                                if(user.diet[_dietKey] == null)
                                {
                                  return Text(
                                    '0 g ',
                                      style: TextStyle(fontSize: 16),
                                  );                        
                                }
                                else
                                {
                                  return Text(
                                    '${user.diet[_dietKey][2].toString()} g ',
                                      style: TextStyle(fontSize: 16),
                                  );
                                }
                              
                              }
                            )
                          ],
                        )
                      ),
                      Container(
                        margin:EdgeInsets.only(bottom: 10, right: 13),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Caloric Goal: ",
                                  style: TextStyle(fontSize: 16)),
                            StreamBuilder(
                              stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                User user = User.jsonToUser(snapshot.data.data);

                                  if(user.caloricGoal == null)
                                  {
                                    return Text('0 ',
                                      style: TextStyle(fontSize: 16));
                                  }
                                  else
                                  {
                                    return Text('${user.caloricGoal.toString()}',
                                      style: TextStyle(fontSize: 16));
                                  }
                                // if(user.diet[_dietKey] == null)
                                // {
                                //   return Text(
                                //     '0 '
                                //   );                        
                                // }
                                // else
                                // {
                                //   return Text(
                                //     '${user.diet[_dietKey][4].toString()} '
                                //   );
                                //}
                              }
                            )
                          ],
                        )
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ),
      onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute<void>(
          builder: (BuildContext context){
          return NutritionPage(); 
          }   
        ));
      },
      onLongPress:() {_updateNutritionInfo(context);},
    );
  }

  Widget _buildWeightInfo(BuildContext context) {
    // return InkWell(
      return Container(
        margin: EdgeInsets.only(top: 30),
        // padding: EdgeInsets.symmetric(vertical: 20),
        decoration: ShapeDecoration(
          color: GSColors.darkBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              topLeft: Radius.circular(20)
            )
          )
        ),
        child: InkWell(
        onTap: () => _updateWeightInfo(context),
        child: Column(
          children: <Widget>[
            _buildStartingWeight(),
            _buildCurrentWeight(),
          ],
        ),
    ),
      );
  }

  Widget _buildCurrentWeight() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Container(
            margin: EdgeInsets.only(left: 20),
            padding: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              "Current Weight",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              )),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            child: FutureBuilder(
              future: _futureUser,
              builder: (context, snapshot) =>
                Text(
                  snapshot.hasData ? snapshot.data['currentWeight'].toString() + ' lbs' : '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14
                  ),
                )
              ),
            ),
          ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            child: FutureBuilder(
              future: _futureUser,
              builder: (context, snapshot) {
                double weightLost = snapshot.hasData ? (snapshot.data['startingWeight'] - snapshot.data['currentWeight']) : 0;
                
                if(weightLost > 0)
                  return Row(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.caretDown, color: Colors.red, size: 16),
                      Text(
                        weightLost.toStringAsFixed(2),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      )
                    ],
                  );
                else if (weightLost < 0) {
                  return Row(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.caretUp, color: GSColors.green, size: 16),
                      Text(
                          weightLost.toStringAsFixed(2),
                          style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      )
                    ],
                  );
                } else 
                  return Container();
              }
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStartingWeight() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Container(
            margin: EdgeInsets.only(left: 20),
            padding: EdgeInsets.only(top: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              "Starting Weight",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              )),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            child: FutureBuilder(
              future: _futureUser,
              builder: (context, snapshot) =>
              Text(
                snapshot.hasData ? snapshot.data['startingWeight'].toString() + " lbs" : "",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14
                ),
              )
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
      ],
    );
  }

  Widget _buildTodaysEventsInfo() {
    return Container (
      margin: EdgeInsets.only(top: 30),
      child: Text("Update this to be workout or group event."),
    );
  }

  Widget _buildTodaysEventsLabel() {
    return Container (
      margin: EdgeInsets.only(top: 30),
      height: 40,
      child: Row (
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              height: 40,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Today's Activities",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                  )),
                decoration: ShapeDecoration(
                  color: GSColors.darkBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20)
                    )
                  )
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengesLabel() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      height: 40,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                color: GSColors.darkBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  )
                )
              ),
              child: Text(
                "Weekly Challenges",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
              )),
            ),
          ),
        ],
      ),
    );
  }

  void _updateChallengeInfo(BuildContext context) async{
 int challenge1, challenge2, challenge3;
      DocumentSnapshot macroDoc = await Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).get();//await Firestore.instance.collection('user').document(DatabaseHelper.currentUserID);
      List<int> challengeFromUser = macroDoc.data['challengeStatus'].cast<int>();
      int pointsFromUser = macroDoc.data['points'];
      DocumentSnapshot challengeDoc = await Firestore.instance.collection('challenges').document(_challengeKey).get();
      List<int> challengeInfoDB = challengeDoc.data['goal'].cast<int>();
      List<int> pointsFromChallenge = challengeDoc.data['points'].cast<int>();
      showDialog<String>(
         context: context,
      //child: SingleChildScrollView(
        //padding: EdgeInsets.all(5.0),
        child: AlertDialog(
        title: Text("Update your daily macros"),
        contentPadding: const EdgeInsets.all(16.0),
        content:  
          Container(
          //Row(
          height: 350,
          width: 350,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
             Flexible(
              child:  
              StreamBuilder(
                stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                builder: (context, snapshotUser) {
                  if (!snapshotUser.hasData) {
                    return Container();
                  }
                User user = User.jsonToUser(snapshotUser.data.data);
                return StreamBuilder(
                  stream: DatabaseHelper.getWeeklyChallenges(_challengeKey),
                  builder: (context, snapshotChallenge){
                  if(!snapshotChallenge.hasData)
                  {
                    return Text(
                      'Loading...' 
                    );               
                  }       
                  return TextField(
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: '${snapshotChallenge.data['title'][0]}',
                      labelStyle: TextStyle(
                        fontSize: 18.0,
                        color: GSColors.darkBlue,
                      ),
                      contentPadding: EdgeInsets.all(10.0),
                      hintText: '${user.challengeStatus[0]}/${snapshotChallenge.data['goal'][0]} ${snapshotChallenge.data['units'][0]} Completed',
                      hintStyle: TextStyle(
                        color: GSColors.lightBlue,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    onChanged: (text) {
                      (text != null) ? challenge1 = int.parse(text): challenge1 = 0;
                    }
                  );      
                  }
                );
                }
              )
            ), 
            Flexible(         
              child:  
              StreamBuilder(
                stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                builder: (context, snapshotUser) {
                  if (!snapshotUser.hasData) {
                    return Container();
                  }
                User user = User.jsonToUser(snapshotUser.data.data);
                return StreamBuilder(
                  stream: DatabaseHelper.getWeeklyChallenges(_challengeKey),
                  builder: (context, snapshotChallenge){
                  if(!snapshotChallenge.hasData)
                  {
                    return Text(
                      'Loading...' 
                    );               
                  }       
                  return TextField(
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: '${snapshotChallenge.data['title'][1]}',
                      labelStyle: TextStyle(
                        fontSize: 18.0,
                        color: GSColors.darkBlue,
                      ),
                      contentPadding: EdgeInsets.all(10.0),
                      hintText: '${user.challengeStatus[1]}/${snapshotChallenge.data['goal'][1]} ${snapshotChallenge.data['units'][1]} Completed',
                      hintStyle: TextStyle(
                        color: GSColors.lightBlue,
                        fontWeight: FontWeight.bold,

                      )
                    ),
                    onChanged: (text) {
                      (text != null) ? challenge2 = int.parse(text): challenge2 = 0;
                    }
                  );      
                  }
                );
                }
              )
            ),
            Flexible(         
              child:  
              StreamBuilder(
                stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                builder: (context, snapshotUser) {
                  if (!snapshotUser.hasData) {
                    return Container();
                  }
                User user = User.jsonToUser(snapshotUser.data.data);
                return StreamBuilder(
                  stream: DatabaseHelper.getWeeklyChallenges(_challengeKey),
                  builder: (context, snapshotChallenge){
                  if(!snapshotChallenge.hasData)
                  {
                    return Text(
                      'Loading...' 
                    );               
                  }       
                  return TextField(
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: '${snapshotChallenge.data['title'][2]}',
                      labelStyle: TextStyle(
                        fontSize: 18.0,
                        color: GSColors.darkBlue,
                      ),
                      contentPadding: EdgeInsets.all(10.0),
                      hintText: '${user.challengeStatus[2]}/${snapshotChallenge.data['goal'][2]} ${snapshotChallenge.data['units'][2]} Completed',
                      hintStyle: TextStyle(
                        color: GSColors.lightBlue,
                        fontWeight: FontWeight.bold,

                      )
                    ),
                    onChanged: (text) {
                      (text != null) ? challenge3 = int.parse(text): challenge3 = 0;
                    }
                  );      
                  }
                );
                }
              )
            ),

          ],
          )
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('Cancel'),
            onPressed: (){
              Navigator.pop(context);
            }
          ),
          FlatButton(
            child: const Text('Save'),
            onPressed: () {
                if(challenge1 == null)
                  challenge1 = 0;
                if(challenge2 == null)
                  challenge2 = 0;
                if(challenge3 == null)
                  challenge3 = 0;

                int temp;
                temp = challengeFromUser[0] + challenge1;
                if(temp >= challengeInfoDB[0] && challengeFromUser[0] != challengeInfoDB[0])
                {
                    challengeFromUser[0] = challengeInfoDB[0];
                    pointsFromUser += pointsFromChallenge[0];

                }
                else if(challengeFromUser[0] != challengeInfoDB[0])
                {
                  challengeFromUser[0] += challenge1;
                }

                temp = challengeFromUser[1] + challenge2;
                if(temp >= challengeInfoDB[1] && challengeFromUser[1] != challengeInfoDB[1])
                {
                    challengeFromUser[1] = challengeInfoDB[1];
                    pointsFromUser += pointsFromChallenge[1];

                }
                else if(challengeFromUser[1] != challengeInfoDB[1])
                {
                  challengeFromUser[1] += challenge2;
                }

                temp = challengeFromUser[2] + challenge3;
                if(temp >= challengeInfoDB[2] && challengeFromUser[2] != challengeInfoDB[2])
                {
                    challengeFromUser[2] = challengeInfoDB[2];
                    pointsFromUser += pointsFromChallenge[2];
                }
                else if(challengeFromUser[2] != challengeInfoDB[2])
                {
                  challengeFromUser[2] += challenge3;
                }
          
                  Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).updateData(
                    {'challengeStatus': challengeFromUser});
                  Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).updateData(
                    {'points': pointsFromUser});
                  // _buildNutritionInfo(context);
                  _buildChallengesInfo(context);  

            Navigator.pop(context);
            }
          )
        ],
      )
    );
 }

  Widget _buildChallengesInfo(BuildContext context) {
    _challengeKey = getChallengeKey().toString();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: InkWell(
        onLongPress: () => _updateChallengeInfo(context),
        child: Container(
          margin: EdgeInsets.only(top: 10),
          child: StreamBuilder(
            stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
            builder: (context, snapshot) {
              if (!snapshot.hasData) 
                return Container();

              User user = User.jsonToUser(snapshot.data.data);
              user.documentID = snapshot.data.documentID;

              return Container(
                child: StreamBuilder(
                  stream: DatabaseHelper.getWeeklyChallenges(_challengeKey),
                  builder: (context, snapshotChallenge) {
                    if (!snapshotChallenge.hasData) {
                      return Column(
                        children: <Widget> [
                          Text(' Loading...'),
                          LinearPercentIndicator( // challenge progress
                            lineHeight: 14.0,
                            percent: 0.0,
                            backgroundColor: GSColors.darkCloud,
                            progressColor: GSColors.lightBlue,
                            center: Text('0%'),
                          )
                        ]
                      );
                    }
                    if (snapshotChallenge.data.data == null) 
                      return Container();
                    List<Widget> challengeWidgets = List();
                    for (int challengeIndex = 0; challengeIndex < snapshotChallenge.data.data['title'].length; challengeIndex++) {
                      challengeWidgets.add(_buildChallenge(snapshotChallenge.data.data, challengeIndex, user));
                    }

                    return Column(children: challengeWidgets);
                  },
                ),
              );
            },
          ),
        ),
      )
    );
  }

  Widget _buildChallenge(Map<String, dynamic> challenge, int i, user) {
    return Container(
      child: Column(
        children: <Widget> [
          Row( // challenge info
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text(
                  ' $i. ${challenge['title'][i]}'
                ),
              ),
              Container(
                child: Text(
                  '${challenge['points'][i]} Points',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: LinearPercentIndicator(
              lineHeight: 14.0,
              percent: user.challengeStatus[i] / challenge['goal'][i],
              backgroundColor: GSColors.darkCloud,
              progressColor: user.challengeStatus[i] == challenge['goal'][i] ? GSColors.green : GSColors.lightBlue,
              center: Text(
                (user.challengeStatus[i] / challenge['goal'][i] * 100).toStringAsFixed(0) + ' %'
              )
            )
          )
        ],
      ),
    );
  }

  Widget _buildChallengeProgess(BuildContext context){
    return Container(
      height: 260,
      child: StreamBuilder(
        stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
        builder: (context, snapshot){ 
          if(!snapshot.hasData)
          {
            return Container();
          }
          User user = User.jsonToUser(snapshot.data.data);
          
          return StreamBuilder(
            stream: DatabaseHelper.getWeeklyChallenges(_challengeKey),
            builder: (context, snapshotChallenge){
              if(!snapshotChallenge.hasData)
              {
                return Text(
                  ' Loading...'
                  );                        
              }
              if (snapshotChallenge.data.data == null) 
                return Container();

              int totalProgress = user.challengeStatus[0] + user.challengeStatus[1] + user.challengeStatus[2];
              int totalGoal = snapshotChallenge.data['goal'][0] + snapshotChallenge.data['goal'][1] + snapshotChallenge.data['goal'][2];
              
              if(totalProgress == totalGoal)
              {
                return CircularPercentIndicator(
                radius: 200.0,
                lineWidth: 17,
                percent: totalProgress / totalGoal,
                progressColor: GSColors.green,
                backgroundColor: GSColors.darkCloud,
                circularStrokeCap: CircularStrokeCap.round,
                footer:   
                  Text(
                    "Weekly Challenges Progress",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                center: 
                  Text(
                   "100%",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35.0),

                ),
              );
              }
              else
              {
              return CircularPercentIndicator(
                radius: 200.0,
                lineWidth: 17,
                percent: totalProgress / totalGoal,
                progressColor: GSColors.lightBlue,
                backgroundColor: GSColors.darkCloud,
                circularStrokeCap: CircularStrokeCap.round,
                footer:   
                  Text(
                    "Weekly Challenges Progress",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                center: 
                  Text(
                    (totalProgress / totalGoal * 100.00).toStringAsFixed(0) + "%",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35.0),

                ),
              );
              }
            //}
            // else
            // {
            //   return CircularPercentIndicator(
            //     radius: 200.0,
            //     lineWidth: 17,  
            //     percent: 0,
            //     progressColor: Colors.green,
            //     backgroundColor: GSColors.darkCloud
            //   );
            // }
          }
          );
        }
          
      )
    );
  }

  String getChallengeKey(){
  
  DateTime now = DateTime.now();
  int sunday = 7;

  while(now.weekday != sunday)
  {
    now = now.subtract(Duration(days: 1));
  }

  return "weekOf" + now.toString().substring(0,10);
} 

  void  _updateNutritionInfo(BuildContext context) async{
      int protein, carbs, fats, currentCalories = 0, caloricGoal;
      DocumentSnapshot macroDoc = await Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).get();//await Firestore.instance.collection('user').document(DatabaseHelper.currentUserID);
      Map<String, dynamic> macroFromDB = macroDoc.data['diet'].cast<String, dynamic>();
      int caloriesGoal = macroDoc.data['caloricGoal'];
      
    showDialog<String>(
      context: context,
      //child: SingleChildScrollView(
        //padding: EdgeInsets.all(5.0),
      builder: (context) => AlertDialog(
        title: Text("Update your daily macros"),
        contentPadding: const EdgeInsets.all(16.0),
        content:  
          Container(
          //Row(
          height: 350,
          width: 350,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
             Flexible(
              child:  TextField(
                keyboardType: TextInputType.number,
                maxLines: 1,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Protein',
                  labelStyle: TextStyle(
                    fontSize: 18.0,
                    color: GSColors.darkBlue,
                  ),
                  contentPadding: EdgeInsets.all(10.0)
                ),
                onChanged: (text) {
                  (text != null) ? protein = int.parse(text): protein = 0;
                  (text != null) ? currentCalories += protein * 4: currentCalories += 0;
                }
              ),
            ),
            
            Flexible(
              child:  TextField(
                keyboardType: TextInputType.number,
                maxLines: 1,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Carbs',
                  labelStyle: TextStyle(
                    fontSize: 18.0,
                    color: GSColors.darkBlue,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    color: GSColors.darkBlue,
                  ),
                    contentPadding: EdgeInsets.all(10.0)
                ),
                onChanged: (text) { 
                  text != null ? carbs = int.parse(text) : carbs = 0;
                  text != null ? currentCalories += carbs * 4 : currentCalories += 0;
                }
              ),
            ),
    
            Flexible(
              child:  TextField(
                keyboardType: TextInputType.number,
                maxLines: 1,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Fats',
                  labelStyle: TextStyle(
                    fontSize: 18.0,
                    color: GSColors.darkBlue,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    color: GSColors.darkBlue,
                  ),
                    contentPadding: EdgeInsets.all(10.0)
                ),
                onChanged: (text) {
                    text != null ? fats = int.parse(text) : fats = 0;
                    text != null ? currentCalories += fats * 9 : currentCalories += 0;
                }
              ),
            ),

             Flexible(
              child:  TextField(
                keyboardType: TextInputType.number,
                maxLines: 1,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Caloric Goal',
                  labelStyle: TextStyle(
                    fontSize: 18.0,
                    color: GSColors.darkBlue,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    color: GSColors.darkBlue,
                  ),
                    contentPadding: EdgeInsets.all(10.0)
                ),
                onChanged: (text) {
                    text != null ? caloricGoal = int.parse(text) : caloricGoal = -1;
                }
              )
             )

          ],
        )),
        actions: <Widget>[
          FlatButton(
            child: const Text('Cancel'),
            onPressed: (){
              currentCalories = 0;
              Navigator.pop(context);
            }
          ),
          FlatButton(
            child: const Text('Save'),
            onPressed: (){

            if(protein == null)
              protein = 0;
            if(carbs == null)
              carbs = 0;
            if(fats == null)
              fats = 0;
            if(currentCalories == null)
              currentCalories = 0;
            if(caloricGoal == null)
              caloricGoal = -1;

            macroFromDB[_dietKey][0] += protein;
            macroFromDB[_dietKey][1] += carbs;
            macroFromDB[_dietKey][2] += fats;
            macroFromDB[_dietKey][3] += currentCalories;
            if(caloricGoal != -1)
               Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).updateData(
              {'caloricGoal': caloricGoal});
              // caloriesGoal = caloricGoal;
              //macroFromDB[_dietKey][4] = caloricGoal;
            
            currentCalories = 0;

            Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).updateData(
              {'diet': macroFromDB});
            // Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).updateData(
            //   {'caloricGoal': caloriesGoal});
            _buildNutritionInfo(context);

            Navigator.pop(context);
            }
          )
        ],
      )

    );
  }

  void  _updateWeightInfo(BuildContext context) async{
      String currentWeight, startingWeight;
     // currentWeight = Firestore.instance.collection('users').document('${DatabaseHelper.currentUserID}').;

    showDialog<String>(
      context: context,
      //child: SingleChildScrollView(
        //padding: EdgeInsets.all(20),
        child: AlertDialog(
        title: Text("Change your current weight"),
        contentPadding: const EdgeInsets.all(16.0),
        content:  
          //Row(
          Container(
          height: 200,
          child: Column(
            children: <Widget>[
             
             
            Flexible(
              child:  TextField(
                keyboardType: TextInputType.number,
                maxLines: 1,
                //maxLength: 3,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Starting',
                  labelStyle: TextStyle(
                    fontSize: 18.0,
                    color: GSColors.darkBlue,
                  ),
                ),
                onChanged: (text) => startingWeight = text,
              ),
            ),
            
             SizedBox(height: 50.0,),
             
             Flexible(
              child:  TextField(
                keyboardType: TextInputType.number,
                maxLines: 1,
                //maxLength: 3,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Current',
                  labelStyle: TextStyle(
                    fontSize: 18.0,
                    color: GSColors.darkBlue,
                  ),
                ),
                onChanged: (text) => currentWeight = text,
              ),
            ),


            ]
          ),       
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('Cancel'),
            onPressed: (){
              startingWeight = "";
              currentWeight = "";
              Navigator.pop(context);
            }
          ),
          FlatButton(
            child: const Text('Save'),
            onPressed: (){


            print(startingWeight);
            print(currentWeight);
            if (startingWeight != null)
              {
                Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).updateData({'startingWeight' : double.parse(startingWeight) });
              }

            if (currentWeight != null)
            {
              Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).updateData({'currentWeight' : double.parse(currentWeight) });
            }
            _buildStartingWeight();
            _buildCurrentWeight();
            Navigator.pop(context);
            }
          )
        ],
      ),
    );
  }
}

class _SystemPadding extends StatelessWidget{
  final Widget child;
 _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}