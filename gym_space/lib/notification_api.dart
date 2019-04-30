import 'package:http/http.dart';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'dart:async';
class Messaging {
  static final Client client = Client();
  static const String serverKey = 'AAAA2henAS0:APA91bGGmi3fnznxJvJLCqQy2iUKTWplTcrtDvNHNXVCgS9HGNO-WwtGfQns_UIA1BrnkRNlaJgDzMcPqfmltdpki0N8SJxuaOzgGAdhfQIvphpi6lwIZAAC7sf9d91i45wnN9fRTuzl';

  // Send notificaiton to specific person
  static Future<Response> sendTo ({
    @required String title,
    @required String body,
    @required String fcmToken,
  }) =>
    client.post(
      'https://fcm.googleapis.com/fcm/send',
      body: json.encode({
        'notification': {'body': '$body', 'title': '$title'},
        'priority': 'high',
        'data': {
          'title': '$title',
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done',
        },
        'to': '$fcmToken', 
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
    );
  
  // Send notification to specific topic (By default everyone is subscriped to topic: 'all')
  static Future<Response> sendToTopic({
    @required String title,
    @required String body,
    @required String topic
  }) =>
    sendTo(title: title, body: body, fcmToken: '/topics/$topic');

  // Send notification to everyone
  static Future<Response> sendToAll({
    @required String title,
    @required String body,

  }) =>
    sendToTopic(title: title, body: body, topic: 'all');
}