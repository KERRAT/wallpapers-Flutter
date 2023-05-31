import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/screens/photos/form_elements/displayed_photo.dart';
import 'package:flutter_tasks_app/screens/photos/form_elements/return_button.dart';
import 'package:flutter_tasks_app/widgets/responsive_layout.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_row.dart';
import 'navigation_circles.dart';

final _logger = Logger('CreatePhotoForm');

class CreatePhotoForm extends StatefulWidget {
  final int photoId;
  final List<int> photoIds;
  final VoidCallback onLikeToggle;
  final String lng;
  final String linkShow;
  final String linkSet;
  final String linkShare;
  final String linkDownload;

  const CreatePhotoForm({
    Key? key,
    required this.photoId,
    required this.photoIds,
    required this.lng,
    required this.linkShow,
    required this.linkSet,
    required this.linkShare,
    required this.linkDownload,
    required this.onLikeToggle,
  }) : super(key: key);

  @override
  _CreatePhotoFormState createState() => _CreatePhotoFormState();
}

class _CreatePhotoFormState extends State<CreatePhotoForm> {
  late final PageController _pageController;
  late final int initialPage;
  late int currentPhotoId;
  bool _isLiked = false;
  late List<String> _likedPhotos;

  @override
  void initState() {
    super.initState();
    initialPage = widget.photoIds.indexOf(widget.photoId);
    _pageController = PageController(initialPage: initialPage);
    currentPhotoId = widget.photoId;
    _likedPhotos = [];
    _logger.info('Initialized CreatePhotoFormState');
    checkLikeStatus().then((_) {
      setState(() {});
    });
  }

  Future<void> getLikedPhotos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _likedPhotos = prefs.getStringList('likedPhotos') ?? [];
    if (_likedPhotos.contains(currentPhotoId.toString())) {
      setState(() {
        _isLiked = true;
      });
    }else{
      _isLiked = false;
    }
  }

  Future<void> toggleLike() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLiked = !_isLiked;
    });

    if (_isLiked) {
      _likedPhotos.add(currentPhotoId.toString());
    } else {
      _likedPhotos.remove(currentPhotoId.toString());
    }
    widget.onLikeToggle();
    prefs.setStringList('likedPhotos', _likedPhotos);
  }

  Future<void> checkLikeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _likedPhotos = prefs.getStringList('likedPhotos') ?? [];
    if (_likedPhotos.contains(currentPhotoId.toString())) {
      _isLiked = true;
    } else {
      _isLiked = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.info('Building CreatePhotoForm widget');
    bool isTablet = LayoutHelpers.isTablet(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                checkLikeStatus();
              },
              itemBuilder: (BuildContext context, int index) {
                return DisplayPhoto(
                  photoId: widget.photoIds[index],
                  lng: widget.lng,
                );
              },
            ),
            NavigationCircles(_pageController),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ReturnButton(onPressed: _handleBack),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomRow(isLiked: _isLiked, toggleLike: toggleLike, widget: widget, currentPhotoId: currentPhotoId, isTablet: isTablet),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBack() {
    _logger.info('Back button pressed');
    Navigator.pop(context);
  }
}
