import 'dart:async';
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

  static Future<DocumentSnapshot> getUserSnapshot(String userID) async {
    return Firestore.instance.collection('users').document(userID).get();
  }

  static Future<DocumentSnapshot> getWorkoutPlanSnapshot(String workoutPlanID) async {
    return Firestore.instance.collection('workoutPlans').document(workoutPlanID).get();
  }

  static Future<DocumentSnapshot> getWorkoutSnapshot(String workoutID) async {
    return Firestore.instance.collection('workouts').document(workoutID).get();
  }

  static Future<List<String>> getCurrentUserBuddies() async {
    DocumentSnapshot ds = await getUserSnapshot(currentUserID);
    List<String> buddies = ds.data['buddies'].cast<String>().toList();
    return buddies;
  }
}