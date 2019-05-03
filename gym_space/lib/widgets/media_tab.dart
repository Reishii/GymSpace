import 'package:GymSpace/logic/user.dart';
import 'package:GymSpace/page/nutrition_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:GymSpace/global.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MediaTab extends StatelessWidget {
  BuildContext context;
  String mediaUrl, profileImageUrl;
  List<String> media = [];
  Future<List<String>> _listFutureUser = DatabaseHelper.getCurrentUserMedia();

  MediaTab(this.context, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildMediaLabel(),
        _buildMediaList(context),
        _buildButton(),
      ],
    );
  }

  Widget _buildMediaLabel() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: <Widget>[ 
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 40,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Photos",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                )),
                decoration: ShapeDecoration(
                  color: GSColors.darkBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      topRight: Radius.circular(20)
                    )
                  )
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Column(
      children: <Widget>[
        //DIY floating action button!
        Container(
          alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(top: 15, right: 50),
              height: 40,
              width: 40,
              decoration: ShapeDecoration(
                color: GSColors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
              child: IconButton(
                icon: Icon(FontAwesomeIcons.plus),
                iconSize: 12,
                color: Colors.white,
                onPressed: () {
                  getMediaImage();
                },
              ),
            ),
          ),
        ],
    //),
  //],
    );
  }

  Widget _buildMediaList(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 75, left: 10, right: 10, bottom: 10),
      child: StreamBuilder(
        stream: _listFutureUser.asStream(),
        builder: (context, snapshot) {
          if(!snapshot.hasData)
            return Container();

          media = snapshot.data;
          return GridView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            primary: false,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemCount: media.length,
            itemBuilder: (BuildContext context, int i) {

            return _buildMediaItem(media[i]);
            }
          );
        }
      )
    );
  }

  Widget _buildMediaItem(String media) {
    return InkWell(
      onTap: () => _buildImage(media),
      child: Container(
        decoration: ShapeDecoration(
          shape: CircleBorder(
            side: BorderSide(color: GSColors.darkBlue, width: 1.2)
          )
        ),
        child: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(media, errorListener: () => print('Failed to download')),
          backgroundColor: Colors.white,
          radius: 80,
        ),
      ),
    );
  }

  Widget _buildImage(String media) {
    return Image.network(media, height: 400, width: 400,);
  }

  // *****************************************************************************
  // **************************** UPLOAD A PROFILE PHOTO *************************
  Future<String> getProfileImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    
    if(tempImage != null) {
      final profileImage = tempImage;
      uploadProfileFile(profileImage);   
    }
  }

  Future uploadProfileFile(File profileImage) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);

    StorageUploadTask uploadTask = reference.putFile(profileImage);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;

    await storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      profileImageUrl = downloadUrl;
    }, 

    onError: (err) {
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
        
    Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).updateData({'photoURL' : profileImageUrl });
  }

  // *****************************************************************************
  // ***************************** UPLOAD A NORMAL PHOTO *************************
  Future<String> getMediaImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    
    if(tempImage != null) {
      final mediaImage = tempImage;
      uploadMediaFile(mediaImage);   
    }
  }

  Future uploadMediaFile(File mediaImage) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);

    StorageUploadTask uploadTask = reference.putFile(mediaImage);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;

    await storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      mediaUrl = downloadUrl;
    }, 

    onError: (err) {
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
        
    await DatabaseHelper.getUserSnapshot(DatabaseHelper.currentUserID).then(
      (ds) => ds.reference.updateData({'media': FieldValue.arrayUnion([mediaUrl])})
    );
  }
}
