import 'package:flutter/material.dart';
import 'package:GymSpace/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';

class BuddyPreview{
  String firstName;
  String lastName;
  String photoURL;
  String quote;
  String documentID;
  int mutuals;
  List<String> buddies = List();

  BuddyPreview({
    this.firstName = "",
    this.lastName = "",
    this.photoURL = "",
    this.quote = "",
    this.documentID = "",
    this.mutuals = 0,
    this.buddies,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName' : lastName,
      'photoURL' : photoURL,
      'bio': quote,
      'mutuals': mutuals, 
      'buddies': buddies == null ? [] : buddies,
    };
  }

  static Future<BuddyPreview> jsonToBuddyPreview(Map<String, dynamic> data, String buddyID) async {
    //pull buddy IDs
    List<String> buddyIDs = data['buddies'].cast<String>();

    return BuddyPreview(
      firstName: data['firstName'],
      lastName: data['lastName'],
      photoURL: data['photoURL'],
      quote: data['bio'],
      documentID: buddyID,
    );
  }

}