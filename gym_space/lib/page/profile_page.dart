import 'package:GymSpace/global.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/logic/user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends StatefulWidget {
  final String forUserID;
  
  ProfilePage({
    @required this.forUserID,
    Key key
    }) : super(key: key);

  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isFriend = false;
  User user;

  @override 
  void initState() {
    super.initState();
    DatabaseHelper.getUserSnapshot(widget.forUserID).then((ds) {
      setState(() {
        user = User.jsonToUser(ds.data);
        if (user.buddies.contains(DatabaseHelper.currentUserID)) {
          _isFriend = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: user == null ? Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(),
        body: Center(child: CircularProgressIndicator()),
      ) : Scaffold(
        drawer: AppDrawer(startPage: 0,),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(400),
          child: _buildAppBar(),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      // color: Colors.red,
      // height: 400,
      child: Stack(
        children: <Widget>[
          Container(
            height: 360,
            // color: Colors.green,
            decoration: ShapeDecoration(
              color: GSColors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(36)
              )
            ),
            child: Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row( // likes
                    children: <Widget> [
                      Icon(Icons.thumb_up, color: Colors.white,),
                      Text('64 Likes', style: TextStyle(color: Colors.white),),
                    ],
                  ),
                  Row( // friend count
                    children: <Widget> [
                      Icon(Icons.group, color: Colors.white,),
                      Text('${user.buddies.length} Friends', style: TextStyle(color: Colors.white),),
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 320,
            child: AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                )
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: _buildProfileHeading(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProfileHeading() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: CircleAvatar(
              radius: 70,
              backgroundImage: CachedNetworkImageProvider(user.photoURL.isEmpty ? Defaults.photoURL : user.photoURL),
            ),
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                colors: [GSColors.blue, GSColors.darkBlue, GSColors.lightBlue,],
                // radius: 1.2
                begin: FractionalOffset.centerLeft,
                end: FractionalOffset.centerRight,
              ),
              shape: CircleBorder(
                side: BorderSide(
                  // color: GSColors.lightBlue,
                  style: BorderStyle.none,
                  width: 2
                )
              ),
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text( // name
                '${user.firstName} ${user.lastName}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Container( // points icon
                margin: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.stars,
                  size: 14,
                  color: Colors.yellow,
                ),
              ),
              Container( // points
                margin: EdgeInsets.only(left: 4),
                child: Text(
                  user.points.toString(),
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 14
                  ),
                )
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 3),
            child: Text(
              user.liftingType,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300
              ),
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(top: 5),
          //   child: Text(
          //     user.bio,
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontStyle: FontStyle.italic,
          //     ),
          //   ),
          // ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.mail_outline),
                  label: Text('Message'),
                  textColor: GSColors.darkBlue,
                  color: GSColors.cloud,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  onPressed: () {},
                ),
                FlatButton.icon(
                  icon: Icon(_isFriend ? Icons.check : Icons.add),
                  label: Text(_isFriend ? 'Friends' : 'Add Friend'),
                  textColor: Colors.white,
                  color: GSColors.lightBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      child: ListView(
        children: <Widget>[
          _buildBio(),
          _buildWeightInfo(),
          _buildPhotosVideos(),
        ],
      ),
    );
  }

  Widget _buildBio() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Column(
        children: <Widget>[
          Container( // label
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    decoration: ShapeDecoration(
                      color: GSColors.darkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )
                      )
                    ),
                    child: Text(
                      'Bio',
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
                  child: Container(),
                )
              ],
            ),
          ),
          Container( // actual bio
            // color: Colors.red,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            alignment: Alignment.center,
            child: Text(
              user.bio,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: GSColors.darkBlue,
                letterSpacing: 1.2
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightInfo() {
    double weightLost = double.parse((user.startingWeight - user.currentWeight).toStringAsFixed(2));

    return Container( // might have to use Exapndeds for proper auto alignment
      height: 70,
      decoration: ShapeDecoration(
        color: GSColors.darkBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            topLeft: Radius.circular(20)
          ),
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container( // Starting Weight
            margin: EdgeInsets.only(left: 34, right: 84),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Starting Weight',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.2
                  ),
                ),
                Text(
                  '${user.startingWeight.toStringAsFixed(2)} lbs',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.2
                  ),
                ),
              ],
            ),
          ),
          Container( // Current Weight
          margin: EdgeInsets.only(left: 34, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Current Weight',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.2
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '${user.currentWeight.toStringAsFixed(2)} lbs',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.2
                      ),
                    ),
                    Icon(
                      weightLost > 0 ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                      color: weightLost >= 0 ? Colors.red : Colors.blue,
                    ),
                    Text(
                      '$weightLost lbs',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.2
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPhotosVideos() {
    return Container( // 
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: <Widget>[
          Container(  // label
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Text(
                  'Photos & Videos',
                  style: TextStyle(
                    color: GSColors.darkBlue,
                    fontSize: 20,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  )
                ),
                Text(
                  '200 shots',
                  style: TextStyle(
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          Container( // photo gallery

          ),
        ],
      ),
    );
  }
}