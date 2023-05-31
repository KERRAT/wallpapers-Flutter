import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class DisplayPhoto extends StatefulWidget {
  final int photoId;
  final String lng;

  const DisplayPhoto(
      {Key? key,
      required this.photoId,
      required this.lng})
      : super(key: key);

  @override
  DisplayPhotoState createState() => DisplayPhotoState();
}

class DisplayPhotoState extends State<DisplayPhoto> {
  String imageUrl;
  final Logger _logger = Logger('DisplayPhoto');


  DisplayPhotoState() : imageUrl = '';

  @override
  void initState() {
    super.initState();
    imageUrl =
    'http://cf-phonewall4k.com/wallpapers/y_540/${widget.photoId}.jpg';
    _logger.info('Image URL initialized: $imageUrl');
  }

  void updateImageUrl(String newUrl) {
    setState(() {
      imageUrl = newUrl;
    });
    _logger.info('Image URL updated: $imageUrl');
  }


  @override
  Widget build(BuildContext context) {
    _logger.info('Building DisplayPhoto widget');
    final screenSize = MediaQuery
        .of(context)
        .size;

    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            width: screenSize.width,
            height: screenSize.height,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}