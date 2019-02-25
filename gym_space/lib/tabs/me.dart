import 'package:flutter/material.dart';
import 'widget_tab.dart';
import 'package:GymSpace/widgets/profile_widget.dart';
import 'package:GymSpace/logic/profile_data.dart';
import 'package:GymSpace/logic/user.dart';
import 'package:GymSpace/test_users.dart';

class MeTab extends WidgetTab {
  final ProfileData _me = ProfileData(
    forUser: rolly,
    profilePic: 'https://cdn.pixabay.com/photo/2016/12/13/16/17/dancer-1904467_960_720.png',
    description: 'Just a normal guy trying to make some gains',
    quote: 'They hate us cause they ain\'t us'
  );

  MeTab(String title) : super(title, mainColor: Colors.green) {
    _me.setAvatarImage(
      'https://cdn.pixabay.com/photo/2016/12/13/16/17/dancer-1904467_960_720.png'
    );
  }

  @override
  Widget build(BuildContext context) {
    return Profile(profileData: _me,);
  }
}
