import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/services.dart';

class WallpaperHandler {
  static Future<String> setWallpaperHome(String link, int photoId) async {
    String result;
    try {
      result = await AsyncWallpaper.setWallpaper(
        url: link.replaceAll('[ID]', photoId.toString()),
        wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
        goToHome: true,
        toastDetails: ToastDetails.success(),
        errorToastDetails: ToastDetails.error(),
      )
          ? 'Wallpaper set ✔️'
          : 'Failed to get wallpaper.';
    } on PlatformException {
      result = 'Failed to get wallpaper.';
    } catch (e) {
      result = 'Failed with exception: $e';
    }
    return result;
  }

  static Future<String> setWallpaperLock(String link, int photoId) async {
    String result;
    try {
      result = await AsyncWallpaper.setWallpaper(
        url: link.replaceAll('[ID]', photoId.toString()),
        wallpaperLocation: AsyncWallpaper.LOCK_SCREEN,
        goToHome: false,
        toastDetails: ToastDetails.success(),
        errorToastDetails: ToastDetails.error(),
      )
          ? 'Wallpaper set ✔️'
          : 'Failed to get wallpaper.';
    } on PlatformException {
      result = 'Failed to get wallpaper.';
    } catch (e) {
      result = 'Failed with exception: $e';
    }
    return result;
  }
}
