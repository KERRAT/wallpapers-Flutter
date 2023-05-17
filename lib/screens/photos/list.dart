import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/models/app_data.dart';
import 'package:logging/logging.dart';

import 'create_photo_form.dart';

final _logger = Logger('PhotosList');

class PhotosList extends StatelessWidget {
  const PhotosList({
    Key? key,
    required this.appData,
    required this.lng,
  }) : super(key: key);

  final AppData appData;
  final String lng;

  @override
  Widget build(BuildContext context) {
    _logger.finest('Building PhotosList');

    final allPhotos = [...appData.newItems, ...appData.top];

    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 9 / 12,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
      ),
      itemCount: allPhotos.length,
      itemBuilder: (context, index) {
        final photoId = allPhotos[index];

        return GestureDetector(
          onTap: () {
            _logger.finest('Photo item tapped: $photoId');
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return CreatePhotoForm(
                  photoId: photoId,
                  photoIds: allPhotos,
                  link_show: appData.imagesPreview,
                  link_set: appData.imagesSetWallpapers,
                  link_share: appData.fullAdShare,
                  link_download: appData.imagesDownload,
                  lng: lng,
                );
              },
            );
          },
          child: Card(
            margin: const EdgeInsets.all(0),
            child: ClipRRect(
              borderRadius: BorderRadius.zero,
              child: CachedNetworkImage(
                imageUrl: appData.imagesList.replaceAll('[ID]', photoId.toString()),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}