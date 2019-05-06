import 'dart:async';
import 'dart:io';
import 'package:GymSpace/logic/image_input_adapter.dart';
import 'package:GymSpace/logic/post.dart';
import 'package:GymSpace/widgets/post_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_form_field/image_form_field.dart';
import 'package:flutter/material.dart';
import 'package:GymSpace/global.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/page_header.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:photo_view/photo_view.dart';

class NewsfeedPage extends StatefulWidget {
  @override
  _NewsfeedPageState createState() => _NewsfeedPageState();
}

class _NewsfeedPageState extends State<NewsfeedPage> {
  bool _addedPhoto = false;
  List<Widget> _fetchedPosts = List();
  bool _fetchingPosts = false;
  bool _isCreatingPost = false;
  String _uploadBody = '';
  File _uploadImage;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  String get currentUserID => DatabaseHelper.currentUserID;

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
      onRefresh: _fetchPosts,
      color: GSColors.darkBlue,
      backgroundColor: Colors.white,
      child: _fetchingPosts ? ListView(
        children: <Widget>[
          Container (
            alignment: Alignment.topCenter,
            child: Text(
              'Updating...',
              style: TextStyle(
                color: Colors.black,
                fontSize: 30
              ),
            ),
          )
        ],
      )
      : ListView.builder(
        itemCount: _fetchedPosts.length,
        itemBuilder: (context, i) {
          return _fetchedPosts[i];
        },
      ),
    );
  }

  Future<void> _fetchPosts() async {
    setState(() {
      print('Fetching posts...');
      _fetchingPosts = true;
    });
    
    DatabaseHelper.fetchPosts().then((posts) {
      setState(() {
        print('Fetched ${posts.length} posts');
        if (posts.isNotEmpty) 
          _fetchedPosts.clear();
        // build each post
        posts.sort((String a, String b) => int.parse(a).compareTo(int.parse(b)));
        for (String postID in posts.reversed) { // build the post 
          _fetchedPosts.add(_buildPost(postID));
        }
        // _fetchedPosts = posts;
        // _fetchedPosts.sort()
        _fetchingPosts = false;
      });
    });
  }

  void _addPressed() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildPostContainer()
    );
  }

  Widget _buildPost(String postID) {
    return Container(
      child: StreamBuilder(
        stream: DatabaseHelper.getPostStream(postID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } 
          
          if (!snapshot.hasData) 
            return Container();

          Post post = Post.jsonToPost(snapshot.data.data);
          post.documentID = snapshot.data.documentID;
          
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: PostWidget(post: post,),
          );
        },
      ),
    );
  }

  Widget _buildPostContainer() {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: Duration(milliseconds: 1),
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 40, bottom: 10),
        child: TextField(
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          maxLines: null,
          onChanged: (text) => _uploadBody = text,
          decoration: InputDecoration(
            labelText: 'What do you want to share?',
            icon: Hero(
              tag: 'postImage',
              child: IconButton(
                onPressed: _uploadImage == null ? _addPhoto : _uploadImagePressed,
                icon: _uploadImage != null ? Image.file(_uploadImage,height: 100, width: 100,) 
                : Icon(Icons.add_photo_alternate, color: GSColors.yellow,),
              ),
            ),
            suffixIcon: Container(
              child: FlatButton(
                child: Text(
                  'Post',
                  style: TextStyle(
                    fontSize: 18,
                    color: GSColors.lightBlue
                  ),
                ),
                onPressed: _uploadPost,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _uploadPost() async {
    if (_uploadBody.isEmpty && _uploadImage == null) {
      Navigator.pop(context);
      return;
    }

    Post newPost = Post(
      body: _uploadBody,
      fromUser: currentUserID,
    );

    // upload image to db
    if (_uploadImage != null) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = reference.putFile(_uploadImage);
      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;

      await storageTaskSnapshot.ref.getDownloadURL().then((downloadURL) {
        newPost.mediaURL = downloadURL;
        print('photo url: $downloadURL');
      }).catchError((e) => Fluttertoast.showToast(msg: 'This file is not an image'));
    }

    // now upload post to db
    await Firestore.instance.collection('posts').document(DateTime.now().millisecondsSinceEpoch.toString()).setData(newPost.toJSON()).then((_) {
      setState(() {
        _uploadBody = '';
        _uploadImage = null;
        Navigator.pop(context);
      });
    });
  }

  Future<void> _addPhoto() async {
    _uploadImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_uploadImage == null) {
      _addedPhoto = false;
      return;
    }

    setState(() => _addedPhoto = true);
  }

  void _uploadImagePressed() {
    showMenu(
      context: context, 
      items: [
        PopupMenuItem(
          child: Container(
            child: FlatButton.icon(
              textColor: GSColors.red,
              icon: Icon(Icons.remove, color: GSColors.red,),
              label: Text('Remove'),
              onPressed: _removeUploadImage,
            ),
          ),
        ),
        PopupMenuItem(
          child: Container(
            child: FlatButton.icon(
              textColor: GSColors.lightBlue,
              icon: Icon(Icons.add_photo_alternate, color: GSColors.lightBlue,),
              label: Text('Choose different image'),
              onPressed: () => _addPhoto().then((_) => Navigator.pop(context)),
            ),
          ),
        ),
        PopupMenuItem(
          child: Container(
            child: FlatButton.icon(
              textColor: GSColors.green,
              icon: Icon(FontAwesomeIcons.image, color: GSColors.green),
              label: Text('View'),
              onPressed: _viewImage,
            ),
          ),
        )
      ],
      position: RelativeRect.fromLTRB(0, double.infinity, 0, 0)
      
    );
  }

  void _viewImage() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => HeroPhotoView(imageProvider: FileImage(_uploadImage))
    )).then((_) => Navigator.pop(context));
  }

  void _removeUploadImage() {
    setState(() {
      print('removing photo');
      _addedPhoto = false;
      _uploadImage = null;
      Navigator.pop(context);
    });
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
}

class HeroPhotoView extends StatelessWidget {
  const HeroPhotoView({
    @required this.imageProvider,
    Key key}) : super(key: key);

  final ImageProvider imageProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
        initialScale: .1,
        imageProvider: imageProvider,
        heroTag: 'postImage',
      )
    );
  }
}