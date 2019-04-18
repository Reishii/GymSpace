import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'logic/user.dart';
import 'package:GymSpace/logic/auth.dart';

class GlobalSettings {
  static String currentUser;
  static User currentTestUser;

  static Auth auth = Auth();
  static AuthStatus authStatus = AuthStatus.notLoggedIn;
}

class Users {
  static String _currentUserID = "";
  
  static Future<String> getCurrentUserID() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    return currentUser.uid;
  }

  // static void _fetchCurrentUserID() async {
  //   FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
  //   _currentUserID = currentUser.uid;
  // }

  static Future<DocumentSnapshot> getUserSnapshot(String userID) {
    return Firestore.instance.collection('users').document(userID).get();
  }

  // static void _fetchCurrentUserInfo() {
  //   var doc = Firestore.instance.collection('users');
  //   getCurrentUserID().then((s) => print('user: $s'));
    
  // }
}