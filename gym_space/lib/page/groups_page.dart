import 'package:GymSpace/global.dart';
import 'package:GymSpace/logic/group.dart';
import 'package:GymSpace/page/group_profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:GymSpace/widgets/page_header.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:GymSpace/widgets/page_header.dart';

class GroupsPage extends StatelessWidget {
  final Widget child;

  GroupsPage({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(startPage: 4),
      // backgroundColor: GSColors.olive,
      appBar: _buildAppBar(),
      // body: _buildGroupBackground(),
      body: _buildBody(context),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: PageHeader(
        title: 'Your Groups',
        backgroundColor: GSColors.darkBlue,
        showDrawer: true,
        showSearch: true,
        titleColor: Colors.white,
      )
    );
  }


  Widget _buildBody(BuildContext context) {
    return Container(
      // color: Colors.white
      child: FutureBuilder(
        future: DatabaseHelper.getCurrentUserGroups(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, i) {
              return StreamBuilder(
                stream: DatabaseHelper.getGroupStreamSnapshot(snapshot.data[i]),
                builder: (context, groupSnap) {
                  if (!groupSnap.hasData) {
                    return Container();
                  }
                  Group joinedGroup = Group.jsonToGroup(groupSnap.data.data);
                  joinedGroup.documentID = groupSnap.data.documentID;
                  return _buildGroupItem(joinedGroup, context);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildGroupItem(Group group, context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: ShapeDecoration(
        color: GSColors.darkBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        )
      ),
      child: InkWell(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text( // name
                group.name,
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              _buildMembersList(group.members),
              Container(
                child: FutureBuilder(
                  future: DatabaseHelper.getUserSnapshot(group.admin),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Instructed by ${snapshot.data['firstName']} ${snapshot.data['lastName']}',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12
                          ),
                        ),
                        Container(
                          child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(snapshot.data['photoURL'].isNotEmpty ? snapshot.data['photoURL'] : Defaults.photoURL),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (context) => GroupProfilePage(group: group,) 
          )
        ),
      ),
    );
  }

  Widget _buildMembersList(List<String> members) {
    List<Widget> memberIcons = List();
    for(int i = 0; i < members.length; i++) {
      memberIcons.add(
        FutureBuilder(
          future: DatabaseHelper.getUserSnapshot(members[i]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            
            return Positioned(
                left: (30.0 * i),
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  decoration: ShapeDecoration(
                    shape: CircleBorder(
                    side: BorderSide(color: Colors.white, width: 1.5),
                  )
                ),
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(snapshot.data['photoURL']),
                  radius: 20,
                ),
              ),
            );
          }
        ),
      );

      if (i == 8) {
        break;
      }
    }

    if (members.length > 8) {
      memberIcons.add(
        Positioned(
          right: 20,
          child: Container(
            child: CircleAvatar(
              backgroundColor: GSColors.purple,
              radius: 20 + 1.5,
              child: Text(
                '+37',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      height: 50,
      child: Stack(
        children: memberIcons,
      ),
    );
  }

  Widget _buildGroupBackground() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 20),
      itemCount: 5,
      itemBuilder: (BuildContext context, int i) {
        return Container(
          height: 200, 
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (context) {
                  //_buildGroupProfile();
                }
              ));
            }
          ),
        );
      }
    );
  }

}