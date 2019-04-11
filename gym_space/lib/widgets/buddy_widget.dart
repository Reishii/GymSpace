import 'package:flutter/material.dart';
import 'package:GymSpace/global.dart';
import 'package:GymSpace/logic/buddy.dart';
import 'package:GymSpace/misc/colors.dart';

class BuddyWidget extends StatelessWidget {
  final Widget child;
  final String _buddyName;
  final String _buddyQuote;
  final Image _buddyAvatar;

  BuddyWidget(this._buddyName, this._buddyQuote, this._buddyAvatar, {Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(top: 20),
      itemCount: 3,
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
              title: Text(_buddyName),
              subtitle: Text(_buddyQuote),
              onTap: () {
                // Navigator.push(context, MaterialPageRoute<void>(
                //   builder: (context) {
                //     //_buildBuddyCard(name, quote, BuddyAvatar);
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
                //     //_buildBuddyCard(name, quote, BuddyAvatar);
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
  //         onTap: () => _displayBuddy(context),
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

  Widget _buildBuddyCard(String name, String quote, Image buddyAvatar) {

  }
}