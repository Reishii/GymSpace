import 'package:GymSpace/misc/colors.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String media;
  final BuildContext context;
  ImageWidget(this.media, this.context, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GSColors.darkCloud,
      appBar: _buildAppBar(),
      body: _buildImage(),
      bottomNavigationBar: BottomAppBar(
        color: GSColors.darkBlue,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget> [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: GSColors.babyPowder,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.share,
              color: GSColors.babyPowder,
              size: 26,
            ),
            onPressed: () {},
            ),
          ],
        ),
      )
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: GSColors.darkBlue,
      iconTheme: IconThemeData(color: GSColors.purple),
      leading: IconButton(
        icon: Icon(
          Icons.keyboard_arrow_left, 
          color: Colors.white, 
          size: 32,
        ),
        onPressed: () {Navigator.pop(context);},
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(GSColors.darkBlue), 
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Image.network(media),
          ),
        ],
    );
  }
}