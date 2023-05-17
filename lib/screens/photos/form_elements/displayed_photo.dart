import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/widgets/responsive_layout.dart';
import 'package:flutter_tasks_app/models/photo/content.dart';
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
        'https://creategreetingcards.eu/s/${widget.lng}/${widget.photoId}.png';
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
    double widthFactor = LayoutHelpers.getWidthFactor(context);
    bool isTablet = LayoutHelpers.isTablet(context);
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    // Calculate the padding based on the screen size
    final paddingHorizontal = screenWidth * 0.075;

    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
            child: Card(
              child: FractionallySizedBox(
                widthFactor:
                    widthFactor, // Set the width factor to desired percentage
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: isTablet ? BoxFit.fill : BoxFit.contain,
                        width: screenSize.width *
                            0.85, // set the width to 85% of the screen width
                        height: screenSize.height * 0.85,
                      ),

                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
