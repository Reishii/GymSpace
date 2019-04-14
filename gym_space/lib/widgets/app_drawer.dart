import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/page/workout_plans_page.dart';
import 'package:GymSpace/page/me_page.dart';
import 'package:GymSpace/page/buddy_page.dart';
import 'package:GymSpace/global.dart';
import 'package:GymSpace/logic/auth.dart';
import 'package:GymSpace/page/login_page.dart';
import 'package:GymSpace/widgets/chat_page.dart';
import 'package:GymSpace/page/group_page.dart';


class AppDrawer extends StatefulWidget {
  final Widget child;
  int startPage;
  int currentPage;

  AppDrawer({Key key, this.child, int startPage = 2}) : super(key: key) {
    this.startPage = startPage;
  }

  _AppDrawerState createState() => _AppDrawerState(startPage);
}

class _AppDrawerState extends State<AppDrawer> {
  int _currentPage; // 0-7 drawer items are assigned pages when they are built

  _AppDrawerState(int startPage) {
    _currentPage = startPage;
  }

  @override
  void initState() {
    // _currentPage = widget.currentPage;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 30, left: 8),
                    child: Align(
                      alignment: FractionalOffset.centerLeft,
                      child: IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: GSColors.darkBlue,
                        ),
                        onPressed: () {Navigator.pop(context);},
                      )
                    )
                  ),
                  Container(height: 20),
                  Container(
                    height: 100, // height and margin should == to make circle
                    margin: EdgeInsets.symmetric(horizontal: 100),
                    child: CircleAvatar(
                    // child: ClipOval(
                    //   child: Image.network(
                    //     "https://cdn.pixabay.com/photo/2015/03/03/08/55/portrait-photography-657116_960_720.jpg",
                    //     fit: BoxFit.fill,
                    //     width: 140,
                    //     height: 140,
                    //   ),
                    // ),
                      backgroundColor: Colors.transparent,
                      radius: 40,
                      backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2015/03/03/08/55/portrait-photography-657116_960_720.jpg"),
                    ),
                  ),
                  Container(height: 10),
                  Center(child: 
                    Text("Jane Doe",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(height: 20),
                  _buildDrawerItem("Newsfeed", FontAwesomeIcons.newspaper, 0),
                  _buildDrawerItem("Workouts", FontAwesomeIcons.dumbbell, 1),
                  _buildDrawerItem("Profile", FontAwesomeIcons.userCircle, 2),
                  _buildDrawerItem("Groups", FontAwesomeIcons.users, 3),
                  _buildDrawerItem("Buddies", FontAwesomeIcons.userFriends, 4),
                  _buildDrawerItem("Notifications", FontAwesomeIcons.bell, 5),
                  _buildDrawerItem("Messages", FontAwesomeIcons.comments, 6),
                  _buildDrawerItem("Settings", FontAwesomeIcons.slidersH, 7),
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Divider(),
                  ListTile(
                    onTap: _loggedOut,
                    title: Text(
                      "Logout", style:TextStyle(color: Colors.red),
                    ),
                    leading: Icon(FontAwesomeIcons.signOutAlt, color: Colors.red,),
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(String title, IconData icon, int page) {
    // if (_currentPage == page) {
    //   return Container(
    //     margin: EdgeInsets.symmetric(horizontal: 40),
    //     decoration: ShapeDecoration(
    //       color: GSColors.darkBlue,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(60),
    //       ),
    //     ),
    //     child: ListTile(
    //       title: Text(title, style: TextStyle(color: Colors.white),),
    //       leading: Icon(icon, color: Colors.white,)
    //     ),
    //   );
    // }

    return Container(
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: GSColors.darkBlue),
        ),
        leading: Icon(
          icon,
          color: GSColors.darkBlue,  
        ),
        onTap: () {_switchPage(page);},
      )
    );
  }

  void _switchPage(int page) {
    if (_currentPage == page) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      _currentPage = page;
      switch (_currentPage) {
        case 0: // newfeed
          break;
        case 1: // workouts
          Navigator.pushReplacement(context, MaterialPageRoute<void> (
            builder: (BuildContext context) {
              return WorkoutPlanHomePage();
            },
          ));
          break;
        case 2: // profile
          Navigator.pushReplacement(context, MaterialPageRoute<void> (
            builder: (BuildContext context) {
              return MePage();
            },
          ));
          break;
        case 3: // groups
        Navigator.pushReplacement(context, MaterialPageRoute<void> (
          builder: (BuildContext context) {
            return GroupPage(); // Switch to groups when created
          }
        ));
          break;
        case 4: // friends
        Navigator.pushReplacement(context, MaterialPageRoute<void> (
          builder: (BuildContext context) {
            return BuddyPage(); // Switch to groups when created
          }
        ));
          break;
        case 5: // notifications
          break;
        case 6: // messages
          Navigator.pushReplacement(context, MaterialPageRoute<void>(
            builder: (BuildContext context){
              return ChatPage();
              //return new Scaffold(
                //appBar: new AppBar(
                  //title: new Text("Messenger")
                //),
                //body: new ChatPage();
              //);
            }
          ));

          break;
        case 7: // settings
          break;
        default:
      }
    });
  }

  void _loggedOut() async {
    try {
      await GlobalSettings.auth.signOut();
      GlobalSettings.authStatus = AuthStatus.notLoggedIn;
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (BuildContext context) => LoginPage(),
      ));
    } catch (e) {
      print(e);
    }
  }
}