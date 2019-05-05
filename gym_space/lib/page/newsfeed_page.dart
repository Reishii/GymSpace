import 'dart:async';
import 'dart:io';
import 'package:GymSpace/logic/image_input_adapter.dart';
import 'package:image_form_field/image_form_field.dart';
import 'package:flutter/material.dart';
import 'package:GymSpace/global.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/page_header.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class NewsfeedPage extends StatefulWidget {
  @override
  _NewsfeedPageState createState() => _NewsfeedPageState();
}

class _NewsfeedPageState extends State<NewsfeedPage> {
  String get currentUserID => DatabaseHelper.currentUserID;
  bool _isCreatingPost = false;

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: Container(
        color: GSColors.darkBlue,
        child: PageHeader(
          title: "Newsfeed",
          backgroundColor: GSColors.darkBlue,
          showDrawer: true,
          titleColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return LiquidPullToRefresh(
      onRefresh: _refresh,
      color: GSColors.darkBlue,
      backgroundColor: Colors.white,
      child: ListView(
        children: <Widget>[
        ],
      )
    );
  }

  Future<void> _refresh() {
    Completer<void> completer = Completer();
    completer.complete();
    return completer.future;
  }

  void _fetchPosts() {

  }

  void _addPressed() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildPostContainer()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: AppDrawer(startPage: 0,),
      body: _buildBody(),
      floatingActionButton: FlatButton.icon(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: GSColors.green,
        label: Text('Add Post'),
        textColor: Colors.white,
        icon: Icon(Icons.add_circle,),
        onPressed: _addPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget _buildPostContainer() {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: Duration(milliseconds: 100),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'What do you want to share?',
              ),
            ),
            ImageFormField<ImageInputAdapter>(
              buttonBuilder: (context, i) {
                return Container(
                  // margin: EdgeInsets.,
                  child: Icon(Icons.add_a_photo),
                );
              },
              previewImageBuilder: (context, image) {
                return Container(
                  constraints: BoxConstraints.tight(Size.square(200)),
                  child: image.toImageWidget(),
                );
              },
              initializeFileAsImage: (File file) => ImageInputAdapter(imageFile: file),
              // initialValue: ,
            )
          ],
        ),
      ),
    );
  }

  // Widget _
}