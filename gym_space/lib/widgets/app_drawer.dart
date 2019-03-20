import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/page/workout_plans_page.dart';

class AppDrawer extends StatefulWidget {
  final Widget child;

  AppDrawer({Key key, this.child}) : super(key: key);

  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  int _currentPage = 2; // 0-7 drawer items are assigned pages when they are built

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 30, left: 8),
              child: Align(
                alignment: FractionalOffset.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {Navigator.pop(context);},
                )
              )
            ),
            Container(height: 20),
            CircleAvatar(
              backgroundColor: GSColors.darkBlue,
              radius: 40,
              backgroundImage: NetworkImage("https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"),
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
            _buildDrawerItem("Friends", FontAwesomeIcons.userFriends, 4),
            _buildDrawerItem("Notifications", FontAwesomeIcons.bell, 5),
            _buildDrawerItem("Messages", FontAwesomeIcons.comments, 6),
            _buildDrawerItem("Settings", FontAwesomeIcons.slidersH, 7),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Divider(),
                  ListTile(
                    title: Text(
                      "Logout", style:TextStyle(color: Colors.red),
                    ),
                    leading: Icon(FontAwesomeIcons.signOutAlt, color: Colors.red,),
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(String title, IconData icon, int page) {
    if (_currentPage == page) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 40),
        decoration: ShapeDecoration(
          color: GSColors.darkBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
        ),
        child: ListTile(
          title: Text(title, style: TextStyle(color: Colors.white),),
          leading: Icon(icon, color: Colors.white,)
        ),
      );
    }

    return Container(
      child: ListTile(
        title: Text(title),
        leading: Icon(icon),
        onTap: () {switchPage(page);},
      )
    );
  }

  void switchPage(int page) {
    setState(() {
      _currentPage = page;
      switch (_currentPage) {
        case 1: // workouts
          Navigator.push(context, MaterialPageRoute<void> (
            builder: (BuildContext context) {
              return WorkoutPlanHomePage();
            },
          ));
          break;
        default:
      }
    });
  }
}