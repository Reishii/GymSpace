import 'user.dart';
import 'challenge.dart';
import 'post.dart';
import 'package:flutter/material.dart';


class Profile extends StatefulWidget {
  User forUser;
  
  Profile(this.forUser);
  _ProfileState createState() => _ProfileState(forUser);
}

class _ProfileState extends State<Profile> {
  String _description;
  String _quote;
  String _avatarImage; // changed from UML Image -> String
  double _progress;
  final User _forUser;
  List<Challenge> _challenges;
  List<Post> _posts; // new from UML
  Map _weightLog = {DateTime: 0};

  _ProfileState(this._forUser);

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
                      "FIRST LAST",
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
                  )
                ],
              )),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(top: 50),
            child: Text("Lifter Type"),
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
          child: Text('"THIS IS A MOTIVATIONAL QUOTE"'),
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

  void addPost(Post post) => _posts.add(post);
  void addFriend() {}
  void block() {}
  void calculateDietInfo() {}
  void displayGraph() {}
  String getDescription() => _description;
  double getProgress() => _progress;
  List<Challenge> getChallenges() => _challenges;
  User getUser() => _forUser;
  String getQuote() => _quote;
  String getAvatarImage() => _avatarImage;
  Map getWeightLog() => _weightLog;
  void removePost(Post post) => _posts.remove(post); // might need to have this actually return a bool to check
  void setAvatarImage(String image) => _avatarImage = image;
  void setDescription(String description) => _description = description;
  void setQuote(String quote) => _quote = quote;
  void updateProgress(double progress) => _progress = progress;  // unsure if this works
  
}