import 'package:GymSpace/logic/user.dart';
import 'package:GymSpace/page/search_page.dart';
import 'package:GymSpace/widgets/page_header.dart';
import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:GymSpace/widgets/buddy_widget.dart';
import 'package:GymSpace/page/buddy_profile_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:GymSpace/global.dart';
import 'package:GymSpace/database.dart';

class BuddyPage extends StatelessWidget {
  final Widget child;
  List<String> buddies = [];
  // final TextEditingController _searchController = TextEditingController();
  BuildContext _currentContext;
  BuddyPage({Key key, this.child}) : super(key: key);
  Algolia get algolia => DatabaseConnections.algolia;

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

  Future<void> testSearch(String name) async {
    AlgoliaQuery searchQuery = algolia.instance.index('users').search('Jane');
    var snap = await searchQuery.getObjects();
    print('# of hits: ${snap.hits}');
    List<AlgoliaObjectSnapshot> s = snap.hits;
    s.forEach((object) {
      print(object.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    _currentContext = context;
    return Scaffold(
      drawer: AppDrawer(startPage: 4,),
      backgroundColor: GSColors.blue,
      appBar: _buildAppBar(),
      body: _buildBuddyBackground(),
      );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: PageHeader(
        title: 'Buddies', 
        backgroundColor: Colors.white, 
        showDrawer: true,
        titleColor: GSColors.darkBlue,
        showSearch: true,
        searchFunction: searchPressed,
      )
    );  
  }

  Widget _buildBuddyBackground() {
    return Stack(
      children: <Widget>[
        _whiteBackground(),

        // Meant to be scalable
        // Plan to insert a List<BuddyWidget> that takes the itemCount.length of your buddies as input to show how many to print
        BuddyWidget(
          'David Rose',
          "I'm the leading man",
          Image.asset('assets/gymspace_logo.png'),
        ),
      ]
    );
  }

Widget _whiteBackground() {
  return Container(
    height: (150 * 7.0),
    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    decoration: ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
    ),
  );
}

  Widget _buildBuddyProfile() {
    return Scaffold(

    );
  }
}