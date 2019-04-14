import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chatscreen.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/page_header.dart';
import 'package:GymSpace/widgets/app_drawer.dart';

// import 'package:GymSpace/settingsMsg.dart';

class ChatPage extends StatelessWidget { // Change to ChatPage() - Must be StatelessWidget that returns a Scaffold - move to page folder
  // final String currentUserId;
  // MainScreen({Key key, this.currentUserId}) : super(key: key)

  @override
  //Widget build (BuildContext context) {
    
    //bool isLoading = false;
    //List<Choice> choices = const <Choice>[
     // const Choice(title: 'Settings', icon: Icons.settings),
      //  ];

    Widget buildItem(BuildContext context, DocumentSnapshot document) {

    if (document['userID'] == FirebaseAuth.instance.currentUser()){
      return Container();
    } else {
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
                          '${document['first name']} ${document['last name']}',   
                          style: TextStyle(color: GSColors.darkBlue),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: new EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      new Container(
                        child: Text(
                          ' ${document['aboutMe'] ?? 'Not available'}',
                          style: TextStyle(color: GSColors.darkBlue),
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
                    builder: (context) => new MessageThreadPage(
                      peerId: document.documentID,
                      peerAvatar: document['photoUrl'],
                      peerFirstName: document['first name'],
                      peerLastName: document['last name'],
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
    
  // Future<bool> onBackPress() {
  //     Navigator.pop(context);
  //   return Future.value(false);
  // }

   return Scaffold(
      drawer: AppDrawer(startPage: 4,),
       appBar: AppBar(
         title: Text(
           "Messages", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
            //onWillPop: onBackPress,
            onWillPop: null,
      ),
    );
  }
  //}
  // State createState() => new MainScreenState(currentUserId: currentUserId);
  // MsgMainState createState() => new MsgMainState();
}