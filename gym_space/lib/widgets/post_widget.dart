import 'package:GymSpace/global.dart';
import 'package:GymSpace/logic/post.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostWidget extends StatefulWidget {
  final Post post;

  PostWidget({
    @required this.post,
    Key key}) : super(key: key);

  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  Post get post => widget.post;
  

  Widget _buildPostHeading() {
    return Container(
      child: FutureBuilder(
        future: DatabaseHelper.getUserSnapshot(post.fromUser),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircleAvatar(
              child: Image.asset(Defaults.userPhoto),
            );
          }
          Map<String, dynamic> user = snapshot.data.data;

          return Container(
            child: ListTile(
              // contentPadding: EdgeInsets.only(left: 120),
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: user['photoURL'].isNotEmpty ? CachedNetworkImageProvider(user['photoURL'])
                : AssetImage(Defaults.userPhoto),
              ),
              title: Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  '${user['firstName']} ${user['lastName']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  '${DateFormat('h:mm a MMM d').format(post.uploadTime.toDate())}',
                  style: TextStyle(color: Colors.black38),
                ),
              ),
            ),
          );
        },
      )
    );
  }

  Widget _buildPostContent() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(post.body)
          ),
          post.mediaURL.isNotEmpty ? 
            FlatButton(
              onPressed: (){},
              child: Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      topRight: Radius.circular(20)
                    ),
                  ),
                ),
                child: CachedNetworkImage(
                  imageUrl: post.mediaURL,
                  fit: BoxFit.cover,
                ),    
              ),
            )
          : Container(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      child: Container(
        // margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            _buildPostHeading(),
            _buildPostContent(),
          ],
        )
      ),
    );
  }
}