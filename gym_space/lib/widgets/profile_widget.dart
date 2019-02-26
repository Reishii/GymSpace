import 'package:flutter/material.dart';
import 'package:GymSpace/logic/profile_data.dart';
import 'package:GymSpace/logic/meal.dart';
import 'package:GymSpace/colors.dart';

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
      color: GSColors.cloud,
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
    return Container(
        // decoration: BoxDecoration(color: darkBlue),
        color: GSColors.darkBlue,
        child: Row(
          // Name, Profile Picture, and Lifter Typea
          children: <Widget>[
            Expanded(
              // used just for a spacer
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
                              color: Colors.white,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w300,
                              fontSize: 10,
                              letterSpacing: 1),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: CircleAvatar(
                            radius: 80,
                            backgroundImage:
                                NetworkImage(_profileData.getProfilePic()),
                          ))
                    ],
                  )),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  _profileData.getUser().getLiftingType(),
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                      fontSize: 10,
                      letterSpacing: 1),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildQuote() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 20,
          child: Card(
              // color: Colors.white24,
              child: Container(
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(_profileData.getQuote(),
                          textAlign: TextAlign.center, style: TextStyle()),
                    ],
                  ))),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
      ],
    );
  }

  Widget _buildDietInfo() {
    return Container(
        child: Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 20,
          child: Card(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Icon(Icons.fastfood, size: 120),
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    children: <Widget>[
                      Text("Protein: " + _getDailyProtein().toString() + 'g'),
                      Text("Carbs:  " + _getDailyCarbs().toString() + 'g'),
                      Text("Fats: " + _getDailyFats().toString() + 'g'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
      ],
    ));
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

  double _getDailyProtein() {
    if (_profileData.getUser().getDiet()[DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)] ==
        null) {
      return 0;
    }

    double totalProtein = 0;
    for (Meal meal in _profileData.getUser().getDiet()[DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day)]) {
      totalProtein += meal.getProtein();
    }

    return totalProtein;
  }

  double _getDailyCarbs() {
    if (_profileData.getUser().getDiet()[DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)] ==
        null) {
      return 0;
    }

    double totalCarbs = 0;
    for (Meal meal in _profileData.getUser().getDiet()[DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day)]) {
      totalCarbs += meal.getCarbs();
    }

    return totalCarbs;
  }

  double _getDailyFats() {
    if (_profileData.getUser().getDiet()[DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)] ==
        null) {
      return 0;
    }

    double totalFats = 0;
    for (Meal meal in _profileData.getUser().getDiet()[DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day)]) {
      totalFats += meal.getFats();
    }

    return totalFats;
  }
}
