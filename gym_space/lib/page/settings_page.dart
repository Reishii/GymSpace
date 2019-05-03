import 'package:flutter/material.dart';
import 'package:GymSpace/global.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/page_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPage extends StatefulWidget {
  
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  
  Future<DocumentSnapshot> _futureUser =  DatabaseHelper.getUserSnapshot( DatabaseHelper.currentUserID);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: AppDrawer(startPage: 8,),
      backgroundColor: GSColors.darkBlue,
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: PageHeader(
        title: "Settings",
        backgroundColor: Colors.white,
        showDrawer: true,
        titleColor: GSColors.darkBlue,
      ),
    );
  }
  Widget _buildBody() {
    return Container(
      child: ListView(
        children: <Widget>[
          _buildAccount(),
          // _buildGeneral()
        ],
      )
    );
  }
  Widget _buildAccount(){
    return Container(
      height: 200,
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FutureBuilder(
            future: _futureUser,
            builder: (context, snapshot){
              String name = snapshot.hasData ? snapshot.data['firstName'] + ' ' + snapshot.data['lastName'] : "";
              String email = snapshot.hasData ? snapshot.data['email'] : "";
              String age = snapshot.hasData ? snapshot.data['age'].toString() : "";
              return Container(
                child: Column(
                children: <Widget>[   
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 105),
                    child: Text(
                      'Profile Settings',
                      style:TextStyle(
                        color: Colors.white,
                        fontSize: 20
                      ),
                    ),
                    decoration: ShapeDecoration(
                      color: GSColors.darkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60)
                      ) 
                    ),
                  ),  
                  Container(
                    margin: EdgeInsets.only(top: 2, right: 260),
                    child: Text(
                      'Name',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      )
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 2, right: 200),
                    child: Text(
                      name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                      )
                    )
                  ),
                   Container(
                    margin: EdgeInsets.only(top: 10, right: 260),
                    child: Text(
                      'Email',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      )
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 2, right: 150),
                    child: Text(
                      email,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                      )
                    )
                  ),
                    Container(
                    margin: EdgeInsets.only(top: 5, right: 270),
                    child: Text(
                      'Age',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      )
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 2, right: 250),
                    child: Text(
                      age,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                      )
                    )
                  ),
                ],
                )
              );
            },
          ),
        ],
      )
    );
  }
  Widget _buildGeneral(){
    return Container(
      height: 250,
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FutureBuilder(
            future: _futureUser,
            builder: (context, snapshot){
              bool isPrivate = snapshot.hasData ? snapshot.data['private'] : true;
              bool isLocation = snapshot.hasData ? snapshot.data['location'] : true;
              bool isNotification = snapshot.hasData ? snapshot.data['notification'] : true;
              bool isClearSearch = true;
              return Container(
                child: Column(
                children: <Widget>[   
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 125),
                    child: Text(
                      'General',
                      style:TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "WorkSansMedium"
                      ),
                    ),
                    decoration: ShapeDecoration(
                      color: GSColors.darkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60)
                      ) 
                    ),
                  ),  
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Row(
                      children: <Widget> [
                        Text(
                          'Private Account',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 130),
                          child: Switch(
                            value: isPrivate,
                            onChanged: (value){
                              setState(() {
                               isPrivate = value;
                               String userID = DatabaseHelper.currentUserID;
                               if(value == false){
                                 Firestore.instance.collection('users').document(userID).updateData({'private': false});
                               }
                               else{
                                 Firestore.instance.collection('users').document(userID).updateData({'private': true});
                               }
                              });
                            },
                            activeColor: GSColors.darkBlue,
                          ),
                        )
                      ] 
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Row(
                      children: <Widget> [
                        Text(
                          'Allow Location access',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 83),
                          child: Switch(
                            value: isLocation,
                            onChanged: (value){
                              setState(() {
                               isLocation = value; 
                               String userID = DatabaseHelper.currentUserID;
                               if(value == false){
                                 Firestore.instance.collection('users').document(userID).updateData({'location': false});
                               }
                               else{
                                 Firestore.instance.collection('users').document(userID).updateData({'location': true});
                               }
                              });
                            },
                            activeColor: GSColors.darkBlue,
                          ),
                        )
                      ] 
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Row(
                      children: <Widget> [
                        Text(
                          'Notifications',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 150),
                          child: Switch.adaptive(
                            value: isNotification,
                            onChanged: (value){
                              setState(() {
                               isNotification = value; 
                              });
                              String userID = DatabaseHelper.currentUserID;
                               if(value == false){
                                 Firestore.instance.collection('users').document(userID).updateData({'notification': false});
                                 print("Notification: $value");
                               }
                               else if(value == true){
                                 Firestore.instance.collection('users').document(userID).updateData({'notification': true});
                                 print("Notification: $value");
                               }
                            },
                            activeColor: GSColors.darkBlue,
                          ),
                        )
                      ] 
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Row(
                      children: <Widget> [
                        Text(
                          'Clear Search History',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 95),
                          child: Switch(
                            value: isClearSearch,
                            onChanged: (value){
                              setState(() {
                               isClearSearch = value; 
                              });
                            },
                            activeColor: GSColors.darkBlue,
                          ),
                        )
                      ] 
                    ),
                  ),
                ],
                )
              );
            },
          ),
        ],
      )
    );
  }
}