import 'package:flutter/material.dart';
// import 'package:GymSpace/global.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/page_header.dart';


class NewsfeedPage extends StatefulWidget {
  @override
  _NewsfeedPageState createState() => _NewsfeedPageState();
}

class _NewsfeedPageState extends State<NewsfeedPage> {
  // String currentUserID =  DatabaseHelper.getCurrentUserID();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: AppDrawer(startPage: 0,),
      backgroundColor: GSColors.cloud,
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: PageHeader(
        title: "Newsfeed",
        backgroundColor: GSColors.darkBlue,
        showDrawer: true,
        titleColor: Colors.white,
      ),
    );
  }
}