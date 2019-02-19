// tabs
import 'tabs/me.dart';
import 'tabs/newsfeed.dart';
import 'tabs/workouts.dart';
import 'tabs/widget_tab.dart';

// colors
// import 'colors.dart' as _colors;

// misc
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymSpace',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<WidgetTab> _children = [
    NewsFeedTab("News Feed"),
    MeTab("My Profile"),
    WorkoutsTab("Workouts"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_children[_currentIndex].getTitle()),
        backgroundColor: _children[_currentIndex].mainColor,
        actions: <Widget>[      // for search and messages buttons
          IconButton(
            icon: Icon(
              Icons.search, 
              color: Colors.white,
              ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.message,
              color: Colors.white,
              ),
            onPressed: () {},
          ),
        ],
      ),
      body: _children[_currentIndex],
      drawer: Drawer( // ListTiles are used for entries in the Drawer Widget
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: CircleAvatar(
                child: Icon(
                  Icons.person_outline,
                  size: 50,
                  ),
                backgroundColor: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text("Notifications"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("Friends"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.group_work),
              title: Text("Groups"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {},
            ),
          ],
        ),
      ),
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