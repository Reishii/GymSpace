import 'package:GymSpace/global.dart';
import 'package:GymSpace/logic/group.dart';
import 'package:GymSpace/logic/user.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/page/profile_page.dart';
import 'package:GymSpace/widgets/page_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GroupMembersPage extends StatelessWidget {
  final Group group;
  final List<User> members;
  
  const GroupMembersPage({
    @required this.group,
    @required this.members,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: PageHeader(
        backgroundColor: GSColors.darkBlue,
        title: '${members.length} Members',
        titleColor: Colors.white,
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: ShapeDecoration(
        color: GSColors.darkBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60)
        )
      ),
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: GridView.builder(
          itemCount: members.length,
          itemBuilder: (context, i) {
            return MaterialButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) => ProfilePage.fromUser(members[i])
              )),
              child: Container(
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        members[i].photoURL.isEmpty ? Defaults.photoURL : members[i].photoURL
                      ),
                    ),
                    Divider(color: Colors.transparent,),
                    Text(
                      '${members[i].firstName} ${members[i].lastName}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withAlpha(200),
                        letterSpacing: 1.2
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
        ),
      ),
    );
  }
}