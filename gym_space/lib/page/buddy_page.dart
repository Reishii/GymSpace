import 'dart:async';

import 'package:GymSpace/logic/user.dart';
import 'package:GymSpace/page/profile_page.dart';
import 'package:GymSpace/page/search_page.dart';
import 'package:GymSpace/widgets/page_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:flutter/widgets.dart';
import 'package:GymSpace/global.dart';

class BuddyPage extends StatefulWidget {
  final Widget child;

  BuddyPage({Key key, this.child}) : super(key: key);
  _BuddyPageState createState() => _BuddyPageState();
}

class _BuddyPageState extends State<BuddyPage> {
  List<String> buddies =  [];
  User user;
  
  //Algolia get algolia => DatabaseConnections.algolia;

  Future<void> searchPressed() async {
    User _currentUser;
    await DatabaseHelper.getUserSnapshot(DatabaseHelper.currentUserID).then(
      (ds) => _currentUser = User.jsonToUser(ds.data)
    );

    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return SearchPage(searchType: SearchType.user, currentUser: _currentUser,);
      } 
    ));
  }

  void _deletePressed(String buddyID) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        title: Text('Remove Friend?'),
        contentPadding: EdgeInsets.fromLTRB(24, 24, 24, 0),
        content: Container(
          child: Text(
            'Are you sure you want unfriend this person?',
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
            textColor: GSColors.green,
          ),
          FlatButton(
            onPressed: () => _deleteBuddy(buddyID),
            child: Text('Yes'),
            textColor: GSColors.green,
          ),
        ],
      )
    );
  }

  Future<void> _deleteBuddy(String buddyID) async {
    await Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).updateData(
      {'buddies': FieldValue.arrayRemove([buddyID])}
    ).then((_) => print('Successfully deleted buddy from current user'));

    await Firestore.instance.collection('users').document(buddyID).updateData(
      {'buddies': FieldValue.arrayRemove([DatabaseHelper.currentUserID])}
    ).then((_) {
      print('Successfully deleted current user from buddy.');
      setState(() {
        Navigator.pop(context);
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(startPage: 5,),
      backgroundColor: GSColors.darkBlue,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: PageHeader(
        title: 'Buddies', 
        backgroundColor: Colors.white,
        showDrawer: true,
        titleColor: GSColors.darkBlue,
        showSearch: true,
        searchFunction: searchPressed,
      )
    );  
  }

  Widget _buildBody() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(20),
        child: _buildBuddyList(),
      )
    );
  }

  Widget _buildBuddyList() {
    return StreamBuilder(
      stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
      builder: (context, snapshot) {
        if(!snapshot.hasData) 
          return Container();
               
        buddies = snapshot.data.data['buddies'].cast<String>();
        return ListView.builder(
          itemCount: buddies.length,
          itemBuilder: (BuildContext context, int i) {            
            return StreamBuilder(
              stream: DatabaseHelper.getUserStreamSnapshot(buddies[i]),
              builder: (context, snapshot) {
                if(!snapshot.hasData)
                  return Container();

                user = User.jsonToUser(snapshot.data.data);
                user.documentID = snapshot.data.documentID;
                return _buildBuddy(user);
              },
            );
          }, 
        );
      },
    );
  }

  Widget _buildBuddy(User user) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20),
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: ShapeDecoration(
                color: GSColors.darkBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          '${user.firstName} ${user.lastName}',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          '${user.liftingType}',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child:IconButton(
                      icon: Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                      onPressed: () => _deletePressed(user.documentID),
                    )
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 4),
              decoration: ShapeDecoration(
                shadows: [BoxShadow(blurRadius: 2, color: GSColors.darkBlue)],
                shape: CircleBorder(
                  side: BorderSide(color: Colors.white, width: .5)
                ),
              ),
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(user.photoURL.isEmpty ? Defaults.photoURL : user.photoURL, errorListener: () => print('Failed to download')),
                radius: 50,
              ),
            ),
          ]
        ),
        onTap: () => _buildBuddyProfile(user),
      ),
    );  
  }

  void _buildBuddyProfile(User user) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ProfilePage.fromUser(user)
    ));
  }
}