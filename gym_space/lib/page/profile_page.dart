import 'dart:async';
import 'package:GymSpace/global.dart';
import 'package:GymSpace/notification_page.dart';
import 'package:GymSpace/page/buddy_page.dart';
import 'package:GymSpace/page/message_thread_page.dart';
import 'package:GymSpace/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/logic/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ProfilePage extends StatefulWidget {
  final String forUserID;
  User user;
  
  ProfilePage({
    @required this.forUserID,
    Key key
    }) : super(key: key);

  ProfilePage.fromUser(this.user, {this.forUserID = ''});

  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isFriend = false;
  bool _isPrivate = true;
  User user;
  Future<List<String>> _listFutureUser;
  List<String> media = [];
  final localNotify = FlutterLocalNotificationsPlugin();

  @override 
  void initState() {
    super.initState();
  
    if (widget.user != null) {
      user = widget.user;
      user.buddies = user.buddies.toList();
      user.media = user.media.toList();

      _listFutureUser = DatabaseHelper.getUserMedia(user.documentID);
      _isFriend = user.buddies.contains(DatabaseHelper.currentUserID);
      _isPrivate = user.private;
      return;
    }

    DatabaseHelper.getUserSnapshot(widget.forUserID).then((ds) {
      setState(() {
        user = User.jsonToUser(ds.data);
        user.documentID = ds.documentID;
        if (user.buddies.contains(DatabaseHelper.currentUserID)) {
          _isFriend = true;
        }
      });
    });
    final settingsAndriod = AndroidInitializationSettings('@mipmap/ic_launcher');
    final settingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) =>
        onSelectNotification(payload));
    localNotify.initialize(InitializationSettings(settingsAndriod, settingsIOS),
      onSelectNotification: onSelectNotification);
  }
  Future onSelectNotification(String payload) async  {
    Navigator.pop(context);
    print("==============OnSelect WAS CALLED===========");
    await Navigator.push(context, new MaterialPageRoute(builder: (context) => NotificationPage()));
  } 
  void _addPressed() async {
    if (user.buddies.contains(DatabaseHelper.currentUserID)) {
      return;
    }

    await DatabaseHelper.getUserSnapshot(user.documentID).then(
      (ds) => ds.reference.updateData({'buddies': FieldValue.arrayUnion([DatabaseHelper.currentUserID])})
    );
    
    await DatabaseHelper.getUserSnapshot(DatabaseHelper.currentUserID).then(
      (ds) => ds.reference.updateData({'buddies': FieldValue.arrayUnion([user.documentID])})
    );
    
    // Send Notification for the Buddy Request
    User currentUser;
    String userID = DatabaseHelper.currentUserID;
    DatabaseHelper.getUserSnapshot(userID).then((ds){
      setState(() {
        currentUser = User.jsonToUser(ds.data);
        NotificationPage notify = new NotificationPage();
        user.notification == true ?? notify.sendNotifications('Buddy Request', '${currentUser.firstName} ${currentUser.lastName} has sent a Buddy Request', '${user.fcmToken}','buddy', userID);
      });
    });
  
    setState(() {
      user.buddies.toList().add(DatabaseHelper.currentUserID);
      _isFriend = true;
    });
  }

  void _deletePressed() async {
   showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        title: Text('Remove Friend?'),
        contentPadding: EdgeInsets.fromLTRB(24, 24, 24, 0),
        content: Container(
          child: Text(
            'Do you want unfriend this person?',
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
            textColor: GSColors.green,
          ),
          FlatButton(
            onPressed: () => _deleteBuddy(user.documentID),
            child: Text('Yes'),
            textColor: GSColors.green,
          ),
        ],
      )
    ); 
  }

  Future<void> _deleteBuddy(String buddyID) async {
    await Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).updateData(
      {'buddies': FieldValue.arrayRemove([buddyID])}
    ).then((_) => print('Successfully deleted buddy from current user'));

    await Firestore.instance.collection('users').document(buddyID).updateData(
      {'buddies': FieldValue.arrayRemove([DatabaseHelper.currentUserID])}
    ).then((_) {
      print('Successfully deleted current user from buddy.');
      setState(() {
        _isFriend = false;
        Navigator.pop(context);
      });
    });
  }

  void _openMessages() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => MessageThreadPage(
        peerId: user.documentID,
        peerAvatar: user.photoURL,
        peerFirstName: user.firstName,
        peerLastName: user.lastName,
      )
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: user == null ? 
      Scaffold(
        // drawer: AppDrawer(),
        appBar: AppBar(),
        body: Center(child: CircularProgressIndicator()),
      ) 
      : Scaffold(
        // drawer: AppDrawer(startPage: 0,),
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
      child: Stack(
        children: <Widget>[
          Container(
            height: 320,
            child: AppBar(
              // elevation: .5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
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
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          stops: [.3, .35,],
          colors: [GSColors.darkBlue, Colors.white],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(36),
            bottomRight: Radius.circular(36),
          ),
        )
      ),
      child: Column(
        children: <Widget>[
          _buildAvatarStack(),
          Divider(color: Colors.transparent,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text( // name
                '${user.firstName} ${user.lastName}',
                style: TextStyle(
                  // color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Container( // points icon
                margin: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.stars,
                  size: 14,
                  color: GSColors.green,
                ),
              ),
              Container( // points
                margin: EdgeInsets.only(left: 4),
                child: Text(
                  user.points.toString(),
                  style: TextStyle(
                    color: GSColors.green,
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
                // color: Colors.white,
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
                user == null || user.documentID == DatabaseHelper.currentUserID || widget.forUserID == DatabaseHelper.currentUserID ? 
                Container() : 
                FlatButton.icon(
                  icon: Icon(Icons.mail_outline),
                  label: Text('Message'),
                  textColor: GSColors.darkBlue,
                  color: GSColors.cloud,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  onPressed: () => _openMessages(),
                ),
                user == null || user.documentID == DatabaseHelper.currentUserID || widget.forUserID == DatabaseHelper.currentUserID ? 
                Container() : 
                FlatButton.icon(
                  icon: Icon(_isFriend ? Icons.check : Icons.add),
                  label: Text(_isFriend ? 'Buddies' : 'Add Buddy'),
                  textColor: GSColors.darkBlue,
                  color: GSColors.lightBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  onPressed: () => _isFriend ? _deletePressed() : _addPressed(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarStack() {
    return Container(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Positioned(
            left: 40,
            child: Row( // likes
              children: <Widget> [
                Icon(Icons.thumb_up, color: GSColors.lightBlue,),
                Text(' 100 Likes', style: TextStyle(color: GSColors.lightBlue),),
              ],
            ),
          ),
          FlatButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute<void> (
                  builder: (BuildContext context) {
                    return ImageWidget(user.photoURL, context, false);
                  })
                ),
            child: Container(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 70,
                backgroundImage: user.photoURL.isNotEmpty ? CachedNetworkImageProvider(user.photoURL)
                : AssetImage(Defaults.userPhoto),
              ),
              decoration: ShapeDecoration(
                shadows: [BoxShadow(blurRadius: 4, spreadRadius: 2)],
                shape: CircleBorder(
                  side: BorderSide(
                    color: Colors.white,
                    width: 1,
                  )
                ),
              ),
            ),
          ),
          Positioned(
            right: 40,
            child: InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) => BuddyPage.fromUser(user, true))
              ),
              child: Row( // likes
                children: <Widget> [
                  Icon(Icons.group, color: GSColors.purple,),
                  StreamBuilder(
                    stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text(' ${user.buddies.length} buddies', style: TextStyle(color: GSColors.purple),);
                      }

                      int mutualFriends = 0;
                      for(String buddyID in user.buddies) {
                        if (snapshot.data['buddies'].contains(buddyID)) 
                          mutualFriends++;
                      }

                      if (mutualFriends == 0) {
                        return Text(' ${user.buddies.length} buddies', style: TextStyle(color: GSColors.purple),);
                      }

                      //return Text(' $mutualFriends mutual', style: TextStyle(color: GSColors.purple),);
                      return Text(' ${user.buddies.length} buddies', style: TextStyle(color: GSColors.purple),);
                    },
                  )
                ],
              ),
            )
          ),
        ]
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      child: ListView(
        children: <Widget>[
          _buildBio(),
          _buildWeightInfo(),
          _buildMedia(),
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
            bottomLeft: Radius.circular(40),
            topLeft: Radius.circular(40),
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

  Widget _buildMedia() {
    return Container( // 
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: <Widget>[
          Container(  // label
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Text(
                  'Media',
                  style: TextStyle(
                    color: GSColors.darkBlue,
                    fontSize: 20,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  )
                ),
                Text(
                  user.media.length.toString() + ' shots',
                  style: TextStyle(
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          Container( // photo gallery
            margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            child: FutureBuilder(
              future: _listFutureUser,
              builder: (context, snapshot) {
                if(!snapshot.hasData)
                  return Container();

                media = snapshot.data;
                return GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemCount: media.length,
                  itemBuilder: (BuildContext context, int i) {

                  return _buildMediaItem(media[i]);
                  }
                );
              }
            )
          ),
        ],
      ),
    );
  }

   Widget _buildMediaItem(String media) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute<void> (
          builder: (BuildContext context) {
            return ImageWidget(media, context, false);
          },
        )
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Image.network(media).image,
            fit: BoxFit.cover
          ),
          border: Border.all(
            color: GSColors.darkBlue,
            width: 0.5,
          )
        ),
      ),
    );
  }
}