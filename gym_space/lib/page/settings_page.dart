import 'dart:async';

import 'package:GymSpace/widgets/image_widget.dart';
import 'package:GymSpace/widgets/media_tab.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:GymSpace/global.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/page_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsPage extends StatefulWidget {
  
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<DocumentSnapshot> _futureUser =  DatabaseHelper.getUserSnapshot(DatabaseHelper.currentUserID);
  String _newInfo = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: AppDrawer(startPage: 8,),
      backgroundColor: GSColors.darkBlue,
      body: _buildBody(),
    );
  }

  void _updateInfo(BuildContext context, String infoKey, String update) async {
    showDialog(
      context: context,
      builder: (context) {

        return SafeArea(
          child: SimpleDialog(
            title: Text("Update " + update, textAlign: TextAlign.center),
            titlePadding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  color: GSColors.darkBlue,
                ),
              ),
              SafeArea(
                child: Container(
                  margin: EdgeInsets.only(left: 16, right: 40),
                  width: double.maxFinite,
                  child: _buildForm(infoKey, update),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SimpleDialogOption(
                    child: MaterialButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        print("Resetting form");
                        _formKey.currentState.reset();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SimpleDialogOption(
                    child: MaterialButton(
                      child: Text("Update"),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _formKey.currentState.save();
                            print("Updating " + update.toLowerCase() + "...");
                            _updateInfoToDB(update);
                            Navigator.pop(context);});
                        }
                      },
                    ),
                  )
                ],
              )
            ],
          )
        );
      }
    );
  }

  Future _updateInfoToDB(String updateKey) async {
    String lowercaseKey = updateKey.toLowerCase();
    // UPDATING NAME
    if(lowercaseKey == 'name') {  
      List<String> nameInfo = _newInfo.split(" ");

      Firestore.instance.collection('users').document(DatabaseHelper.currentUserID)
        .updateData({'firstName' : nameInfo[0]});
      Firestore.instance.collection('users').document(DatabaseHelper.currentUserID)
        .updateData({'lastName' : nameInfo[1]});
    } else 
    // UPDATING AGE SCENARIO
    if (lowercaseKey == 'age') {
      int newAge = int.parse(_newInfo);
      Firestore.instance.collection('users').document(DatabaseHelper.currentUserID)
        .updateData({lowercaseKey : newAge});
    } else {  
      Firestore.instance.collection('users').document(DatabaseHelper.currentUserID)
        .updateData({lowercaseKey : _newInfo});
    }
  }

  Widget _buildForm(String infoKey, String update) {
    return Form(
      key: _formKey,
      child: TextFormField( // name
            
            decoration: InputDecoration(
              icon: Icon(
                FontAwesomeIcons.angleRight,
                color: GSColors.darkBlue,
                size: 30,
              ),
              hintText: infoKey,
              labelText: update,
            ),
            onSaved: (name) => _newInfo = name,
            validator: (value) => value.isEmpty ? "This field cannot be empty" : null,
          ),
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
      padding: EdgeInsets.only(bottom: 10),
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
          StreamBuilder(
            stream: _futureUser.asStream(),
            builder: (context, snapshot){
              String name = snapshot.hasData ? snapshot.data['firstName'] + ' ' + snapshot.data['lastName'] : "";
              String email = snapshot.hasData ? snapshot.data['email'] : "";
              String bio = snapshot.hasData ? snapshot.data['bio'] : "";
              String profileURL = snapshot.hasData ? snapshot.data['photoURL'] : "";
              int age = snapshot.hasData ? snapshot.data['age'] : 0;
              return Container(
                child: Column(
                children: <Widget>[   

                  // SETTINGS TAB
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 100),
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

                  // PROFILE PIC
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    decoration: ShapeDecoration(
                      shadows: [BoxShadow(color: Colors.black, blurRadius: 2, spreadRadius: 2)],
                      shape: CircleBorder(
                        side: BorderSide(color: Colors.white, width: .5)
                      )
                    ),
                    child: FlatButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute<void> (
                        builder: (BuildContext context) {
                          return ImageWidget(profileURL, context, false);
                        })
                      ),
                      child: CircleAvatar(
                        backgroundImage: profileURL != "" ? CachedNetworkImageProvider(profileURL, errorListener: () => print('Failed to download')) 
                            : AssetImage(Defaults.userPhoto),
                        backgroundColor: Colors.white,
                        radius: 40,
                      ),
                    ),
                  ),

                  // PROFILE PIC EDIT
                  Container(
                    child: FlatButton(
                      onPressed: () => MediaTab(context).getProfileImage(),
                      child: Text(
                        "Change Profile Photo",
                        style: TextStyle(
                          color: GSColors.lightBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        )
                      ),
                    ),
                  ),

                  // Container(
                  //   child: Divider(
                  //     color: GSColors.darkBlue
                  //   ),
                  // ),

                  // NAME EDIT
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Text(
                            'Name',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            )
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                          child: Text(
                            name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            )
                          )
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.only(left: 40, right: 20),
                          child: IconButton(
                            alignment: Alignment.centerRight,
                            icon: Icon(Icons.edit),
                            onPressed: () => _updateInfo(context, name, "Name"),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Container(
                    margin: EdgeInsets.only(right: 30),
                    child: Divider(
                      indent: 95,
                      color: GSColors.darkBlue
                    ),
                  ),

                  // EMAIL EDIT
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Text(
                            'Email',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            )
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                          child: Text(
                            email,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            )
                          )
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                        margin: EdgeInsets.only(left: 40, right: 20),
                          child: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _updateInfo(context, email, "Email"),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Container(
                    margin: EdgeInsets.only(right: 30),
                    child: Divider(
                      indent: 95,
                      color: GSColors.darkBlue
                    ),
                  ),

                  // AGE EDIT
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Text(
                            'Age',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            )
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                          child: Text(
                            age.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            )
                          )
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                        margin: EdgeInsets.only(left: 40, right: 20),
                          child: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _updateInfo(context, age.toString(), "Age"),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Container(
                    margin: EdgeInsets.only(right: 30),
                    child: Divider(
                      indent: 95,
                      color: GSColors.darkBlue
                    ),
                  ),

                  // BIO EDIT
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Text(
                            'Bio',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            )
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                          child: Text(
                            bio,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            )
                          )
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                        margin: EdgeInsets.only(left: 40, right: 20),
                          child: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _updateInfo(context, bio, "Bio"),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Container(
                    margin: EdgeInsets.only(right: 30),
                    child: Divider(
                      indent: 95,
                      color: GSColors.darkBlue
                    ),
                  ),

                ],
                ),
              );
            },
          ),
        ],
      )
    );
  }
  
  // Widget _buildGeneral(){
  //   return Container(
  //     height: 250,
  //     margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
  //     decoration: ShapeDecoration(
  //       color: Colors.white,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20)
  //       )
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         FutureBuilder(
  //           future: _futureUser,
  //           builder: (context, snapshot){
  //             bool isPrivate = snapshot.hasData ? snapshot.data['private'] : true;
  //             bool isLocation = snapshot.hasData ? snapshot.data['location'] : true;
  //             bool isNotification = snapshot.hasData ? snapshot.data['notification'] : true;
  //             bool isClearSearch = true;
  //             return Container(
  //               child: Column(
  //               children: <Widget>[   
  //                 Container(
  //                   alignment: Alignment.center,
  //                   margin: EdgeInsets.symmetric(vertical: 10, horizontal: 125),
  //                   child: Text(
  //                     'General',
  //                     style:TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 20,
  //                       fontFamily: "WorkSansMedium"
  //                     ),
  //                   ),
  //                   decoration: ShapeDecoration(
  //                     color: GSColors.darkBlue,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(60)
  //                     ) 
  //                   ),
  //                 ),  
  //                 Container(
  //                   margin: EdgeInsets.only(left: 15),
  //                   child: Row(
  //                     children: <Widget> [
  //                       Text(
  //                         'Private Account',
  //                         style: TextStyle(
  //                           color: Colors.black,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 16
  //                         )
  //                       ),
  //                       Padding(
  //                         padding: EdgeInsets.only(left: 130),
  //                         child: Switch(
  //                           value: isPrivate,
  //                           onChanged: (value){
  //                             setState(() {
  //                              isPrivate = value;
  //                              String userID = DatabaseHelper.currentUserID;
  //                              if(value == false){
  //                                Firestore.instance.collection('users').document(userID).updateData({'private': false});
  //                              }
  //                              else{
  //                                Firestore.instance.collection('users').document(userID).updateData({'private': true});
  //                              }
  //                             });
  //                           },
  //                           activeColor: GSColors.darkBlue,
  //                         ),
  //                       )
  //                     ] 
  //                   ),
  //                 ),
  //                 Container(
  //                   margin: EdgeInsets.only(left: 15),
  //                   child: Row(
  //                     children: <Widget> [
  //                       Text(
  //                         'Allow Location access',
  //                         style: TextStyle(
  //                           color: Colors.black,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 16
  //                         )
  //                       ),
  //                       Padding(
  //                         padding: EdgeInsets.only(left: 83),
  //                         child: Switch(
  //                           value: isLocation,
  //                           onChanged: (value){
  //                             setState(() {
  //                              isLocation = value; 
  //                              String userID = DatabaseHelper.currentUserID;
  //                              if(value == false){
  //                                Firestore.instance.collection('users').document(userID).updateData({'location': false});
  //                              }
  //                              else{
  //                                Firestore.instance.collection('users').document(userID).updateData({'location': true});
  //                              }
  //                             });
  //                           },
  //                           activeColor: GSColors.darkBlue,
  //                         ),
  //                       )
  //                     ] 
  //                   ),
  //                 ),
  //                 Container(
  //                   margin: EdgeInsets.only(left: 15),
  //                   child: Row(
  //                     children: <Widget> [
  //                       Text(
  //                         'Notifications',
  //                         style: TextStyle(
  //                           color: Colors.black,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 16
  //                         )
  //                       ),
  //                       Padding(
  //                         padding: EdgeInsets.only(left: 150),
  //                         child: Switch.adaptive(
  //                           value: isNotification,
  //                           onChanged: (value){
  //                             setState(() {
  //                              isNotification = value; 
  //                             });
  //                             String userID = DatabaseHelper.currentUserID;
  //                              if(value == false){
  //                                Firestore.instance.collection('users').document(userID).updateData({'notification': false});
  //                                print("Notification: $value");
  //                              }
  //                              else if(value == true){
  //                                Firestore.instance.collection('users').document(userID).updateData({'notification': true});
  //                                print("Notification: $value");
  //                              }
  //                           },
  //                           activeColor: GSColors.darkBlue,
  //                         ),
  //                       )
  //                     ] 
  //                   ),
  //                 ),
  //                 Container(
  //                   margin: EdgeInsets.only(left: 15),
  //                   child: Row(
  //                     children: <Widget> [
  //                       Text(
  //                         'Clear Search History',
  //                         style: TextStyle(
  //                           color: Colors.black,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 16
  //                         )
  //                       ),
  //                       Padding(
  //                         padding: EdgeInsets.only(left: 95),
  //                         child: Switch(
  //                           value: isClearSearch,
  //                           onChanged: (value){
  //                             setState(() {
  //                              isClearSearch = value; 
  //                             });
  //                           },
  //                           activeColor: GSColors.darkBlue,
  //                         ),
  //                       )
  //                     ] 
  //                   ),
  //                 ),
  //               ],
  //               )
  //             );
  //           },
  //         ),
  //       ],
  //     )
  //   );
  // }
}