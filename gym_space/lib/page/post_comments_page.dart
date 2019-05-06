import 'package:GymSpace/global.dart';
import 'package:GymSpace/logic/post.dart';
import 'package:GymSpace/logic/user.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/page/profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostCommentsPage extends StatefulWidget {
  final String postID;

  PostCommentsPage({
    @required this.postID,
    Key key}) : super(key: key);

  _PostCommentsPageState createState() => _PostCommentsPageState();
}

class _PostCommentsPageState extends State<PostCommentsPage> {
  String get postID => widget.postID;
  String comment = '';
  bool _isLoading = false;

  Map<String, dynamic> comments = Map();

  Widget _buildComments() {
    return Container(
      child: StreamBuilder(
        stream: DatabaseHelper.getPostStream(postID),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          comments = snapshot.data.data['comments'].cast<String,dynamic>();
          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, i) {
              List<String> loadComment = comments[comments.keys.toList()[i]].cast<String>().toList();
              return _buildComment(loadComment);
            },
          );
        },
      ),
    );
  }

  Widget _buildComment(List<String> loadComment) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: FutureBuilder(
        future: DatabaseHelper.getUserSnapshot(loadComment[0]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircleAvatar();
          }

          User user = User.jsonToUser(snapshot.data.data);
          user.documentID = snapshot.data.documentID;

          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: IconButton(
                  icon: CircleAvatar(
                    backgroundImage: user.photoURL.isNotEmpty ? CachedNetworkImageProvider(user.photoURL)
                      : AssetImage(Defaults.userPhoto),
                  ),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ProfilePage.fromUser(user)
                  )),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: ShapeDecoration(
                  color: GSColors.cloud,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        user.firstName + ' ' + user.lastName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        loadComment[1],
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                onChanged: (text) => comment = text,
                maxLines: null,
                style: TextStyle(color: GSColors.darkBlue, fontSize: 16),
                decoration: InputDecoration.collapsed(
                  hintText: 'Add a comment',
                  hintStyle: TextStyle(color: GSColors.darkCloud)
                ),
              ),
            ),
          ),
          Container(
            child: IconButton(
              icon: Icon(Icons.send, color: GSColors.lightBlue),
              onPressed: _sendPressed,
            )
          )
        ],
      ),
    );
  }

  Future<void> _sendPressed() async {
    if (comment.isEmpty) {
      return;
    }

    String time = Timestamp.now().millisecondsSinceEpoch.toString();
    comments[time] = [DatabaseHelper.currentUserID, comment];
    await DatabaseHelper.updatePost(postID, {'comments': comments}).then((_) {
      print('Commented: $comment');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Flexible(
                child: _buildComments(),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: _buildInput()
              ),
            ],
          )
        ],
      ),
    );
  }
}