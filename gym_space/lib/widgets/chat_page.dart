import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chatscreen.dart';
import 'package:GymSpace/misc/colors.dart';
// import 'package:GymSpace/settingsMsg.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:GymSpace/login.dart';
//import 'package:GymSpace/colors.dart';

// void main() => runApp(new MyApp());

// PS 3/7
// Auth firebaseAuth;
// String tmpID = "7j05qHZ9RXVIpYNphE7c";
const String currentUserId = "7j05qHZ9RXVIpYNphE7c";

class ChatPage extends StatelessWidget { // Change to ChatPage() - Must be StatelessWidget that returns a Scaffold - move to page folder
  // final String currentUserId;
  // MainScreen({Key key, this.currentUserId}) : super(key: key)

  @override
  //Widget build (BuildContext context) {
    
    //bool isLoading = false;
    //List<Choice> choices = const <Choice>[
     // const Choice(title: 'Settings', icon: Icons.settings),
      //  ];

    //debugPrint("********************************** moo ***************************************");

    Future<FirebaseUser> firebaseUser =  FirebaseAuth.instance.currentUser();
    Widget buildItem(BuildContext context, DocumentSnapshot document) {

    if (document['userID'] == FirebaseAuth.instance.currentUser()){
      debugPrint("******************** moo if *********************");
      return Container();
    } else {
      debugPrint("******************** moo *********************");
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                child: CachedNetworkImage(
                  placeholder: Container(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.0,
                      valueColor: AlwaysStoppedAnimation<Color>(GSColors.darkBlue),
                    ),
                    width: 50.0,
                    height: 50.0,
                    padding: EdgeInsets.all(15.0),
                  ),
                  imageUrl: document['photoUrl'],
                  //imageUrl: 'gs://gymspace.appspot.com/jGfeAI2v.jpg',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              new Flexible(
                child: Container(
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        child: Text(
                          'Nickname: ${document['last name']}',
                          style: TextStyle(color: GSColors.darkCloud),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: new EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      new Container(
                        child: Text(
                          'About me: ${document['aboutMe'] ?? 'Not available'}',
                          style: TextStyle(color: GSColors.darkCloud),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: new EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new MessageThread(
                      peerId: document.documentID,
                      peerAvatar: document['photoUrl'],
                      //peerAvatar: 'gs://gymspace.appspot.com/jGfeAI2v.jpg',
                    )));
          },
          color: GSColors.cloud,
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

   return Scaffold(
      appBar: AppBar(
        title: Text(
           //"chat",
          null,
          //style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            // List
            Container(
              child: StreamBuilder(
                stream: Firestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {  
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(GSColors.darkBlue),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) =>
                          buildItem(context, snapshot.data.documents[index]),
                      itemCount: snapshot.data.documents.length,
                    );
                  }
                },
              ),
            ),

            // Loading
            // Positioned(
            //   child: isLoading
            //       ? Container(
            //     child: Center(
            //       child: CircularProgressIndicator(
            //           valueColor:
            //           AlwaysStoppedAnimation<Color>(GSColors.darkBlue)),
            //     ),
            //     color: Colors.white.withOpacity(0.8),
            //   )
            //       : Container(),
            // )
          ],
        ),
          //  onWillPop: onBackPress,
          onWillPop:null,
      ),
    );
  }
  //}
  // State createState() => new MainScreenState(currentUserId: currentUserId);
  // MsgMainState createState() => new MsgMainState();
}