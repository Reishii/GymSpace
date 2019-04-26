import 'package:GymSpace/logic/user.dart';
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

class MePage extends StatelessWidget {
  final Widget child;
  Future<DocumentSnapshot> _futureUser =  DatabaseHelper.getUserSnapshot( DatabaseHelper.currentUserID);
  final myController = TextEditingController();
  MePage({Key key, this.child}) : super(key: key);

  TextEditingController _liftingTypeController = TextEditingController();
  File imageFile;
  String imageUrl;

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

  Widget _buildNutritionInfo(BuildContext context) {
    return InkWell(
      //onTap: () => print("Open nutrition info"),
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
                            Text("100g")
                          ],
                        )
                      ),
                      Container(
                        margin:EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Carbs: "),
                            Text("60g")
                          ],
                        )
                      ),Container(
                        margin:EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Fats: "),
                            Text("20g")
                          ],
                        )
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: FractionalOffset.center,
                  child: Icon(
                    Icons.edit,
                    color: GSColors.darkBlue,
                  ),
                
              ),
            ),
          ],
        )
      ),
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
        onLongPress: () => _updateWeightInfo(context),
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
                "Challenges",
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

  Widget _buildChallengesInfo() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
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
      String currentWeight, startingWeight, protein, carbs, fats;

     // currentWeight = Firestore.instance.collection('users').document('${DatabaseHelper.currentUserID}').;

    showDialog<String>(
      context: context,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(5.0),
        child: AlertDialog(
        title: Text("Update your daily macros"),
        contentPadding: const EdgeInsets.all(16.0),
        content:  
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
             Flexible(
              child:  TextField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Protein',
                  labelStyle: TextStyle(
                    fontSize: 18.0,
                    color: GSColors.darkBlue,
                  ),
                  hintText: await currentWeight,
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    color: GSColors.darkBlue,
                  ),
                  contentPadding: EdgeInsets.all(10.0)

                ),
              ),
            ),
            
            SizedBox(width: 5.0,),

            Flexible(
              child:  TextField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Carbs',
                  labelStyle: TextStyle(
                    fontSize: 18.0,
                    color: GSColors.darkBlue,
                  ),
                  hintText: await currentWeight,
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    color: GSColors.darkBlue,
                  ),
                    contentPadding: EdgeInsets.all(10.0)

                ),
              ),
            ),
    
            SizedBox(width: 5.0,),

            Flexible(
              child:  TextField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Fats',
                  labelStyle: TextStyle(
                    fontSize: 18.0,
                    color: GSColors.darkBlue,
                  ),
                  hintText: await currentWeight,
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    color: GSColors.darkBlue,
                  ),
                    contentPadding: EdgeInsets.all(10.0)

                ),
              ),
            ),

          ],
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
            onPressed: (){
            //**********Save to firebase!*************** */
            Navigator.pop(context);
            }
          )
        ],
      )),
      // barrierDismissible: true,
      // builder: (BuildContext context){
      //   return AlertDialog(
      //     title: Text('Change your info'),
      //     content: ListView(
      //       children: <Widget>[
      //         // lifting type
      //         TextField(
      //           decoration: InputDecoration.collapsed(
      //             //hintText: 'Current weight: ${_futureUser}'
      //             // hintText: startingWeight,
      //           ),
      //           controller: _liftingTypeController,
      //           onChanged: (text) => print(text),
      //         ), 
      //         // photo url
      //           // ImagePicker()
      //         // bio
      //         // weight
      //         // macros
      //       ],
      //     ),
      //     // content: SingleChildScrollView(
      //     //   child: ListView(
      //     //     children: <Widget>[
      //     //       // Text('Test1'),
      //     //     ],
      //     //   ),
      //     // ),
      //   // actions: <Widget>[
      //   //   FlatButton(
      //   //     child: FutureBuilder(
      //   //       future: _futureUser,
      //   //       builder: (context, snapshot) =>
      //   //         Text(
      //   //           snapshot.hasData ? snapshot.data['currentWeight'].toString() : '0',
      //   //           style: TextStyle(
      //   //             color: Colors.white,
      //   //             fontSize: 14,
      //   //           )
      //   //         ),
      //   //     ),
      //   //     onPressed: () {
      //   //         return showDialog(
      //   //           context: context,
      //   //           builder: (context) {
      //   //             return AlertDialog(
      //   //               content: Text(myController.text),
      //   //             );
      //   //           }
      //   //         );
      //   //       //thisText = input.getText().toString(),
      //   //     }
      //   //     )
      //   // ]
      //   );
      // }
    );
  }
}

void  _updateWeightInfo(BuildContext context) async{
      String currentWeight, startingWeight;
      DocumentReference ref;
     // currentWeight = Firestore.instance.collection('users').document('${DatabaseHelper.currentUserID}').;

    showDialog<String>(
      context: context,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: AlertDialog(
        title: Text("Change your current weight"),
        contentPadding: const EdgeInsets.all(16.0),
        content:  
          Row(
          children: <Widget>[
             Expanded(
              child:  TextField(
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
          ],
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
            //**********Save to firebase!*************** */

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
      )),
      // barrierDismissible: true,
      // builder: (BuildContext context){
      //   return AlertDialog(
      //     title: Text('Change your info'),
      //     content: ListView(
      //       children: <Widget>[
      //         // lifting type
      //         TextField(
      //           decoration: InputDecoration.collapsed(
      //             //hintText: 'Current weight: ${_futureUser}'
      //             // hintText: startingWeight,
      //           ),
      //           controller: _liftingTypeController,
      //           onChanged: (text) => print(text),
      //         ), 
      //         // photo url
      //           // ImagePicker()
      //         // bio
      //         // weight
      //         // macros
      //       ],
      //     ),
      //     // content: SingleChildScrollView(
      //     //   child: ListView(
      //     //     children: <Widget>[
      //     //       // Text('Test1'),
      //     //     ],
      //     //   ),
      //     // ),
      //   // actions: <Widget>[
      //   //   FlatButton(
      //   //     child: FutureBuilder(
      //   //       future: _futureUser,
      //   //       builder: (context, snapshot) =>
      //   //         Text(
      //   //           snapshot.hasData ? snapshot.data['currentWeight'].toString() : '0',
      //   //           style: TextStyle(
      //   //             color: Colors.white,
      //   //             fontSize: 14,
      //   //           )
      //   //         ),
      //   //     ),
      //   //     onPressed: () {
      //   //         return showDialog(
      //   //           context: context,
      //   //           builder: (context) {
      //   //             return AlertDialog(
      //   //               content: Text(myController.text),
      //   //             );
      //   //           }
      //   //         );
      //   //       //thisText = input.getText().toString(),
      //   //     }
      //   //     )
      //   // ]
      //   );
      // }
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
