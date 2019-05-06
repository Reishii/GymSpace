import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:GymSpace/page/buddy_page.dart';
import 'package:GymSpace/page/profile_page.dart';
import 'package:GymSpace/page/messages_page.dart';
import 'package:flutter/widgets.dart';

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
    print('title: $title');
    print('body: $body');
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
  Future<DocumentSnapshot> _futureUser =  DatabaseHelper.getUserSnapshot( DatabaseHelper.currentUserID);
  final FirebaseMessaging _messaging = FirebaseMessaging();
  final localNotify = FlutterLocalNotificationsPlugin();


  Future<void> handleRouting(dynamic notify) async{
    DocumentSnapshot itemCount = await Firestore.instance.collection('users').document(notify.sender).get();
    User userInfo = User.jsonToUser(itemCount.data);
    print(notify.route);
    switch (notify.route){
      case 'buddy':
        Navigator.of(context).push(
          new MaterialPageRoute(builder: (BuildContext context) => ProfilePage.fromUser(userInfo))
        );
        break;
      case 'message':
        Navigator.of(context).push(
          new MaterialPageRoute(builder: (BuildContext context) => MessagesPage())
        );
        break;
      // case 'notifications':
      //    Navigator.of(context).push(
      //     new MaterialPageRoute(builder: (BuildContext context) => NotificationPage())
      //   );
      //   break;
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
  Future<void> _deleteNotificationOnDB(String sender, String route, String receiver) async  {
    // Get specific notification from DB
    DocumentSnapshot itemCount = await Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).get();
    User userInfo = User.jsonToUser(itemCount.data);
    Map<dynamic, dynamic> notification;
    List<Map<dynamic,dynamic>> jsonData = userInfo.notifications;
    // fully check to find the specific array in the Notifications
    for(final name in jsonData){
      if(name.containsValue(sender))  // narrow down the sender's value first
        if(name.containsValue(route)) // then narrow down to route's value
          if(name.containsValue(receiver))  // then last check the receiver's value 
             notification = name;
    }
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
      body: _buildBody(context)
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
    Future<DocumentSnapshot> _otherUser =  DatabaseHelper.getUserSnapshot(notify.sender);
    return Padding(
      key: ValueKey(notify.title),
      padding: const EdgeInsets.symmetric( horizontal: 20, vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          handleRouting(notify);
        },
        child: Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(3.0),
          ),
          child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             FutureBuilder(
                  future: _otherUser,
                  builder: (context, snapshot){
                    return CircleAvatar(radius: 25,
                      backgroundImage: snapshot.hasData ? CachedNetworkImageProvider(snapshot.data['photoURL']) : AssetImage(Defaults.userPhoto),
                    );
                  }
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FittedBox(
                     child: Text(notify.title, style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
                     ),
                     fit: BoxFit.scaleDown
                    ),
                    FittedBox(
                      child: Text(notify.body, style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0)),
                      fit: BoxFit.scaleDown
                    )
                  ],
                ),
              ),
              RawMaterialButton(
                onPressed: () => _deleteNotificationOnDB(notify.sender, notify.route, notify.receiver),
                child: new Icon(
                  Icons.delete,
                  color: GSColors.darkCloud,
                  size: 20.0,
                ),
                shape: new CircleBorder(),
                elevation: 2.0,
                fillColor: GSColors.darkBlue,
              )
            ],
          )
        ),
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
        showOngoingNotification(localNotify, id: 0, title: notification['title'], body: notification['body']);
      },
      onLaunch:  (Map<String, dynamic> message) async {
        print("onLaunch: ${message.toString()}");
         final notification = message['data'];
        _sendNotificationToDB(notification['title'], notification['body'], notification['route'], notification['fcmToken'],notification['sender']);
        //handleRouting('notification');
        //showOngoingNotification(localNotify, id: 0, title: notification['title'], body: notification['body']);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        final notification = message['data'];
        showOngoingNotification(localNotify, id: 0, title: notification['title'], body: notification['body']);
        //_sendNotificationToDB(notification['title'], notification['body'], notification['route'], notification['fcmToken'],notification['sender']);
      }
    );
    final settingsAndriod = AndroidInitializationSettings('@mipmap/ic_launcher');
    final settingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) =>
        onSelectNotification(payload));
    localNotify.initialize(InitializationSettings(settingsAndriod, settingsIOS),
      onSelectNotification: onSelectNotification);
  }

  // Local Notifications Plugin Functions
  Future onSelectNotification(String payload) async  {
    Navigator.pop(context);
    print("==============OnSelect WAS CALLED===========");
    await Navigator.push( context, new MaterialPageRoute(builder: (context) => NotificationPage()));
  }
}
