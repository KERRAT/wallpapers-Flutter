import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tasks_app/screens/photos/form_elements/displayed_photo.dart';
import 'package:flutter_tasks_app/screens/photos/form_elements/return_button.dart';
import 'package:flutter_tasks_app/widgets/responsive_layout.dart';
import 'package:logging/logging.dart';

import '../../widgets/set_wallpaper.dart';

final _logger = Logger('CreatePhotoForm');

class CreatePhotoForm extends StatefulWidget {
  final int photoId;
  final List<int> photoIds;
  final String lng;
  final String linkShow;
  final String linkSet;
  final String linkShare;
  final String linkDownload;

  // Constructor for CreatePhotoForm
  const CreatePhotoForm({
    Key? key,
    required this.photoId,
    required this.photoIds,
    required this.lng, required this.linkShow, required this.linkSet, required this.linkShare, required this.linkDownload,
  }) : super(key: key);

  @override
  CreatePhotoFormState createState() => CreatePhotoFormState();
}

class CreatePhotoFormState extends State<CreatePhotoForm> {
  late PageController _pageController;
  late int initialPage;
  late int currentPhotoId;

  @override
  void initState() {
    super.initState();
    initialPage = widget.photoIds.indexOf(widget.photoId);
    _pageController = PageController(initialPage: initialPage);
    currentPhotoId = widget.photoId;
    _logger.info('Initialized CreatePhotoFormState');
  }

  // Function to handle back button press
  void _handleBack() {
    _logger.info('Back button pressed');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    _logger.info('Building CreatePhotoForm widget');
    bool isTablet = LayoutHelpers.isTablet(context);
    return Scaffold(
      backgroundColor: Colors.transparent,  // Set the background color to transparent
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.photoIds.length,
              onPageChanged: (int index) {
                setState(() {
                  currentPhotoId = widget.photoIds[index];
                });
              },
              itemBuilder: (BuildContext context, int index) {
                return DisplayPhoto(
                  photoId: widget.photoIds[index],
                  lng: widget.lng,
                );
              },
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ReturnButton(onPressed: _handleBack),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
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
                        icon: const Icon(Icons.favorite_border), // Heart icon
                        onPressed: (){}
                      ),
                    ),
                    const SizedBox(width: 20.0),  // Add some space
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 30,  // Make the icon bigger
                      child: IconButton(
                        iconSize: 30.0, // Make the icon bigger
                        color: Colors.white,
                        icon: const Icon(Icons.mobile_screen_share_sharp),
                        onPressed: () => WallpaperHandler.setWallpaperHome(widget.linkSet, currentPhotoId),
                      ),
                    ),
                    const SizedBox(width: 10.0),  // Add some space
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 30,  // Make the icon bigger
                      child: IconButton(
                        iconSize: 30.0, // Make the icon bigger
                        color: Colors.white,
                        icon: const Icon(Icons.phonelink_lock_sharp),
                        onPressed: () => WallpaperHandler.setWallpaperLock(widget.linkSet, currentPhotoId),
                      ),
                    ),
                    const SizedBox(width: 20.0),  // Add some space
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.share), // Share icon
                        onPressed: () {}
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
