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

          child: Center(
            child: ListTile(
              contentPadding: EdgeInsets.all(15.0),
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage("https://media.npr.org/assets/img/2019/01/10/dlevy.hs2_wide-f6f2f772b1588e73ecdece6b0fb3dff127aa8e3a-s800-c85.jpg"),
              ),

              title: Text(
                _buddyName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  ),
                ),

              subtitle: Text(
                _buddyQuote,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 15,
                  ),
                ),

              onTap: () {
                // Navigator.push(context, MaterialPageRoute<void>(
                //   builder: (context) {
                //     //_buildBuddyCard(name, quote, BuddyAvatar);
                //   }
                // ));
              }, // onTap
            ),
          )
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
          
          child: Center(
            child: ListTile(
              //contentPadding: EdgeInsets.only(right: 15),
              title: const Text(
                'Patrick Brewer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: const Text(
                "You're simply the best.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 15,
                ),
              ),

              trailing: new Container(
                padding: EdgeInsets.only(right: 5.0),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage("https://www.cbc.ca/schittscreek/content/images/people/noah-s5.jpg"),
                ),
              ),

              onTap: () {
                // Navigator.push(context, MaterialPageRoute<void>(
                //   builder: (context) {
                //     //_buildBuddyCard(name, quote, BuddyAvatar);
                //   }
                // ));
              }, // onTap
            ),
          )
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