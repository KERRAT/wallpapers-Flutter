import 'package:flutter/material.dart';

class DisplayPhoto extends StatelessWidget {
  final int photoId;
  final String lng;
  final ImageProvider placeholderImage;
  final ImageProvider mainImage;

  const DisplayPhoto({
    Key? key,
    required this.photoId,
    required this.lng,
    required this.placeholderImage,
    required this.mainImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: screenSize.width,
      height: screenSize.height,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image(
            image: placeholderImage,
            fit: BoxFit.cover,
          ),
          Image(
            image: mainImage,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}