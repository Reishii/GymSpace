import 'package:flutter/material.dart';
import 'package:GymSpace/global.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/buddy_conditional.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

Future<DocumentSnapshot> ds;

class BuddyWidget extends StatelessWidget {
  final Widget child;
  List<String> buddies = [];
  Future<DocumentSnapshot> _futureUser = DatabaseHelper.getUserSnapshot(DatabaseHelper.currentUserID);

  BuddyWidget(this.buddies, {Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _displayBuddyPreview(buddies);
    // return FutureBuilder(
    //   future: ds,
    //   builder: (context, snapshot) {
    //     if(snapshot.hasData != null) 
    //     {
    //       print("You have buddies");
    //       //buddies.add(snapshot.data['buddies']);
    //     }
    //   }
    // );
  }

  Widget _buildBuddyCard(String name, String quote, Image buddyAvatar) {

  }

  Widget _displayBuddyPreview(List<String> buddies) {
    return FutureBuilder(
      future: _futureUser,
      builder: (context, snapshot) {
        return Container(
        height: 90,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: ShapeDecoration(
          color: GSColors.darkCloud,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          )
        ),
          child: Center(
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage("https://media.npr.org/assets/img/2019/01/10/dlevy.hs2_wide-f6f2f772b1588e73ecdece6b0fb3dff127aa8e3a-s800-c85.jpg"),
              ),
          
              title: Text(
                snapshot.hasData ? snapshot.data['firstName'] + " " + snapshot.data['lastName']: "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: GSColors.darkBlue,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  ),
                ),

              subtitle: Text(
                "hi",
                //snapshot.hasData ? snapshot.data['buddies'].data['bio'] : "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 15,
                  ),
                ),

              onTap: () {
                // Navigator.push(context, MaterialPageRoute<void>(
                //   builder: (context) {
                //     //_buildBuddyCard(name, quote, BuddyAvatar);
                //   }
                // ));
              }, // onTap
            ),
          ),
      );
      }
    );
  }

  Widget _displayBuddySepPreview(List<String> buddies) {
    return Container(
      height: 100,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: ShapeDecoration(
        color: GSColors.darkCloud,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        )
      ),
      
      child: Center(
        child: ListTile(
          //contentPadding: EdgeInsets.only(right: 15),
          title: const Text(
            'Patrick Brewer',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: GSColors.darkBlue,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          subtitle: const Text(
            "You're simply the best.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 15,
            ),
          ),

          trailing: new Container(
            padding: EdgeInsets.only(right: 5.0),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage("https://www.cbc.ca/schittscreek/content/images/people/noah-s5.jpg"),
            ),
          ),

          onTap: () {
            // Navigator.push(context, MaterialPageRoute<void>(
            //   builder: (context) {
            //     //_buildBuddyCard(name, quote, BuddyAvatar);
            //   }
            // ));
          }, // onTap
        ),
      )
    );
  }
}

