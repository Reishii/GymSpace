import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/page_header.dart';
import 'package:GymSpace/logic/notification.dart';
import 'package:GymSpace/notification_api.dart';
import 'package:GymSpace/logic/user.dart';
import 'package:GymSpace/global.dart';
import 'dart:async';

import 'package:GymSpace/page/buddy_page.dart';
import 'package:GymSpace/page/messages_page.dart';

class NotificationPage extends StatefulWidget {
 
  @override 
  _NotificationState createState() => _NotificationState();
  void sendNotifications(String title, String body, String fcmToken, String route, String sender) async {
    final response = await Messaging.sendTo(
      title: title,
      body: body,
      fcmToken: fcmToken,
      route: route,
      sender: sender,
    );
    print('title $title');
    print('body $body');
    print('fcmToken: $fcmToken');
    print('route: $route');
    print('sender: $sender');
    if(response.statusCode != 200){}
  }
   void sendTokenToServer(String fcmToken){
    print('Token: $fcmToken');
    // Update user's fcmToken just in case
    String userID = DatabaseHelper.currentUserID;
    Firestore.instance.collection('users').document(userID).updateData({'fcmToken': fcmToken});
  } 
}

class _NotificationState extends State<NotificationPage> {
  final FirebaseMessaging _messaging = FirebaseMessaging();
  final String fcmToken = "";
  final String route = "";
   
  void handleRouting(dynamic notification){
    switch (notification['title']){
      case 'buddy':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => BuddyPage())
        );
        break;
      case 'message':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => MessagesPage())
        );
    }
  }
  void sendTokenToServer(String fcmToken){
    print('Token: $fcmToken');
    // Update user's fcmToken just in case
    String userID = DatabaseHelper.currentUserID;
    Firestore.instance.collection('users').document(userID).updateData({'fcmToken': fcmToken});
  } 
  Future<void> _sendNotificationToDB(String title, String body, String route, String fcmToken, String sender) async{
    Map<String, String> notification =
     {
      'title': title,
      'body': body,
      'route': route,
      'fcmToken': fcmToken,
      'sender': sender,
    };
    
    Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).updateData(
      {'notifications': FieldValue.arrayUnion([notification])}
    );
  }
  Future<void> _deleteNotificationOnDB(String fcm, String route) async  {
    // Get specific notification from DB
    DocumentSnapshot itemCount = await Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).get();
    User userInfo = User.jsonToUser(itemCount.data);
    Map<dynamic, dynamic> notification;
    List<Map<dynamic,dynamic>> jsonData = userInfo.notifications;
    for(final name in jsonData){
      if(name.containsValue(fcm))
        if(name.containsValue(route))
          notification = name;
    }
    print(fcm);
    // Delete specific notification from DB
    Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).updateData(
      {'notifications': FieldValue.arrayRemove([notification])}
    );
    print("Deleted Object");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: AppDrawer(startPage: 6),
      backgroundColor: GSColors.darkBlue,
      body: _buildBody(context),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: PageHeader(
        title: "Notifications",
        backgroundColor: Colors.white,
        showDrawer: true,
        titleColor: GSColors.darkBlue,
      ),
    );
  } 
  Widget _buildBody(BuildContext context){
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data['notifications'].cast<Map<dynamic,dynamic>>());
      }
    );
  }
  Widget _buildList(BuildContext context, List<Map<dynamic, dynamic>> snapshot){
    return ListView(
      padding: const EdgeInsets.only(top: 20),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }
  Widget _buildListItem(BuildContext context, Map<dynamic, dynamic> data){
    final notify = Notifications.fromJSON(data);
    return Padding(
      key: ValueKey(notify.title),
      padding: const EdgeInsets.symmetric( horizontal: 10, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(notify.title),
          subtitle: Text(notify.body),
          onTap: (){
            _deleteNotificationOnDB(notify.receiver, notify.route);
          } 
        )
      ), 
    );
  }
  @override
  void initState() {
    _messaging.onTokenRefresh.listen(sendTokenToServer);
    _messaging.getToken();
    _messaging.subscribeToTopic('all');
    super.initState();
    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        final data = message ['data'];
        _sendNotificationToDB(notification['title'], notification['body'], data['route'],data['fcmToken'],data['sender']);
      },
      onLaunch:  (Map<String, dynamic> message) async {
        print("onLaunch: ${message.toString()}");
         final notification = message['data'];
        //handleRouting(notification);
        _sendNotificationToDB(notification['title'], notification['body'], notification['route'], notification['fcmToken'],notification['sender']);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
         final notification = message['data'];
        print('this is notification $notification');
        //handleRouting(notification);
        _sendNotificationToDB(notification['title'], notification['body'], notification['route'], notification['fcmToken'],notification['sender']);
      }
    );
  }
}
