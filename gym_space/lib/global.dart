import 'dart:async';
import 'package:GymSpace/logic/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

class DatabaseHelper {
  static String currentUserID = "";
  
  static Future<FirebaseUser> getCurrentUser() async {
    return await FirebaseAuth.instance.currentUser();
  }

  static Future<DocumentSnapshot> getCurrentUserBuddiesSnapshot(String userID) async {
    DocumentSnapshot ds = await getUserSnapshot(userID);
    DocumentSnapshot buddySnap = ds.data['buddies'];
    return buddySnap;
  }

  static Future<List<String>> getCurrentUserBuddies() async {
    DocumentSnapshot ds = await getUserSnapshot(currentUserID);
    List<String> buddies = ds.data['buddies'].cast<String>().toList();
    return buddies;
  }

  static Future<DocumentSnapshot> getUserSnapshot(String userID) async {
    return Firestore.instance.collection('users').document(userID).get();
  }

  static Stream<DocumentSnapshot> getUserStreamSnapshot(String userID) {
    return Firestore.instance.collection('users').document(userID).snapshots();
  }

  static Future<DocumentSnapshot> getWorkoutPlanSnapshot(String workoutPlanID) async {
    return Firestore.instance.collection('workoutPlans').document(workoutPlanID).get();
  }

  static Future<DocumentSnapshot> getWorkoutSnapshot(String workoutID) async {
    return Firestore.instance.collection('workouts').document(workoutID).get();
  }

  static Future<DocumentSnapshot> getCurrentUserBuddiesSnapshot() async {
    DocumentSnapshot ds = await getUserSnapshot(currentUserID);
    DocumentSnapshot buddySnap = ds.data['buddies'];
    return buddySnap;
  }

  static getGroupStreamSnapshot(String groupID) async {
    return Firestore.instance.collection('groups').document(groupID).snapshots();
  }

  static Future<List<User>> searchDBForUserByName(String name) async {
    Query firstNameQuery = Firestore.instance.collection('users')
      .where('firstName', isEqualTo: name);

    Query lastNameQuery = Firestore.instance.collection('users')
      .where('lastName', isEqualTo: name);
    
    QuerySnapshot firstNameQuerySnap = await firstNameQuery.getDocuments();
    QuerySnapshot lastNameQuerySnap = await lastNameQuery.getDocuments();
    
    List<User> foundUsers = List();
    firstNameQuerySnap.documents.forEach((ds) {
      User user = User.jsonToUser(ds.data);
      user.documentID = ds.documentID;
      foundUsers.add(user);
    });
    
    lastNameQuerySnap.documents.forEach((ds) {
      if (!firstNameQuerySnap.documents.contains(ds)) {
        User user = User.jsonToUser(ds.data);
        user.documentID = ds.documentID;
        foundUsers.add(user);
      }
    });
    
    
    return foundUsers;
  }
}