import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:GymSpace/page/message_thread_page.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/page_header.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:GymSpace/global.dart';

String defaultAvatar = 'https://firebasestorage.googleapis.com/v0/b/gymspace.appspot.com/o/default_icon.png?alt=media&token=af0d9f4b-cec3-4f05-87a5-5dd1bfc0eb5a';

class ChatPage extends StatelessWidget { // Change to ChatPage() - Must be StatelessWidget that returns a Scaffold - move to page folder
  

  @override
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
                  imageUrl: document['photoUrl'] ?? defaultAvatar,
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
                          '${document['firstName']} ${document['lastName']}',   
                          style: TextStyle(color: GSColors.cloud),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: new EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      new Container(
                        child: Text(
                          ' ${document['aboutMe'] ?? 'Not available'}',
                          style: TextStyle(color: GSColors.cloud),
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
                      peerAvatar: document['photoUrl'] ?? defaultAvatar,
                      peerFirstName: document['firstName'],
                      peerLastName: document['lastName'],
                    )));
          },
          color: GSColors.darkBlue,
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          // shape: OutlineInputBorder(
          //   borderRadius:  BorderRadius.circular(50),
          // )
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     
      drawer: AppDrawer(startPage: 6,),
      appBar: _buildAppBar(),
      // floatingActionButton: new FloatingActionButton(
      //   //IconButton(
      //   elevation: 1.0,
      //   child: new Icon(Icons.adb),
      //   onPressed: ,

      //   ),
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
          ],
        ),
            onWillPop: null,
      ),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: PageHeader(
        title: "Messages", 
        backgroundColor: GSColors.darkBlue,
        showDrawer: true,
        titleColor: Colors.white,
      ),
    );
  }
}