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
                          )),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          _profileData.getQuote(),
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              letterSpacing: 1),
                        ),
                      ),
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
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildQuote() {
    return Container(
        margin: EdgeInsets.all(3),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Card(
                  elevation: 3,
                  // color: Colors.white24,
                  child: Container(
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              "This is a motivational quote. Use quotes REST API.",
                              textAlign: TextAlign.center,
                              style: TextStyle()),
                        ],
                      ))),
            ),
          ],
        ));
  }

  Widget _buildDietInfo() {
    return Container(
        margin: EdgeInsets.all(3),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Card(
                elevation: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Icon(Icons.fastfood, size: 100),
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: <Widget>[
                            Text("Protein: " +
                                _getDailyProtein().toString() +
                                'g'),
                            Text(
                                "Carbs:  " + _getDailyCarbs().toString() + 'g'),
                            Text("Fats: " + _getDailyFats().toString() + 'g'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildWeightGraph() {
    return Container(
        margin: EdgeInsets.all(3),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 48,
              child: Card(
                  elevation: 3,
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.show_chart,
                        size: 200,
                      ),
                      Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Current Weight: " +
                                _profileData.getUser().getWeight().toString() +
                                " lbs",
                          ))
                    ],
                  )),
            ),
          ],
        ));
  }

  Widget _buildChallenges() {
    return Container(
      margin: EdgeInsets.all(3),
      child: Column(
        children: <Widget>[
          Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Card(
                elevation: 3,
                child: Container( 
                  padding: EdgeInsets.all(5),
                  child: Text(
                  "Challenges",
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      letterSpacing: 3),
                  ),
                ),
              ),
            // List of challenges here (may need to use the ListBuilder Widget for this)
            ),
          ],),
          Card(
            elevation: 3,
            child: Container(
              height: 40,
            ),
          ),
          Card(
            elevation: 3,
            child: Container(
              height: 40,
            ),
          ),
          Card(
            elevation: 3,
            child: Container(
              height: 40,
            ),
          ),
          Card(
            elevation: 3,
            child: Container(
              height: 40,
            ),
          ),
          Card(
            elevation: 3,
            child: Container(
              height: 40,
            ),
          ),
        ],
      ),
    );
  }

  double _getDailyProtein() {
    if (_profileData.getUser().diet[DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)] ==
        null) {
      return 0;
    }

    double totalProtein = 0;
    for (Meal meal in _profileData.getUser().diet[DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day)]) {
      totalProtein += meal.getProtein();
    }

    return totalProtein;
  }

  double _getDailyCarbs() {
    if (_profileData.getUser().diet[DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)] ==
        null) {
      return 0;
    }

    double totalCarbs = 0;
    for (Meal meal in _profileData.getUser().diet[DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day)]) {
      totalCarbs += meal.getCarbs();
    }

    return totalCarbs;
  }

  double _getDailyFats() {
    if (_profileData.getUser().diet[DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)] ==
        null) {
      return 0;
    }

    double totalFats = 0;
    for (Meal meal in _profileData.getUser().diet[DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day)]) {
      totalFats += meal.getFats();
    }

    return totalFats;
  }
}
