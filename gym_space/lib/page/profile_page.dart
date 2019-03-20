import 'package:flutter/material.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/app_drawer.dart';

class ProfilePage extends StatelessWidget {
  final Widget child;

  ProfilePage({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: _buildAppBar(),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(300),
      child: AppBar(
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Colors.white,),
          )
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(40))
        ),
        bottom: _buildProfileHeading(),
      )
    );
  }

  Widget _buildProfileHeading() {
    return PreferredSize(
      child: Container(
        child: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage("https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"),
              backgroundColor: Colors.white,
              radius: 70,
            ),
            Divider(),
            Text("Jane Doe", // change this to current user's name
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
            Divider(),
            Text("Body Builder", // change this to current user's lifting type
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300
              ),
            ),
            Divider(),
            Text('"They hate us cause they ain\'t us"', // change this to current user's quote
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}