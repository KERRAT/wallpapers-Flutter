import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/screens/wallpapers/wallpaper_screen_elements/displayed_wallpaper.dart';
import 'package:flutter_tasks_app/screens/wallpapers/wallpaper_screen_elements/return_button.dart';
import 'package:flutter_tasks_app/widgets/responsive_layout.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'wallpaper_screen_elements/bottom_row.dart';
import '../../widgets/like_controller.dart';
import 'wallpaper_screen_elements/change_photo_buttons.dart';

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

  @override
  void initState() {
    super.initState();
    initialPage = widget.photoIds.indexOf(widget.photoId);
    _pageController = PageController(initialPage: initialPage);
    currentPhotoId = widget.photoId;
    _logger.info('Initialized CreatePhotoFormState');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<LikeState>(context, listen: false).checkLikeStatus(currentPhotoId);
    });
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
              onPageChanged: (int index) async {
                setState(() {
                  currentPhotoId = widget.photoIds[index];
                });
                await Provider.of<LikeState>(context, listen: false).checkLikeStatus(currentPhotoId);
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
              child: Consumer<LikeState>(
                builder: (context, likeState, _) => BottomRow(
                  isLiked: likeState.isLiked,
                  toggleLike: () => {likeState.toggleLike(currentPhotoId), widget.onLikeToggle()},
                  widget: widget,
                  currentPhotoId: currentPhotoId,
                  isTablet: isTablet,
                ),
              ),
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