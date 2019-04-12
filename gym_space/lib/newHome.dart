import 'package:flutter/material.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:GymSpace/page/me_page.dart';
import 'logic/auth.dart';
import 'package:GymSpace/page/login_page.dart';
import 'global.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // @override 
  void initState() {
    GlobalSettings.auth.currentUser().then((userID) {
      if (userID != null) {
        GlobalSettings.authStatus = AuthStatus.loggedIn;
      } else {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return Scaffold(
              body: LoginPage(auth: GlobalSettings.auth, authStatus: GlobalSettings.authStatus),
            );
          }
        ));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: MePage(),
    );
  }

  void _loggedOut() async {
    try {
      GlobalSettings.auth.signOut();
      GlobalSettings.authStatus = AuthStatus.notLoggedIn;
    } catch (e) {
      print(e);
    }
  }
}