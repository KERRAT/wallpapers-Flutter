import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_tasks_app/screens/drawers/end_drawer_functions/wallpaper_change_method.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../../../widgets/set_wallpaper.dart';

final _logger = Logger('Background callbacks');

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await setWallpaperNoApp();

    return Future.value(true);
  });
}


@pragma('vm:entry-point')
Future<void> setWallpaperNoApp() async {
  _logger.fine('Starting setWallpaperNoApp function...');
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int changeMethodIndex = prefs.getInt('changeMethod') ?? 0;
    WallpaperChangeMethod changeMethod =
        WallpaperChangeMethod.values[changeMethodIndex];

    List<String> cachedPhotoLinks =
        prefs.getStringList('cachedPhotoLinks') ?? [];
    bool isHuawei = prefs.getBool('isHuawei') ?? false;
    double width = prefs.getDouble('width') ?? 0;
    double height = prefs.getDouble('height') ?? 0;
    String changedEkranGlowny = prefs.getString('changedEkranGlowny') ?? '';
    String error = prefs.getString('error') ?? '';

    _logger.fine('Initial setup completed, entering change method.');

    if (changeMethod == WallpaperChangeMethod.sequential) {
      int currentIndex = prefs.getInt('currentIndex') ?? 0;

      _logger.info('Setting wallpaper sequentially with index: $currentIndex');

      await WallpaperHandler.setWallpaperHome(
          file: File(cachedPhotoLinks[currentIndex]),
          successTest: changedEkranGlowny,
          errorText: error,
          resize: isHuawei,
          width: width,
          height: height);

      _logger.fine('Wallpaper set successfully, updating current index.');

      if (currentIndex >= cachedPhotoLinks.length - 1) {
        currentIndex = 0;
      } else {
        currentIndex += 1;
      }

      prefs.setInt('currentIndex', currentIndex);
    } else {
      var rng = Random();
      int randomIndex = rng.nextInt(cachedPhotoLinks.length);

      _logger.info('Setting wallpaper randomly with index: $randomIndex');

      await WallpaperHandler.setWallpaperHome(
          file: File(cachedPhotoLinks[randomIndex]),
          successTest: changedEkranGlowny,
          errorText: error,
          resize: isHuawei,
          width: width,
          height: height);

      _logger.fine('Random wallpaper set successfully');
    }

    _logger.fine('setWallpaperNoApp function completed successfully.');
  } catch (e) {
    _logger.severe('An error occurred in setWallpaperNoApp: $e');
  }
}
