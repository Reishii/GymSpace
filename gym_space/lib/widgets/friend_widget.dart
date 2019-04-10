import 'package:flutter/material.dart';
import 'package:GymSpace/logic/friend.dart';
import 'package:GymSpace/logic/friend_profile.dart';
import 'package:GymSpace/misc/colors.dart';

class FriendWidget extends StatelessWidget {
  final Widget child;
  final String name;
  final String quote;
  final Image friendAvatar;

  FriendWidget(this.name, this.quote, this.friendAvatar, {Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(top: 20),
      itemCount: 7,
      itemBuilder: (BuildContext context, int i) {
        return Container(
            height: 100,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            decoration: ShapeDecoration(
              color: GSColors.darkBlue,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
              )
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(15.0),
              leading: Icon(Icons.account_balance_wallet),
              title: const Text('Alexandra Eurova'),
              subtitle: const Text('Quote goes here.'),
              onTap: () {
                // Navigator.push(context, MaterialPageRoute<void>(
                //   builder: (context) {
                //     //_buildFriendCard(name, quote, friendAvatar);
                //   }
                // ));
              }, // onTap
            ),
        );
      },

      separatorBuilder: (BuildContext context, int i) {
        return Container(
            height: 100,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            decoration: ShapeDecoration(
              color: GSColors.darkBlue,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
              )
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(15.0),
              leading: Icon(Icons.access_alarm),
              title: const Text('Jacob Manic'),
              subtitle: const Text('Quote goes here.'),
              onTap: () {
                // Navigator.push(context, MaterialPageRoute<void>(
                //   builder: (context) {
                //     //_buildFriendCard(name, quote, friendAvatar);
                //   }
                // ));
              }, // onTap
            ),
        );
      },
    );
  }
  //   return Container(
  //     height: 80,
  //     child: Card(
  //       elevation: 2,
  //       child:InkWell(
  //         onTap: () => _displayFriend(context),
  //         child: Container(
  //           child: Center(
  //             child: Text(
  //               "Chris Pratt",
  //               style: TextStyle(
  //                 letterSpacing: 2,
  //                 fontFamily: 'Roboto',
  //                 fontSize: 20,
  //               )
  //             )
  //           )
  //         )
  //       ),
  //     )
  //   );
  // }

  Widget _buildFriendCard(String name, String quote, Image friendAvatar) {

  }
}