import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/models/app_data.dart';
import 'package:flutter_tasks_app/screens/photos/create_photo_form.dart';
import 'package:flutter_tasks_app/models/photo/photo.dart';
import 'package:logging/logging.dart';

final _logger = Logger('PhotosList');

class PhotosList extends StatelessWidget {
  const PhotosList(
      {super.key, required this.photos, required this.appData, required this.lng});

  final List<Photo> photos;
  final AppData appData;
  final String lng;

  @override
  Widget build(BuildContext context) {
    _logger.finest('Building PhotosList');

    return GridView.builder(
      padding: EdgeInsets.zero, // add this line to remove padding
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 9 / 12,
        crossAxisSpacing: 0, // add this line to remove space between grid items
        mainAxisSpacing: 0, // add this line to remove space between grid items
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        // Handle tap gesture on each photo item
        return GestureDetector(
          onTap: () {
            _logger.finest('Photo item tapped: ${photos[index].id}');
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return CreatePhotoForm(
                  photo: photos[index],
                  photos: photos,
                  servers: appData.defaultServers,
                  wishListItems: appData.wishListItems,
                  lng: lng,
                );
              },
            );
          },
          // Create a card with 0 padding for each photo item
          child: Card(
            margin: EdgeInsets.all(0), // add this line to remove margin
            // Add a border radius of 0.0px for the card
            // Clip the image with the same border radius as the card
            child: ClipRRect(
              borderRadius: BorderRadius.zero,
              // add this line to remove border radius
              // Use CachedNetworkImage to display the image with caching
              child: CachedNetworkImage(
                imageUrl: "https://creategreetingcards.eu/s/$lng/${photos[index]
                    .id}.png",
                // Make the image fill the card while maintaining its aspect ratio
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}