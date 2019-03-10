// tabs
import 'tabs/me.dart';
import 'tabs/newsfeed.dart';
import 'tabs/workouts_tab.dart';
import 'tabs/widget_tab.dart';
import 'drawer.dart';
import 'auth.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'chatscreen.dart';
import 'global.dart';
import 'test_users.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'message.dart';

class Home extends StatefulWidget {
  // Status of checking if user logged out
  Home({this.auth, this.onLoggedOut}) {
    GlobalSettings.currentUser = this.auth.currentUser();
    GlobalSettings.currentTestUser = rolly;
  }
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

  // Friends List
  final friendRequestTitle = new Container(
    margin: EdgeInsets.only(top: 25, bottom: 10),
    child: new Column(
      children: <Widget>[
        new Container(
          child: new Text("Requests",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Roboto',
            fontSize: 26,
            fontWeight: FontWeight.w600,
          )),
        ),

        new Container(
          height: 1.0,
          width: 110.0,
          color: Colors.black,
        ),
      ],
    ),
  );
  final friendLeft = new Container(
    margin: EdgeInsets.all(10),
    child: new CircleAvatar(
      backgroundColor: GSColors.darkCloud,
      backgroundImage: new AssetImage("lib/assets/armshake.jpg"),
      radius: 36.0,
    ),
  );
  final friendMiddle =  new Expanded(
    flex: 2,
    child: new Container(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new Text("Name",
              style: new TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              )),

          new Text("3 mutual friends",
              style: new TextStyle(
                color: GSColors.darkBlue,
              )),
        ],
      ),
    ),
  );
  final friendRight = new Expanded(
    flex: 2,
    child: Container(
      child: new Row(
        children: <Widget>[
          // Will check if friends or not
          new RaisedButton(
              child: Container(
                  child: Text("Friends",
                      style: new TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      )),
                    ),
                  onPressed:() {
                  }
              ),
            ],
          ),
      ),
    );
  final friendRealTitle = new Container(
    margin: EdgeInsets.only(top: 25, bottom: 10),
    child: new Column(
      children: <Widget>[
        new Container(
          child: new Text("Friends",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Roboto',
                fontSize: 26,
                fontWeight: FontWeight.w600,
              )),
        ),

        new Container(
          height: 1.0,
          width: 90.0,
          color: Colors.black,
        ),
      ],
    ),
  );

  // Group Cards
  final groupTitle = new Container(
    margin: EdgeInsets.only(top: 25, left: 5, bottom: 10),
    child: new Text("Collections",
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Roboto',
          fontSize: 32,
          fontWeight: FontWeight.w600,
        )),
  );
  final groupBackgroundImage = new Container(
    decoration: new BoxDecoration(
      image: new DecorationImage(
        colorFilter: new ColorFilter.mode(
            Colors.black.withOpacity(0.6),
            BlendMode.luminosity),
        image: new NetworkImage('https://cdn.pixabay.com/photo/2016/12/13/16/17/dancer-1904467_960_720.png'),
        fit: BoxFit.cover,
      ),
    ),
  );
  final groupOnTopContent = new Container(
    height: 80.0,
    child: new Column(mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: <Widget>[
        new Container(
          margin: EdgeInsets.only(left: 10),
          child: new Text("Trending this week",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Roboto',
                fontSize: 30,
                letterSpacing: 1,
              )),
        ),

        new Container(
          margin: EdgeInsets.only(left: 10),
          child: new Text("Zumba Classes near you",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Roboto',
                fontSize: 16,
                letterSpacing: 1,
              )),
        ),

        new Container(
          margin: EdgeInsets.only(left: 10),
          height: 2.0,
          width: 200.0,
          color: Colors.redAccent,
        ),

        new Container(
          margin: EdgeInsets.only(left: 10),
          child:  new Text("5 Spots",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Roboto',
                fontSize: 12,
              )),
        ),
      ],
    ),
  );

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
                // Navigator.push(context, MaterialPageRoute(builder: (context) => Sec ))
                builder: (BuildContext context){
                    return new Scaffold(
                      appBar: new AppBar(
                        title: new Text("Flutter Chat"),
                    ),
                    // body: new ChatScreen()
                    body: new MsgMain()
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
                            appBar: AppBar(
                              title: Text('Notifications'),
                              actions: <Widget>[
                                new IconButton(icon: new Icon(Icons.notifications_active)),
                              ],
                            ),
                            body: ListView(
                              children: <Widget>[
                                Column(children: <Widget>[
                                  _buildNotifications(),
                                  _buildNotificationsOld(),
                                ],)
                              ],
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
                            appBar: AppBar(
                                title: Text('Account Settings')),
                            body: ListView(
                              children: <Widget>[
                                _buildEditProfile(),
                              ],
                            ),
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
                            appBar: AppBar(
                                title: Text('Friends List')),
                            body: ListView(
                              children: <Widget>[
                                friendRequestTitle,
                                _buildFriendsList(),
                                _buildFriendsList(),
                                friendRealTitle,
                                _buildFriendsList(),
                                _buildFriendsList(),
                                _buildFriendsList(),
                                _buildFriendsList(),
                                _buildFriendsList(),
                                _buildFriendsList(),
                              ],
                            )
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
                            appBar: AppBar(
                                title: Text('Groups')),
                            body: ListView(
                              children: <Widget>[
                                groupTitle,
                                _buildGroups(),
                              ],
                            ),
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
                        onPressed: _loggedOut,
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
    return FancyBottomNavigation(
      circleColor: GSColors.darkBlue,
      inactiveIconColor: GSColors.blue,
      tabs: [
        TabData(
          iconData: Icons.rss_feed, title: "News Feed"
        ),
        TabData(
          iconData: Icons.account_circle, title: "Profile"
        ),
        TabData(
          iconData: Icons.fitness_center, title: "Workouts"
        )
      ],
      onTabChangedListener: onTabTapped,
      );
  }

  Widget _buildNotifications(){
    return Container(
      decoration: BoxDecoration(color: GSColors.darkCloud),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 3, bottom: 3, right: 360),
                    child: Text("New",
                        textAlign: TextAlign.left, style:TextStyle(
                            color: Colors.brown,
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            letterSpacing: 1
                        )),
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsOld(){
    return Container(
      margin: EdgeInsets.only(top:300),
      decoration: BoxDecoration(color: GSColors.darkCloud),
      child: Row(
        children: <Widget>[
          // New Notifications
          Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 3, bottom: 3, right: 350),
                    child: Text("Older",
                        textAlign: TextAlign.left, style:TextStyle(
                            color: Colors.brown,
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            letterSpacing: 1
                        )),
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfile(){
    return Container(
        decoration: BoxDecoration(color: GSColors.cloud),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(top: 5),
                child: Column(
                  children: <Widget>[
                    // CHANGE PROFILE PHOTO
                    new MaterialButton(
                        child: Text(
                          "Change Profile Photo",
                          style: TextStyle(
                              color: Colors.blue,
                              fontFamily: 'Roboto',
                              fontSize: 12,
                              letterSpacing: 1),
                        ),
                        onPressed:() {

                        }
                    ),

                    // CURRENT PROFILE PHOTO
                    Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: CircleAvatar(
                          radius: 55,
                          backgroundImage: new AssetImage("lib/assets/armshake.jpg"),
                        )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildFriendsList(){
    return new Container(
        child: new Row(
          children: <Widget>[
            friendLeft,
            friendMiddle,
            friendRight,
            ],
          ),
        );
}

Widget _buildGroups(){
    return new Container(
      padding: new EdgeInsets.all(8.0),
      height: 250.0,
      child: new Stack(
        children: <Widget>[
          groupBackgroundImage,
          groupOnTopContent,
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
