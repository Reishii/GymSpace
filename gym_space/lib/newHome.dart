import 'package:flutter/material.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:GymSpace/page/profile_page.dart';

class newHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: ProfilePage(),
    );
  }
}