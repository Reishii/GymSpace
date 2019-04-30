import 'package:GymSpace/logic/group.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/page/profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:GymSpace/logic/user.dart';
import 'package:GymSpace/global.dart';

enum SearchType {user, group, workoutplan}

class SearchPage extends StatefulWidget {
  final SearchType searchType;
  final User currentUser;
  final List<Group> groups;
  
  SearchPage({
    this.searchType,
    this.currentUser,
    this.groups,
    Key key,
  }) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchType get searchType => widget.searchType;
  List<String> get friends => widget.currentUser.buddies;
  List<Group> get groups => widget.groups;
  bool _isEditing = true;

  TextEditingController _searchController = TextEditingController();
  List<User> usersFound = List();
  List<int> groupsFound = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: AppDrawer(),
      appBar: _buildAppBar(),
      body: _isEditing ? Container() : _buildResults(),
    );
  }

  void _search(String text) async {
    usersFound.clear();
    groupsFound.clear();
    
    switch (searchType) {
      case SearchType.user:
        usersFound = _searchController.text.isEmpty ? List() : await DatabaseHelper.searchDBForUserByName(_searchController.text);
        break;
      case SearchType.group:
        int i = 0;
        for (i; i < groups.length; i++) {
          if (groups[i].name.contains(text)) {
            groupsFound.add(i);
          }
        }

        break;
      default:
    }

    setState(() {
      _isEditing = false;
    });
  }

  Widget _buildAppBar() {
    return AppBar(
      // backgroundColor: GSColors.rand,
      title: Container(
        child: TextField(
          autofocus: true,
          controller: _searchController,
          textCapitalization: TextCapitalization.words,
          onTap: () {
            setState(() {
              _isEditing = true;
            });
          },
          onChanged: (_) {       
            setState(() {
              _isEditing = true;
            });
          },
          onEditingComplete: () => _search(_searchController.text),
          style: TextStyle(
            color: Colors.white
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: searchType == SearchType.user ? 'Enter either First name or Last name' : 'Enter name of group',
            hintStyle: TextStyle(
              color: Colors.white54,
            ),
            suffixIcon: IconButton(
              color: Colors.white54,
              icon: Icon(Icons.clear),
              onPressed: () => _searchController.clear(),
            )
          ),
        ),
      ),
    );
  }

  Widget _buildResults() {
    switch (searchType) {
      case SearchType.user:
        return _buildResultsUsers();
        break;
      case SearchType.group:
        return _buildResultsGroups();
        break;
      default:
        return Container();
    }
  }

  Widget _buildResultsUsers() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: ListView.builder(
        itemCount: usersFound.length,
        itemBuilder: (context, i)  {
          if (usersFound[i].documentID == DatabaseHelper.currentUserID) {
            return Container();
          }
          User user = usersFound[i];
          int mutualFriends = 0;
          user.buddies.forEach((potentialFriend) {
            if (friends.contains(potentialFriend)) {
              mutualFriends++;
            }
          });

          return Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: ShapeDecoration(
              color: GSColors.darkBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              )
            ),
            child: InkWell(
              onTap: () {_buildProfile(user);},
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child:Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: ShapeDecoration(
                          shape: CircleBorder(
                            side: BorderSide(
                              width: 2,
                              color: Colors.white
                            )
                          )
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.symmetric(horizontal: 50), // only way I found to get circle avatar right
                        child: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            user.photoURL.isNotEmpty ? user.photoURL : Defaults.photoURL,
                          ),
                          radius: 30,
                        ),
                      //   child: Container(
                      //     height: 60,
                      //     width: 30,
                      //     decoration: BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       image: DecorationImage(
                      //         fit: BoxFit.fill,
                      //         image: CachedNetworkImageProvider(user.photoURL)
                      //       )
                      //     ),
                      //   ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                          Text(
                            user.buddies.contains(DatabaseHelper.currentUserID) ? 'Buddies' : '   $mutualFriends mutual buddies',
                            style: TextStyle(
                              color: Colors.white54,
                            ),
                          )
                        ],
                      )
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultsGroups() {
    return Container(
      child: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: _buildFoundGroups(), 
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Container()
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFoundGroups() {
    bool foundGroup = groupsFound.isNotEmpty;
    
    return <Widget>[
      foundGroup ?
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Found ${groupsFound.length} Groups',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2
            ),
          )
        ) : Container(),
    ];
  }

  List<Widget> _buildAllGroups() {
    List<Widget> groupItems = List();
    groups.forEach((group) { 
      groupItems.add(_buildGroupItem(group));
    });

    return groupItems;
  }

  Widget _buildGroupItem(Group group) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: ShapeDecoration(
        color: GSColors.darkBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        )
      ),
      child: InkWell(
        onTap: () {_buildProfile(user);},
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child:Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  decoration: ShapeDecoration(
                    shape: CircleBorder(
                      side: BorderSide(
                        width: 2,
                        color: Colors.white
                      )
                    )
                  ),
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(horizontal: 50), // only way I found to get circle avatar right
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      user.photoURL.isNotEmpty ? user.photoURL : Defaults.photoURL,
                    ),
                    radius: 30,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    Text(
                      user.buddies.contains(DatabaseHelper.currentUserID) ? 'Buddies' : '   $mutualFriends mutual buddies',
                      style: TextStyle(
                        color: Colors.white54,
                      ),
                    )
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _buildProfile(User user) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ProfilePage.fromUser(user)
    ));
  }
}