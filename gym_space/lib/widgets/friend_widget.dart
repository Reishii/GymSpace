import 'package:flutter/material.dart';
import 'package:GymSpace/logic/friend.dart';
import 'package:GymSpace/logic/friend_profile.dart';
import 'package:GymSpace/misc/colors.dart';

class FriendWidget extends StatelessWidget {
  final Friend _friend;

  FriendWidget(this._friend, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Card(
        elevation: 2,
        child:InkWell(
          onTap: () => _displayFriend(context),
          child: Container(
            child: Center(
              child: Text(
                "Chris Pratt",
                style: TextStyle(
                  letterSpacing: 2,
                  fontFamily: 'Roboto',
                  fontSize: 20,
                )
              )
            )
          )
        ),
      )
    );
  }

  void _displayFriend(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        //builder: (context) => FriendProfilePage(_friend)
      )
    );
  }

  List<Widget> _buildFriends() {
     List<Widget> friends = new List();

    return friends;
  }
}

