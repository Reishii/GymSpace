import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'logic/user.dart';
import 'package:GymSpace/logic/auth.dart';

class AuthSettings {
  static Auth auth = Auth();
  static AuthStatus authStatus = AuthStatus.notLoggedIn;
}

class Defaults {
  static String photoURL = 'https://firebasestorage.googleapis.com/v0/b/gymspace.appspot.com/o/default_icon.png?alt=media&token=af0d9f4b-cec3-4f05-87a5-5dd1bfc0eb5a';
}

class Errors {

}

class Users {
  static String currentUserID = "";
  
  static Future<String> getCurrentUserID() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser().catchError((e) => print(e.error));
    return currentUser.uid;
  }

  // static void _fetchCurrentUserID() async {
  //   FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
  //   _currentUserID = currentUser.uid;
  // }

  static Future<DocumentSnapshot> getUserSnapshot(String userID) {
    var future = Firestore.instance.collection('users').document(userID).get();
        return future.catchError((e) => print('Error : $e'));
  }

  // static void _fetchCurrentUserInfo() {
  //   var doc = Firestore.instance.collection('users');
  //   getCurrentUserID().then((s) => print('user: $s'));
    
  // }
}