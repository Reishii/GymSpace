import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/page/profile_page.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:GymSpace/widgets/page_header.dart';
import 'package:flutter/material.dart';
import 'package:GymSpace/logic/user.dart';
// import 'package:GymSpace/logic/group.dart';
import 'package:GymSpace/global.dart';

enum SearchType {user, group, workoutplan}

class SearchPage extends StatefulWidget {
  final SearchType searchType;
  final User currentUser;
  
  SearchPage({
    this.searchType,
    this.currentUser,
    Key key,
  }) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchType get searchType => widget.searchType;
  List<String> get friends => widget.currentUser.buddies;
  bool _isEditing = true;

  TextEditingController _searchController = TextEditingController();
  List<User> usersFound = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: AppDrawer(),
      appBar: _buildAppBar(),
      body: _isEditing ? Container() : _buildResultsUsers(),
    );
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
          onEditingComplete: () async {
            usersFound = _searchController.text.isEmpty ? List() : await DatabaseHelper.searchDBForUserByName(_searchController.text);
            setState(() {
              _isEditing = false;
            });
          },
          style: TextStyle(
            color: Colors.white
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter either First name or Last name',
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

    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: AppBar(
        backgroundColor: Colors.white,
      ),
    );
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
                            user.buddies.contains(DatabaseHelper.currentUserID) ? '   Your Friend' : '   $mutualFriends mutual friends',
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

  void _buildProfile(User user) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ProfilePage.fromUser(user)
    ));
  }
}