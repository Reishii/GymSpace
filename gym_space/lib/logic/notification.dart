import 'package:flutter/material.dart';
class Notifications{
  String title;
  String body;
  String route;
  String receiver;
  String sender;

  Notifications({
    this.title,
    this.body,
    this.route,
    this.receiver,
    this.sender
  });
 factory Notifications.fromJSON(Map<dynamic, dynamic> json){
    return Notifications(
     title: json['title'],
     body: json['body'],
     route: json['route'],
     receiver: json['fcmToken'],
     sender: json['sender']
    );
  }
}