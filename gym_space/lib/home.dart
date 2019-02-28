// tabs
import 'tabs/me.dart';
import 'tabs/newsfeed.dart';
import 'tabs/workouts.dart';
import 'tabs/widget_tab.dart';
import 'drawer.dart';
import 'auth.dart';
import 'package:flutter/material.dart';
import 'chatscreen.dart';

class Home extends StatefulWidget {
  // Status of checking if user logged out
  Home({this.auth, this.onLoggedOut});
  final BaseAuth auth;
  final VoidCallback onLoggedOut;

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<WidgetTab> _children = [
    NewsFeedTab("News Feed"),
    MeTab("My Profile"),
    WorkoutsTab("Workouts"),
  ];

  void _loggedOut() async {
    try {
      await widget.auth.signOut();
      widget.onLoggedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _children[_currentIndex],
      // DRAWER START
      drawer: _buildDrawer(),
      bottomNavigationBar: _buildBottomNavBar(),
    );  
  }

  Widget _buildAppBar() {
    return AppBar(
        centerTitle: true,
        title: Text(_children[_currentIndex].getTitle()),
        backgroundColor: _children[_currentIndex].mainColor,
        actions: <Widget>[
          // for search and messages buttons
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
            onPressed: () {         //PS - press message icon to open chat
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context){
                    return new Scaffold(
                      appBar: new AppBar(
                        title: new Text("Flutter Chat"),
                    ),
                    body: new ChatScreen()
                  ); 
                }
              ));
            },
          ),
        ],
      );
  }

  Widget _buildDrawer() {
    return new Drawer(
        // ListTiles are used for entries in the Drawer Widget
        child: Column(
          children: <Widget>[
             Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
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
                  // Notifications Drawer
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text("Notifications"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return new Scaffold(
                            appBar: AppBar(title: Text('Notifications')),
                            body: new Center(
                              child: new Text("Hello"),
                            ),
                          );
                        }, // Builder
                      ));
                    },
                  ),

                  // Account Drawer
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text("Account"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return Scaffold(
                            appBar: AppBar(title: Text('Account Settings')),
                          );
                        }, // Builder
                      ));
                    },
                  ),

                  // Friends Drawer
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text("Friends"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return Scaffold(
                            appBar: AppBar(title: Text('Friends List')),
                          );
                        }, // Builder
                      ));
                    }, // On Tap
                  ),

                  // Groups Drawer
                  ListTile(
                    leading: Icon(Icons.group_work),
                    title: Text("Groups"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return Scaffold(
                            appBar: AppBar(title: Text('Groups')),
                          );
                        }, // Builder
                      ));
                    }, // On Tap
                  ),

                  // Progress Drawer
                  ListTile(
                    leading: Icon(Icons.local_dining),
                    title: Text("Progress"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return Scaffold(
                            appBar: AppBar(title: Text('Overall Progress')),
                          );
                        }, // Builder
                      ));
                    }, // On Tap
                  ),

                  // Settings Drawer
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Settings"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return Scaffold(
                            appBar: AppBar(title: Text('Settings')),
                          );
                        }, // Builder
                      ));
                    }, // On Tap
                  ), 
                ], 
              ),
             ),
             Container (
               child: Align(
                 alignment: FractionalOffset.bottomCenter,
                 child: Container(
                   child:Column(
                    children: <Widget> [
                      Divider(),
                      RaisedButton(
                        color: Colors.redAccent,
                        child: new Text('Logout',
                        style: new TextStyle(fontSize: 15.0, color: Colors.white)),
                        onPressed: (){_loggedOut(); Navigator.pop(context, true);},
                      )
                    ]
                   )
                 )
               )
             )   
          ],
        ),
      );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.rss_feed), title: Text("News Feed")),
          BottomNavigationBarItem(
              icon: new Icon(Icons.account_circle), title: Text("Profile")),
          BottomNavigationBarItem(
              icon: new Icon(Icons.fitness_center), title: Text("Workouts")),
        ],
      );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
