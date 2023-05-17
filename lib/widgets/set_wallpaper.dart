import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WallpaperHandler {
  // Platform messages are asynchronous, so we initialize in an async method.
  static Future<void> setWallpaperHome(String link, int photoId) async {
    String result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await AsyncWallpaper.setWallpaper(
        url: link.replaceAll('[ID]', photoId.toString()),
        wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
        goToHome: true,
        toastDetails: ToastDetails.success(),
        errorToastDetails: ToastDetails.error(),
      )
          ? 'Wallpaper set'
          : 'Failed to get wallpaper.';
    } on PlatformException {
      result = 'Failed to get wallpaper.';
    } catch (e) {
      result = 'Failed with exception: $e';
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  static Future<void> setWallpaperLock(String link, int photoId) async {
    String result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await AsyncWallpaper.setWallpaper(
        url: link.replaceAll('[ID]', photoId.toString()),
        wallpaperLocation: AsyncWallpaper.LOCK_SCREEN,
        goToHome: false,
        toastDetails: ToastDetails.success(),
        errorToastDetails: ToastDetails.error(),
      )
          ? 'Wallpaper set'
          : 'Failed to get wallpaper.';
    } on PlatformException {
      result = 'Failed to get wallpaper.';
    } catch (e) {
      result = 'Failed with exception: $e';
    }

  }
}
