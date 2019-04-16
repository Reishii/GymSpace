import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:GymSpace/widgets/page_header.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:GymSpace/widgets/page_header.dart';

class GroupPage extends StatelessWidget {
  final Widget child;

  GroupPage({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(startPage: 3),
      backgroundColor: GSColors.blue,
      appBar: _buildAppBar(),
      body: _buildGroupBackground(),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: PageHeader(
        title: 'Groups',
        backgroundColor: Colors.white,
        showDrawer: true,
        titleColor: GSColors.darkBlue,
      )
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