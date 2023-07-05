
import 'dart:io';
import 'dart:math';

import 'package:flutter_tasks_app/screens/drawers/end_drawer_functions/wallpaper_change_method.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../../../widgets/set_wallpaper.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int changeMethodIndex = prefs.getInt('changeMethod') ?? 0;
    WallpaperChangeMethod changeMethod =
    WallpaperChangeMethod.values[changeMethodIndex];

    List<String> cachedPhotoLinks = prefs.getStringList('cachedPhotoLinks') ?? [];
    bool isHuawei = prefs.getBool('isHuawei') ?? false;
    double width = prefs.getDouble('width') ?? 0;
    double height = prefs.getDouble('height') ?? 0;
    String changedEkranGlowny = prefs.getString('changedEkranGlowny') ?? '';
    String error = prefs.getString('error') ?? '';

    if (changeMethod == WallpaperChangeMethod.sequential) {
      int currentIndex = prefs.getInt('currentIndex') ?? 0;

      // Set the wallpaper with current index.
      await WallpaperHandler.setWallpaperHome(
          file: File(cachedPhotoLinks[currentIndex]),
          successTest: changedEkranGlowny,
          errorText: error,
          resize: isHuawei,
          width: width,
          height: height);

      // Increment currentIndex after the wallpaper is set.
      if (currentIndex >= cachedPhotoLinks.length - 1) {
        currentIndex = 0;
      } else {
        currentIndex += 1;
      }

      prefs.setInt('currentIndex', currentIndex);
    } else {
      var rng = Random();
      int randomIndex = rng.nextInt(cachedPhotoLinks.length);
      await WallpaperHandler.setWallpaperHome(
          file: File(cachedPhotoLinks[randomIndex]),
          successTest: changedEkranGlowny,
          errorText: error,
          resize: isHuawei,
          width: width,
          height: height);
    }

    return Future.value(true);
  });
}