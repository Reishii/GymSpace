import 'package:GymSpace/logic/user.dart';
import 'package:GymSpace/page/nutrition_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:GymSpace/global.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:GymSpace/logic/challenge.dart';



class MePage extends StatelessWidget {
  final Widget child;
  Future<DocumentSnapshot> _futureUser =  DatabaseHelper.getUserSnapshot( DatabaseHelper.currentUserID);
  final myController = TextEditingController();
  MePage({Key key, this.child}) : super(key: key);

  File imageFile;
  String imageUrl;
  String _myKey = DateTime.now().toString().substring(0,10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(startPage: 
      2,),
      // appBar: _buildAppBar(context),
      appBar: AppBar(elevation: 0,),
      body: _buildBody(context),
      
      // floatingActionButton: Column(
      //   //crossAxisAlignment: CrossAxisAlignment.center,
      //   //mainAxisSize: MainAxisSize.min,
        
      //   children: <Widget>[
      //     FloatingActionButton(
      //       heroTag: null,
      //       child: Icon(Icons.edit, color: GSColors.cloud),
      //       onPressed:(){
      //         _updateMeInfo(context);
      //       },
      //       backgroundColor: GSColors.blue,

      //     ),
      //     SizedBox(
      //       height: 200.0,
      //     ),
      //     FloatingActionButton(
      //       heroTag: null,
      //       child: Icon(Icons.edit, color: GSColors.cloud),
      //       onPressed: (){
      //         _updateMeInfo(context);
      //       },
      //       backgroundColor: GSColors.blue,

      //     ),
      //      SizedBox(
      //       height: 350.0,
      //     ),
      //   ],
      // ),
      

    );

  }

  Widget _buildProfileHeading() {
    return Container(
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
            child: Column(
              children: <Widget>[
                InkWell( // profile pic
                  onLongPress: () => getImage(),
                  child: Container(
                    decoration: ShapeDecoration(
                      shape: CircleBorder(
                        side: BorderSide(color: Colors.white, width: 1)
                      )
                    ),
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(user.photoURL.isEmpty ? Defaults.photoURL : user.photoURL, errorListener: () => print('Failed to download')),
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
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.stars,
                        size: 14,
                        color: Colors.yellow,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 4),
                      child: Text(
                        user.points.toString(),
                        style: TextStyle(
                          color: Colors.yellow,
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
                    color: Colors.white,
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
                      color: Colors.white,
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
    );
  }

  // Future<void> _updateMeInfo() async{
   

  Widget _buildBody(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          _buildProfileHeading(),
          _buildNutritionLabel(),
          _buildNutritionInfo(context),
          _buildWeightInfo(context),
          _buildTodaysEventsLabel(),
          _buildTodaysEventsInfo(),
          _buildChallengesLabel(),
          _buildChallengesInfo()
        ],
      ),
    );
  }

  Widget _buildNutritionLabel() {
    return Container(
      margin: EdgeInsets.only(top: 30),
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
                    letterSpacing: 1.2
                  ),
                ),
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
  List<int> newMacros = new List(5);

  DocumentSnapshot macroDoc = await Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).get();//await Firestore.instance.collection('user').document(DatabaseHelper.currentUserID);
  var macroFromDB = macroDoc.data['diet'];
 
  if(macroFromDB[_myKey] == null)
  {
    newMacros[0] = 0;   //protein
    newMacros[1] = 0;   //carbs
    newMacros[2] = 0;   //fats
    newMacros[3] = 0;   //current calories
    newMacros[4] = 0;   //caloric goal


    macroFromDB[_myKey] = newMacros;

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
                //  child:  CircularPercentIndicator(
                //           radius: 120.0,
                //           lineWidth: 10,
                //           percent: 0.8,
                //           progressColor: Colors.green,
                //           backgroundColor: GSColors.darkCloud,
                //           animateFromLastPercent: true,
                //           animation: true
                //         ),
                  child: StreamBuilder(
                    stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                    builder: (context, snapshot){ 
                      if(!snapshot.hasData)
                      {
                        return Container();
                      }
                      User user = User.jsonToUser(snapshot.data.data);
                      
                      if(user.diet[_myKey] != null && snapshot.data['diet'][_myKey][4] > 0)
                      {
                        return CircularPercentIndicator(
                          radius: 130.0,
                          lineWidth: 17,
                          percent: snapshot.data['diet'][_myKey][3] / snapshot.data['diet'][_myKey][4] <= 1.0 ? snapshot.data['diet'][_myKey][3] / snapshot.data['diet'][_myKey][4] : 1.0,
                          progressColor: Colors.green,
                          backgroundColor: GSColors.darkCloud,
                          circularStrokeCap: CircularStrokeCap.round,
                          footer:   
                            Text(
                              "Daily Caloric Goal",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                          center: 
                            Text(
                              snapshot.data['diet'][_myKey][3] / snapshot.data['diet'][_myKey][4] <= 1.0 ? (100.0 * snapshot.data['diet'][_myKey][3] / snapshot.data['diet'][_myKey][4]).toString() + "%" : "0.00 %",
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
                          progressColor: Colors.green,
                          backgroundColor: GSColors.darkCloud
                        );
                      }
    
                    }
                  )

                  // decoration: ShapeDecoration(
                  //   shape: CircleBorder(
                  //     side: BorderSide(
                  //       width: 16,
                  //       color: GSColors.darkBlue
                  //     )
                  //   )
                  // ),
                )
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                // margin: EdgeInsets.only(right: 100),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin:EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Protein: "),
                            StreamBuilder(
                              stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                User user = User.jsonToUser(snapshot.data.data);

                                if(user.diet[_myKey] == null)
                                {
                                  return Text(
                                    '0 g '
                                  );                        
                                }
                                else
                                {
                                  return Text(
                                    '${user.diet[_myKey][0].toString()} g '
                                  );
                                }
                              
                              }
                            )
                          ],
                        )
                      ),
                      Container(
                        margin:EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Carbs: "),
                            StreamBuilder(
                              stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                User user = User.jsonToUser(snapshot.data.data);
                               
                               if(user.diet[_myKey] == null)
                                {
                                  return Text(  
                                    '0 g '
                                  );                        
                                }
                                else
                                {
                                  return Text(
                                    '${user.diet[_myKey][1].toString()} g '
                                  );
                                } 
                              }
                            )
                          ],
                        )
                      ),
                      Container(
                        margin:EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Fats: "),
                            StreamBuilder(
                              stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                User user = User.jsonToUser(snapshot.data.data);
                                
                                if(user.diet[_myKey] == null)
                                {
                                  return Text(
                                    '0 g '
                                  );                        
                                }
                                else
                                {
                                  return Text(
                                    '${user.diet[_myKey][2].toString()} g '
                                  );
                                }
                              
                              }
                            )
                          ],
                        )
                      ),
                      Container(
                        margin:EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Daily Calories: "),
                            StreamBuilder(
                              stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                User user = User.jsonToUser(snapshot.data.data);

                                if(user.diet[_myKey] == null)
                                {
                                  return Text(
                                    '0 '
                                  );                        
                                }
                                else
                                {
                                  return Text(
                                    '${user.diet[_myKey][3].toString()} '
                                  );
                                }
                              
                              }
                            )
                          ],
                        )
                      ),
                      Container(
                        margin:EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Caloric Goal: "),
                            StreamBuilder(
                              stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                User user = User.jsonToUser(snapshot.data.data);

                                if(user.diet[_myKey] == null)
                                {
                                  return Text(
                                    '0 '
                                  );                        
                                }
                                else
                                {
                                  return Text(
                                    '${user.diet[_myKey][4].toString()} '
                                  );
                                }
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
      onTap: () => NutritionPage(),
      onLongPress: () =>
        _updateNutritionInfo(context),
    );
  }

  Widget _buildWeightInfo(BuildContext context) {
    // return InkWell(
      return Container(
        height: 80,
        margin: EdgeInsets.only(top: 30),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            alignment: Alignment.centerLeft,
            child: Text(
              "Current Weight",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                letterSpacing: 1.2
              ),
            ),
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
            child: Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.caretDown, color: Colors.red, size: 16),
                FutureBuilder(
                  future: _futureUser,
                  builder: (context, snapshot) {
                    double weightLost = snapshot.hasData ? (snapshot.data['startingWeight'] - snapshot.data['currentWeight']) : 0;
                    return Text(
                      weightLost.toStringAsFixed(2),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    );
                  }
                ),
              ],
            )
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
            alignment: Alignment.centerLeft,
            child: Text(
              "Starting Weight",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                letterSpacing: 1.2
              ),
            ),
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
                    letterSpacing: 1.2
                  ),
                ),
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
                style:TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  letterSpacing: 1.2
                )
              ),
            ),
          ),
        ],
      ),
    );
  }

 Widget _updateChallengeInfo() {
   //alert dialog...
 }

  Widget _buildChallengesInfo() {
  //Challenge challenge = Challenge.jsonToChallenge(snapshot.data.data);
  //User user = User.jsonToUser(snapshot.data.data);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      child: InkWell(
        child: Container(
        margin: EdgeInsets.only(top: 30),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                height: 140,
                child: Container(
                  decoration: ShapeDecoration(
                    shape: CircleBorder(
                      side: BorderSide(
                        width: 16,
                        color: GSColors.darkBlue
                      )
                    )
                  ),
                )
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin:EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("1: "),
                            StreamBuilder(
                              stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }

                                User user = User.jsonToUser(snapshot.data.data);

                                if(user.diet[_myKey] == null)
                                {
                                  return Text(
                                    '0 g'
                                  );                        
                                }
                                else
                                {
                                  return Text(
                                    '${user.diet[_myKey][0].toString()} g'
                                  );
                                }
                              }
                            )                         
                          ],
                        )
                      ),
                      Container(
                        margin:EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("2: "),
                            StreamBuilder(
                              stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                User user = User.jsonToUser(snapshot.data.data);
                               
                               if(user.diet[_myKey] == null)
                                {
                                  return Text(  
                                    '0 g'
                                  );                        
                                }
                                else
                                {
                                  return Text(
                                    '${user.diet[_myKey][1].toString()} g'
                                  );
                                }                          
                              }
                            )
                          ],
                        )
                      ),Container(
                        margin:EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("3: "),
                            StreamBuilder(
                              stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                User user = User.jsonToUser(snapshot.data.data);
                                
                                if(user.diet[_myKey] == null)
                                {
                                  return Text(
                                    '0 g'
                                  );                        
                                }
                                else
                                {
                                  return Text(
                                    '${user.diet[_myKey][2].toString()} g'
                                  );
                                }                              
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
        onLongPress: () => _updateChallengeInfo(),
      )
      );
  }

Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    
    if(imageFile != null){
      uploadFile();
    }
}


Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    await storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
    }, onError: (err) {

      Fluttertoast.showToast(msg: 'This file is not an image');
    });

        
  Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).updateData({'photoURL' : imageUrl });
            

  }



void  _updateNutritionInfo(BuildContext context) async{
      int protein, carbs, fats, currentCalories = 0, caloricGoal;
      DocumentSnapshot macroDoc = await Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).get();//await Firestore.instance.collection('user').document(DatabaseHelper.currentUserID);
      var macroFromDB = macroDoc.data['diet'];
      
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
          height: 200,
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

            macroFromDB[_myKey][0] += protein;
            macroFromDB[_myKey][1] += carbs;
            macroFromDB[_myKey][2] += fats;
            macroFromDB[_myKey][3] += currentCalories;
            if(caloricGoal != -1)
              macroFromDB[_myKey][4] = caloricGoal;

            print("*******************************************************************************");
            print(caloricGoal);
            
            currentCalories = 0;

            Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).updateData(
              {'diet': macroFromDB});
            _buildNutritionInfo(context);

            Navigator.pop(context);
            }
          )
        ],
      )
    );
  }
}

void  _updateWeightInfo(BuildContext context) async{
      String currentWeight, startingWeight;
      DocumentReference ref;
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
             Expanded(
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

             SizedBox(width: 5.0,),

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

            if (startingWeight != "")
              {
                Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).updateData({'startingWeight' : double.parse(startingWeight) });
              }

            if (currentWeight != "")
            {
              Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).updateData({'currentWeight' : double.parse(currentWeight) });
            }

            Navigator.pop(context);
            }
          )
        ],
      ),
    );
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
