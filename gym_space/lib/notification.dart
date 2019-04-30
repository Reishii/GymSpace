import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/page_header.dart';
import 'package:GymSpace/logic/notification.dart';
import 'package:GymSpace/notification_api.dart';

import 'package:GymSpace/page/buddy_page.dart';
import 'package:GymSpace/page/messages_page.dart';

class NotificationPage extends StatefulWidget {

  @override 
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationPage> {
  final FirebaseMessaging _messaging = FirebaseMessaging();
  final TextEditingController titleController = TextEditingController(text: 'Title');
  final TextEditingController bodyController = TextEditingController(text: 'Body123');
  final List<Message> messages = [];

  void sendNotification() async {
    final response = await Messaging.sendToAll(
      title: titleController.text,
      body: bodyController.text,
    );
    if(response.statusCode != 200){
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('[${response.statusCode}] Error message: ${response.body}'),));
    }
  }

  void sendTokenToServer(String fcmToken){
    print('Token: $fcmToken');
    // Update user's fcmToken just in case

  }
  
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
  void handleOnResumeRouting(dynamic notification){
    switch (notification){
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: AppDrawer(startPage: 5,),
      backgroundColor: GSColors.darkBlue,
      body: ListView(
        children: [
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
           TextFormField(
            controller: bodyController,
            decoration: InputDecoration(labelText: 'Body'),
          ),
          RaisedButton(
            onPressed: sendNotification,
            child: Text('Send notification to ALL'),
          )
        ]..addAll(messages.map(buildMessage).toList()),
      ), 
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
        setState(() {
         messages.add(Message(
           title: notification['title'],
           body: notification['body']
         )); 
        });
        handleRouting(notification);
      },
      onLaunch:  (Map<String, dynamic> message) async {
        print("onLaunch: ${message.toString()}");
         final notification = message['data'];
        setState(() {
         messages.add(Message(
           title: 'OnLaunch: ${notification['title']}',
           body: 'OnLaunch: ${notification['body']}'
         )); 
        });
        handleRouting(notification);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
         final notification = message['data'];
        print('this is notification $notification');
        handleRouting(notification);
      }
    );
  }

  Widget buildMessage(Message message) => ListTile(
    title: Text(message.title),
    subtitle: Text(message.body),
  );
 
}
