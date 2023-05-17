import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/models/photo/photo.dart';
import 'package:flutter_tasks_app/models/servers/default_servers.dart';
import 'package:flutter_tasks_app/screens/photos/form_elements/displayed_photo.dart';
import 'package:flutter_tasks_app/screens/photos/form_elements/return_button.dart';
import 'package:flutter_tasks_app/widgets/responsive_layout.dart';
import 'package:logging/logging.dart';

final _logger = Logger('CreatePhotoForm');

class CreatePhotoForm extends StatefulWidget {
  final Photo photo;
  final List<Photo> photos;
  final List<dynamic> wishListItems;
  final DefaultServers servers;
  final String lng;

  // Constructor for CreatePhotoForm
  const CreatePhotoForm({
    Key? key,
    required this.photo,
    required this.photos,
    required this.servers,
    required this.wishListItems,
    required this.lng,
  }) : super(key: key);

  @override
  CreatePhotoFormState createState() => CreatePhotoFormState();
}

class CreatePhotoFormState extends State<CreatePhotoForm> {

  late PageController _pageController;
  late int initialPage;

  late String adresGen;
  late String adresGenV2;

  @override
  void initState() {
    super.initState();
    initialPage = widget.photos.indexWhere((photo) => photo.id == widget.photo.id);
    _pageController = PageController(initialPage: initialPage);

    adresGen = widget.servers.addressGen;
    adresGenV2 = widget.servers.addressGenV2;

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
              itemCount: widget.photos.length,
              itemBuilder: (BuildContext context, int index) {
                return DisplayPhoto(
                  photoId: widget.photos[index].id,
                  lng: widget.lng,
                );
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.arrow_forward),
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

  Widget _buildContent(BuildContext context) {
    return Column(
        children: [
        SizedBox(height: MediaQuery.of(context).devicePixelRatio * 10),
          DisplayPhoto(
            photoId: widget.photo.id,
            lng: widget.lng,
          ),
          SizedBox(height: MediaQuery.of(context).devicePixelRatio * 10),
        ],
    );
  }
}
