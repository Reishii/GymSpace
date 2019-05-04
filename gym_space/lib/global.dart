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
  static String userPhoto = 'lib/assets/userPhoto.png';
  static String userPhotoDB = 'https://firebasestorage.googleapis.com/v0/b/gymspace.appspot.com/o/userPhoto.png?alt=media&token=92f9628c-b00d-4cf0-9a72-1a1ed0cdd80c';
  static String groupPhoto = 'lib/assets/groupPhoto.png';
}

class Errors {

}

class DatabaseHelper {
  // user 
  static String currentUserID = "";
  
  static Future<FirebaseUser> getCurrentUser() async {
    return await FirebaseAuth.instance.currentUser();
  }

  static Future<List<String>> getCurrentUserBuddies() async {
    DocumentSnapshot ds = await getUserSnapshot(currentUserID);
    List<String> buddies = ds.data['buddies'].cast<String>().toList();
    return buddies;
  }

    static Future<List<String>> getCurrentUserMedia() async {
    DocumentSnapshot ds = await getUserSnapshot(currentUserID);
    List<String> media = ds.data['media'].cast<String>().toList();
    return media;
  }


  static Future<List<String>> getCurrentUserGroups() async {
    DocumentSnapshot ds = await getUserSnapshot(currentUserID);
    List<String> groups = ds.data['joinedGroups'].cast<String>().toList();
    return groups;
  }

  static Future<DocumentSnapshot> getUserSnapshot(String userID) async {
    return Firestore.instance.collection('users').document(userID).get();
  }

  static Future<List<User>> searchDBForUserByName(String name) async {
    String lowerName = name.toLowerCase();
    String searchName = lowerName.replaceRange(0, 1, name[0].toUpperCase());

    Query firstNameQuery = Firestore.instance.collection('users')
      .where('firstName', isEqualTo: searchName);

    Query lastNameQuery = Firestore.instance.collection('users')
      .where('lastName', isEqualTo: searchName);
    
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

  // workouts
  static Future<DocumentSnapshot> getWorkoutPlanSnapshot(String workoutPlanID) async {
    return Firestore.instance.collection('workoutPlans').document(workoutPlanID).get();
  }

  // media
  static Stream<DocumentSnapshot> getUserStreamSnapshot(String userID) {
    return Firestore.instance.collection('users').document(userID).snapshots();
  }

  static Future<DocumentSnapshot> getWorkoutSnapshot(String workoutID) async {
    return Firestore.instance.collection('workouts').document(workoutID).get();
  }

  // challenges
  static Stream<DocumentSnapshot> getWeeklyChallenges(String challengeID) {
    return Firestore.instance.collection('challenges').document(challengeID).snapshots();
  }

  // groups
  static getGroupSnapshot(String groupID) async {
    return Firestore.instance.collection('groups').document(groupID).get();
  }

  static Stream getGroupStreamSnapshot(String groupID) {
    return Firestore.instance.collection('groups').document(groupID).snapshots();
  }
}