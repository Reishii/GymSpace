import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:GymSpace/global.dart';

class MePage extends StatelessWidget {
  final Widget child;
  Future<DocumentSnapshot> _futureUser = Users.getUserSnapshot(Users.currentUserID);

  MePage({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(startPage: 
      2,),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(300),
      child: AppBar(
        elevation: 5,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Colors.white,),
            onPressed: (){},
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
      preferredSize: Size.fromHeight(0),
      child: Container(
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: _futureUser,
              builder: (context, snapshot) {
                String photoURL = 
                  snapshot.hasData && !snapshot.data['photoURL'].isEmpty ? snapshot.data['photoURL'] : Defaults.photoURL;

                return CircleAvatar(
                  backgroundImage: NetworkImage(photoURL),
                  backgroundColor: Colors.white,
                  radius: 70,
                );
              },
            ),
            Divider(),
            FutureBuilder(
              future: _futureUser,
              builder: (context, snapshot) => 
                Text(
                  snapshot.hasData ? snapshot.data['firstName'] + ' ' + snapshot.data['lastName'] : "" ,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                )
            ),
            Divider(),
            FutureBuilder(
              future: _futureUser,
              builder: (context, snapshot) => 
                Text(
                  snapshot.hasData ? snapshot.data['liftingType'] : "", // change this to current user's lifting type
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300
                  ),
                ),
            ),
            Divider(),
            FutureBuilder(
              future: _futureUser,
              builder: (context, snapshot) =>
                Text(
                  snapshot.hasData ? snapshot.data['bio'] : "", // change this to current user's quote
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ),
            Divider()
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      child: ListView(
        children: <Widget>[
          _buildNutritionLabel(),
          _buildNutritionInfo(),
          _buildWeightInfo(),
          _buildTodaysEventsLabel(),
          _buildTodaysEventsInfo(),
          _buildChallengesLabel(),
          _buildChallengesInfo()
        ],
      ),
    );
  }

  Widget _buildNutritionLabel() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              height: 40,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Daily Nutrition",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 1.2
                  ),
                ),
                decoration: ShapeDecoration(
                  color: GSColors.darkBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topRight: Radius.circular(20)
                    )
                  )
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          )
        ],
      ),
    );
  }

  Widget _buildNutritionInfo() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              height: 140,
              child: Container(
                decoration: ShapeDecoration(
                  shape: CircleBorder(
                    side: BorderSide(
                      width: 10,
                      color: GSColors.darkBlue
                    )
                  )
                ),
              )
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin:EdgeInsets.symmetric(vertical: 5),
                      child: Text("Protein:        100" + "g"),
                    ),
                    Container(
                      margin:EdgeInsets.symmetric(vertical: 5),
                      child: Text("Carbs:          60" + "g"),
                    ),
                    Container(
                      margin:EdgeInsets.symmetric(vertical: 5),
                      child: Text("Fats:             40" + "g"),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      )
    );
  }

  Widget _buildWeightInfo() {
    return Container(
      height: 80,
      margin: EdgeInsets.only(top: 30),
      decoration: ShapeDecoration(
        color: GSColors.darkBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            topLeft: Radius.circular(20)
          )
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildStartingWeight(),
          _buildCurrentWeight(),
        ],
      ),
    );
  }

  Widget _buildCurrentWeight() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Container(
            margin: EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              "Current Weight",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                letterSpacing: 1.2
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            child: FutureBuilder(
              future: _futureUser,
              builder: (context, snapshot) =>
                Text(
                  snapshot.hasData ? snapshot.data['currentWeight'].toString() + ' lbs' : '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14
                  ),
                )
              ),
            ),
          ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.caretDown, color: Colors.red, size: 16),
                FutureBuilder(
                  future: _futureUser,
                  builder: (context, snapshot) =>
                    Text(
                      snapshot.hasData ? (snapshot.data['startingWeight'] - snapshot.data['currentWeight']).toString() + ' lbs' : '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                ),
              ],
            )
          ),
        ),
      ],
    );
  }

  Widget _buildStartingWeight() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Container(
            margin: EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              "Starting Weight",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                letterSpacing: 1.2
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            child: FutureBuilder(
              future: _futureUser,
              builder: (context, snapshot) =>
              Text(
                snapshot.hasData ? snapshot.data['startingWeight'].toString() + " lbs" : "",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14
                ),
              )
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
      ],
    );
  }

  Widget _buildTodaysEventsInfo() {
    return Container (
      margin: EdgeInsets.only(top: 30),
      child: Text("Update this to be workout or group event."),
    );
  }

  Widget _buildTodaysEventsLabel() {
    return Container (
      margin: EdgeInsets.only(top: 30),
      height: 40,
      child: Row (
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              height: 40,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Today's Events",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 1.2
                  ),
                ),
                decoration: ShapeDecoration(
                  color: GSColors.darkBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20)
                    )
                  )
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengesLabel() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      height: 40,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                color: GSColors.darkBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  )
                )
              ),
              child: Text(
                "Challenges",
                style:TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  letterSpacing: 1.2
                )
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengesInfo() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
    );
  }
}