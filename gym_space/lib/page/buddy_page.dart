import 'package:GymSpace/logic/user.dart';
import 'package:GymSpace/page/search_page.dart';
import 'package:GymSpace/widgets/page_header.dart';
import 'package:algolia/algolia.dart';
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
  final GlobalKey<FormState> _buddyKey = GlobalKey<FormState>();

  Future<DocumentSnapshot> _futureUser = DatabaseHelper.getUserSnapshot(DatabaseHelper.currentUserID);
  BuildContext _currentContext;
  
  //Algolia get algolia => DatabaseConnections.algolia;

  Future<void> searchPressed() async {
    User _currentUser;
    await DatabaseHelper.getUserSnapshot(DatabaseHelper.currentUserID).then(
      (ds) => _currentUser = User.jsonToUser(ds.data)
    );

    Navigator.push(_currentContext, MaterialPageRoute(
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
      future: _futureUser,
      builder: (context, snapshot) {
        var userBuddyIDs = snapshot.hasData && snapshot.data['buddies'] != null 
          ? snapshot.data['buddies'] : List();
          buddies = userBuddyIDs.cast<String>();      
    
          return ListView.builder(
            itemCount: userBuddyIDs.length,
            itemBuilder: (BuildContext context, int i) {
              return BuddyWidget(buddies);
            } 
          );
      },
    );
  }
}