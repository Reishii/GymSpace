import 'package:flutter/material.dart';
import 'package:GymSpace/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';

class BuddyPreview{
  String name;
  String quote;
  String documentID;
  int mutuals;
  List<String> buddies = List();

  BuddyPreview({
    this.name = "",
    this.quote = "",
    this.documentID = "",
    this.mutuals = 0,
    this.buddies,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      'name': name,
      'quote': quote,
      'mutuals': mutuals, 
      'buddies': buddies == null ? [] : buddies,
    };
  }

  static Future<BuddyPreview> jsonToBuddyPreview(Map<String, dynamic> data, List<String> buddyIDs) async {
    List<String> buddies = data['buddies'].cast<String>();

    
  }

}