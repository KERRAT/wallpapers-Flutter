import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/screens/photos/wallpaper_buttons.dart';

import 'create_photo_form.dart';

class BottomRow extends StatelessWidget {
  const BottomRow({
    Key? key,
    required bool isLiked,
    required Function toggleLike,
    required this.widget,
    required int currentPhotoId,
    required bool isTablet,
  })  : _isLiked = isLiked,
        _toggleLike = toggleLike,
        _currentPhotoId = currentPhotoId,
        _isTablet = isTablet,
        super(key: key);

  final bool _isLiked;
  final Function _toggleLike;
  final CreatePhotoForm widget;
  final int _currentPhotoId;
  final bool _isTablet;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height *
            (_isTablet ? 0.02 : 0.01),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: _isLiked
                  ? const Icon(Icons.favorite, color: Colors.red)
                  : const Icon(Icons.favorite_border),
              onPressed: _toggleLike as void Function()?,
            ),
          ),
          const SizedBox(width: 20.0),
          WallpaperButtons(
              linkSet: widget.linkSet,
              currentPhotoId: _currentPhotoId),
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
