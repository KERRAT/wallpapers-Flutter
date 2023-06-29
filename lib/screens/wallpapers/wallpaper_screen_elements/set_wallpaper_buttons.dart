import 'package:flutter/material.dart';
import '../../../gen_l10n/app_localizations.dart';
import '../../../widgets/check_device_manufacturer.dart';
import '../../../widgets/set_wallpaper.dart';

class WallpaperButtons extends StatefulWidget {
  final String linkSet;
  final int currentPhotoId;

  const WallpaperButtons({
    Key? key,
    required this.linkSet,
    required this.currentPhotoId,
  }) : super(key: key);

  @override
  _WallpaperButtonsState createState() => _WallpaperButtonsState();
}

class _WallpaperButtonsState extends State<WallpaperButtons> {
  double width = 0; double height = 0;
  bool isHuawei = false;

  @override
  void initState() {
    super.initState();
    checkDeviceManufacturer('huawei').then((result) {
      setState(() {
        isHuawei = result;
        if (isHuawei){
          width = MediaQuery.of(context).size.width;
          height = MediaQuery.of(context).size.height;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 30, // Make the icon bigger
          child: IconButton(
            iconSize: 30.0,
            color: Colors.white,
            icon: const Icon(Icons.mobile_screen_share_sharp),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return FutureBuilder<String>(
                    future: WallpaperHandler.setWallpaperHome(
                        widget.linkSet,
                        widget.currentPhotoId,
                        AppLocalizations.of(context)
                            .wallpaper_changed_ekran_glowny,
                        AppLocalizations.of(context).error,
                        isHuawei,
                        width, height),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return AlertDialog(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const CircularProgressIndicator(),
                              const SizedBox(width: 10),
                              Text(
                                  AppLocalizations.of(context).info_loading_is_in_progress),
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
        const SizedBox(width: 10.0), // Add some space
        CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 30, // Make the icon bigger
          child: IconButton(
            iconSize: 30.0,
            color: Colors.white,
            icon: const Icon(Icons.phonelink_lock),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return FutureBuilder<String>(
                    future: WallpaperHandler.setWallpaperLock(
                        widget.linkSet,
                        widget.currentPhotoId,
                        AppLocalizations.of(context)
                            .wallpaper_changed_ekran_blokady,
                        AppLocalizations.of(context).error,
                        isHuawei,
                        width, height),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return AlertDialog(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const CircularProgressIndicator(),
                              const SizedBox(width: 10),
                              Text(
                                  AppLocalizations.of(context).info_loading_is_in_progress),
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


