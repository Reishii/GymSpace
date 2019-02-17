// This is the home/me page

import 'package:flutter/material.dart';
import 'newsfeed.dart';
import 'workouts.dart';

class MeTab extends StatefulWidget {
  _MeTabState createState() => _MeTabState();
}

class _MeTabState extends State<MeTab> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    NewsFeedTab(),
    WorkoutsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("My Profile"),
      ),
      // body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.rss_feed),
            title: Text("News Feed")
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.account_circle),
            title: Text("Profile")
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.fitness_center),
            title: Text("Workouts")
          ),
          
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}