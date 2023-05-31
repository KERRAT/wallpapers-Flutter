import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/widgets/responsive_layout.dart';
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
    double aspectRatio = LayoutHelpers.getAspectRatio(context);
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    // Calculate the padding based on the screen size
    final paddingHorizontal = screenWidth * 0.015;

    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: Image.network(imageUrl)
                ),
              );

        },
      ),
    );
  }
}
