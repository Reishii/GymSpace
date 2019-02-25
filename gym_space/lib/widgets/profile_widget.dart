import 'package:flutter/material.dart';
import 'package:GymSpace/logic/profile_data.dart';

class Profile extends StatefulWidget {
  final ProfileData profileData;

  Profile({Key key, this.profileData}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState(profileData);
}

class _ProfileState extends State<Profile> {
  final ProfileData _profileData;

  _ProfileState(this._profileData);

   @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          Column(children: <Widget>[
            _buildProfileInfo(),
            _buildQuote(),
            _buildDietInfo(),
            _buildWeightGraph(),
            _buildChallenges()
          ]),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Row(
      // Name, Profile Picture, and Lifter Type
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 2,
          child: Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      _profileData.getUser().getName(),
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w300,
                          fontSize: 10,
                          letterSpacing: 1),
                    ),
                  ),
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(_profileData.getProfilePic()),
                  )
                ],
              )),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(top: 50),
            child: Text(_profileData.getUser().getLiftingType()),
          ),
        ),
      ],
    );
  }

  Widget _buildQuote() {
    return Row(
      // Motivational Quote
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(20),
          child: Text(_profileData.getQuote()),
        )
      ],
    );
  }

  Widget _buildDietInfo() {
    return Row(
      // Macros
      children: <Widget>[
        Expanded(
          flex: 1,
          // Calories Graph goes here
          child: Icon(Icons.graphic_eq, size: 160),
        ),
        Expanded(
          flex: 3,
          child: Column(
            // Macros
            children: <Widget>[
              Text("Protein:  "),
              Text("Carbs:  "),
              Text("Fats: "),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildWeightGraph() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(),
        )
      ],
    );
  }

  Widget _buildChallenges() {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Row(
          // Challenges
          children: <Widget>[
            Text(
              "Challenges",
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                  letterSpacing: 3),
            ),
            // List of challenges here (may need to use the ListBuilder Widget for this)
          ],
        ));
  }
}

