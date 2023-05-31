import 'package:flutter/material.dart';
import '../../../widgets/set_wallpaper.dart';

class WallpaperButtons extends StatelessWidget {
  final String linkSet;
  final int currentPhotoId;

  const WallpaperButtons({
    Key? key,
    required this.linkSet,
    required this.currentPhotoId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 30,  // Make the icon bigger
          child: IconButton(
            iconSize: 30.0,
            color: Colors.white,
            icon: const Icon(Icons.mobile_screen_share_sharp),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return FutureBuilder<String>(
                    future: WallpaperHandler.setWallpaperHome(linkSet, currentPhotoId),
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return AlertDialog(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              CircularProgressIndicator(),
                              SizedBox(width: 10),
                              Text("Loading..."),
                            ],
                          ),
                        );
                      } else {
                        return AlertDialog(
                          content: Text(snapshot.data ?? 'Error'),
                        );
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(width: 10.0),  // Add some space
        CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 30,  // Make the icon bigger
          child: IconButton(
            iconSize: 30.0,
            color: Colors.white,
            icon: const Icon(Icons.phonelink_lock),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return FutureBuilder<String>(
                    future: WallpaperHandler.setWallpaperLock(linkSet, currentPhotoId),
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return AlertDialog(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              CircularProgressIndicator(),
                              SizedBox(width: 10),
                              Text("Loading..."),
                            ],
                          ),
                        );
                      } else {
                        return AlertDialog(
                          content: Text(snapshot.data ?? 'Error'),
                        );
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
