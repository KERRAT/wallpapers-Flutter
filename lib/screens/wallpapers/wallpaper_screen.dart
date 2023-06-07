import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
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
  static const double viewportFraction = 1.2;
  final Map<int, ImageProvider> precachedImages = {};
  int? currentIndex;

  @override
  void initState() {
    super.initState();
    initialPage = widget.photoIds.indexOf(widget.photoId);
    _pageController = PageController(
      initialPage: initialPage,
      viewportFraction:
          viewportFraction, // control the number of pages you want to show in a view
    );
    currentPhotoId = widget.photoId;
    _logger.info('Initialized CreatePhotoFormState');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _precacheImages(initialPage); // Перенесіть виклик цього методу сюди
      await Provider.of<LikeState>(context, listen: false)
          .checkLikeStatus(currentPhotoId);
    });
  }

  void _precacheImages(int index) async {
    for (int i = max(index - 6, 0);
        i <= min(index + 6, widget.photoIds.length - 1);
        i++) {
      if (!precachedImages.containsKey(widget.photoIds[i])) {
        final image = NetworkImage(
            widget.linkShow.replaceAll('[ID]', "${widget.photoIds[i]}"));
        await precacheImage(image, context);
        precachedImages[widget.photoIds[i]] = image;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.info('Building CreatePhotoForm widget');
    bool isTablet = LayoutHelpers.isTablet(context);
    return Dialog(
      insetPadding:
          EdgeInsets.zero, // Це змусить діалог розтягнутися на весь екран
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.photoIds.length,
            onPageChanged: (int index) {
              setState(() {
                currentIndex = index;
                _precacheImages(currentIndex!);
                currentPhotoId = widget.photoIds[index];
              });
              Provider.of<LikeState>(context, listen: false)
                  .checkLikeStatus(currentPhotoId);
            },
            itemBuilder: (BuildContext context, int index) {
              final photoId = widget.photoIds[index];
              final image = precachedImages.containsKey(photoId)
                  ? precachedImages[photoId]!
                  : NetworkImage(
                      widget.linkShow.replaceAll('[ID]', "$photoId"));
              return DisplayPhoto(
                photoId: photoId,
                lng: widget.lng,
                image: image, // Pass the image instead of imageProvider
              );
            },
            pageSnapping: false,
            physics: const PageOverscrollPhysics(velocityPerOverscroll: 1000),
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
                toggleLike: () => {
                  likeState.toggleLike(currentPhotoId),
                  widget.onLikeToggle()
                },
                widget: widget,
                currentPhotoId: currentPhotoId,
                isTablet: isTablet,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleBack() {
    _logger.info('Back button pressed');
    Navigator.pop(context);
  }
}

class PageOverscrollPhysics extends ScrollPhysics {
  final double velocityPerOverscroll;
  final double viewportFraction;

  const PageOverscrollPhysics({
    ScrollPhysics? parent,
    this.velocityPerOverscroll = 1000,
    this.viewportFraction = _CreatePhotoFormState.viewportFraction,
  }) : super(parent: parent);

  @override
  PageOverscrollPhysics applyTo(ScrollPhysics? ancestor) {
    return PageOverscrollPhysics(
      parent: buildParent(ancestor)!,
      velocityPerOverscroll: velocityPerOverscroll,
      viewportFraction: viewportFraction,
    );
  }

  double _getTargetPixels(ScrollMetrics position, double velocity) {
    double page = (position.pixels -
            position.viewportDimension * (1 - viewportFraction) / 2) /
        (position.viewportDimension * viewportFraction);
    page += velocity / (velocityPerOverscroll * viewportFraction);
    double pixels =
        page.roundToDouble() * (position.viewportDimension * viewportFraction) -
            position.viewportDimension * (1 - viewportFraction) / 2;
    return pixels;
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final double target = _getTargetPixels(position, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
