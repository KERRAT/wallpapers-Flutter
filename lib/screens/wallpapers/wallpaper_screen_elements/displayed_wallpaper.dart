import 'package:flutter/material.dart';

class DisplayPhoto extends StatelessWidget {
  final int photoId;
  final String lng;
  final ImageProvider image;

  const DisplayPhoto({
    Key? key,
    required this.photoId,
    required this.lng,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: screenSize.width,
      height: screenSize.height,
      child: Image(
        image: image,
        fit: BoxFit.cover,
      ),
    );
  }
}