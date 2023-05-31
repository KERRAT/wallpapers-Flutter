import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/screens/photos/wallpaper_buttons.dart';

import 'create_photo_form.dart';

class BottomRow extends StatelessWidget {
  final Function toggleLike;
  final CreatePhotoForm widget;
  final int currentPhotoId;
  final bool isTablet;
  final bool isLiked;

  BottomRow({
    Key? key,
    required this.isLiked,
    required this.toggleLike,
    required this.widget,
    required this.currentPhotoId,
    required this.isTablet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height *
            (isTablet ? 0.02 : 0.01),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: isLiked
                  ? const Icon(Icons.favorite, color: Colors.red)
                  : const Icon(Icons.favorite_border),
              onPressed: toggleLike as void Function()?,
            ),
          ),
          const SizedBox(width: 20.0),
          WallpaperButtons(
              linkSet: widget.linkSet,
              currentPhotoId: currentPhotoId),
          const SizedBox(width: 20.0),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
