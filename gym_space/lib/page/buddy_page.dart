import 'package:GymSpace/logic/user.dart';
import 'package:GymSpace/page/search_page.dart';
import 'package:GymSpace/widgets/page_header.dart';
import 'package:algolia/algolia.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:GymSpace/widgets/buddy_widget.dart';
import 'package:GymSpace/logic/buddy_preview.dart';
import 'package:GymSpace/page/buddy_profile_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:GymSpace/global.dart';
import 'package:GymSpace/database.dart';

class BuddyPage extends StatefulWidget {
  final Widget child;

  BuddyPage({Key key, this.child}) : super(key: key);
  _BuddyPageState createState() => _BuddyPageState();
}

class _BuddyPageState extends State<BuddyPage> {
  List<String> buddies =  [];
  final TextEditingController _searchController = TextEditingController();

  Future<List<String>> _listFutureUser = DatabaseHelper.getCurrentUserBuddies();
  bool _isFriend = false;
  
  //Algolia get algolia => DatabaseConnections.algolia;

  Future<void> searchPressed() async {
    User _currentUser;
    await DatabaseHelper.getUserSnapshot(DatabaseHelper.currentUserID).then(
      (ds) => _currentUser = User.jsonToUser(ds.data)
    );

    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return SearchPage(searchType: SearchType.user, currentUser: _currentUser,);
      } 
    ));
    // showDialog(
    //   context: _currentContext,
    //   builder: (context) {
    //     return SimpleDialog(
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(20)
    //       ),
    //       children: <Widget>[
    //         Container( // search
    //           margin: EdgeInsets.symmetric(horizontal: 20),
    //           child: TextField(
    //             controller: _searchController,
    //             decoration: InputDecoration(
    //               labelText: 'Search First Name',
    //               hintText: 'Jane',
    //             ),
    //             onEditingComplete: () async {
    //               print('...Searching for: ${_searchController.text}');
    //               await _searchDBForUser(_searchController.text);
    //             },
    //           ),
    //         ),

    //       ],
    //     );
    //   }
    // );
  }

  Future<List<User>> _searchDBForUser(String name) async {
    Query firstNameQuery = Firestore.instance.collection('users')
      .where('firstName', isEqualTo: name);
    
    QuerySnapshot querySnapshot = await firstNameQuery.getDocuments();
    List<User> foundUsers = List();
    querySnapshot.documents.forEach((ds) {
      User user = User.jsonToUser(ds.data);
      user.documentID = ds.documentID;
      foundUsers.add(user);
    });
    
    return foundUsers;
  }

  // Future<void> testSearch(String name) async {
  //   AlgoliaQuery searchQuery = algolia.instance.index('users').search('Jane');
  //   var snap = await searchQuery.getObjects();
  //   print('# of hits: ${snap.hits}');
  //   List<AlgoliaObjectSnapshot> s = snap.hits;
  //   s.forEach((object) {
  //     print(object.data);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(startPage: 4,),
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBuddyBackground(),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: PageHeader(
        title: 'Buddies', 
        backgroundColor: GSColors.darkBlue, 
        showDrawer: true,
        titleColor: Colors.white,
        showSearch: true,
        searchFunction: searchPressed,
      )
    );  
  }

Widget _theBackground() {
  return Container(
    height: (150 * 50.0),
    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    decoration: ShapeDecoration(
      color: GSColors.darkBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
    ),
  );
}

  Widget _buildBuddyBackground() {
    return Stack(
      children: <Widget>[
        _theBackground(),
        Container(
          child: _buildBuddyList(),
        ),
      ]
    );
  }

  Widget _buildBuddyList() {
    return FutureBuilder(
      future: _listFutureUser,
      builder: (context, snapshot) {
        if(!snapshot.hasData) 
          return Container();
               
        buddies = snapshot.data;
        print(buddies[1].toString());
        return ListView.builder(
          itemCount: buddies.length,
          itemBuilder: (BuildContext context, int i) {
            //return BuddyWidget(buddies);
            return StreamBuilder(
              stream: DatabaseHelper.getUserStreamSnapshot(buddies[i]),
              builder: (context, snapshot) {
                if(!snapshot.hasData)
                  return Container();

                User user = User.jsonToUser(snapshot.data.data);
                return _buildBuddy(user);
              },
            );
          }, 
        );
      },
    );
  }

  Widget _buildBuddy(User user) {
    return Container(
        height: 90,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: ShapeDecoration(
          color: GSColors.darkCloud,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          )
        ),
          child: Center(
            child: ListTile(
              leading: Container(
              //margin: EdgeInsets.only(left: 20),
                decoration: ShapeDecoration(
                  shape: CircleBorder(
                    side: BorderSide(color: Colors.black, width: 1.2),
                  )
                ),
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(user.photoURL.isEmpty ? Defaults.photoURL : user.photoURL, errorListener: () => print('Failed to download')),
                  radius: 27,
                ),
              ),
          
              title: Text(
                '${user.firstName} ${user.lastName}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: GSColors.darkBlue,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  ),
                ),

              subtitle: Text(
                '${user.liftingType}',
                //snapshot.hasData ? snapshot.data['buddies'].data['bio'] : "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 16,
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
          ),
      );
  }
}