import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'logic/user.dart';
import 'package:GymSpace/logic/auth.dart';

class GlobalSettings {
  static String currentUser;
  static User currentTestUser;

  static Auth auth = Auth();
  static AuthStatus authStatus = AuthStatus.notLoggedIn;
}

class CurrentUser {
  static String _currentUserID = "";
  
  static String getCurrentUserID() {
    if (_currentUserID.isEmpty) {
      _fetchCurrentUserID();
    }

    return _currentUserID;
  }

  static void _fetchCurrentUserID() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    _currentUserID = currentUser.uid;
  }
}