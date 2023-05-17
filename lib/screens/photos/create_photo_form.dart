import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/screens/photos/form_elements/displayed_photo.dart';
import 'package:flutter_tasks_app/screens/photos/form_elements/return_button.dart';
import 'package:flutter_tasks_app/widgets/responsive_layout.dart';
import 'package:logging/logging.dart';

final _logger = Logger('CreatePhotoForm');

class CreatePhotoForm extends StatefulWidget {
  final int photoId;
  final List<int> photoIds;
  final String lng;
  final String link_show;
  final String link_set;
  final String link_share;
  final String link_download;

  // Constructor for CreatePhotoForm
  const CreatePhotoForm({
    Key? key,
    required this.photoId,
    required this.photoIds,
    required this.lng, required this.link_show, required this.link_set, required this.link_share, required this.link_download,
  }) : super(key: key);

  @override
  CreatePhotoFormState createState() => CreatePhotoFormState();
}

class CreatePhotoFormState extends State<CreatePhotoForm> {
  late PageController _pageController;
  late int initialPage;

  @override
  void initState() {
    super.initState();
    initialPage = widget.photoIds.indexOf(widget.photoId);
    _pageController = PageController(initialPage: initialPage);

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
              itemBuilder: (BuildContext context, int index) {
                return DisplayPhoto(
                  photoId: widget.photoIds[index],
                  lng: widget.lng,
                );
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height *
                      (isTablet ? 0.02 : 0.01),
                ),
                child: ReturnButton(onPressed: _handleBack),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
