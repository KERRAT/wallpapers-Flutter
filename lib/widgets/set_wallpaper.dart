import 'package:async_wallpaper/async_wallpaper.dart';

class WallpaperHandler {
  static Future<String> setWallpaperHome(String link, int photoId, String successTest, String errorText) async {
    String result;
    try {
      result = await AsyncWallpaper.setWallpaper(
        url: link.replaceAll('[ID]', photoId.toString()),
        wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
        goToHome: true,
        toastDetails: ToastDetails(message: '$successTest 😊'),
        errorToastDetails: ToastDetails(message: '$errorText 😢'),
      )
          ? '$successTest ✔️'
          : errorText;
    } catch (e) {
      result = errorText;
    }
    return result;
  }

  static Future<String> setWallpaperLock(String link, int photoId, String successTest, String errorText) async {
    String result;
    try {
      result = await AsyncWallpaper.setWallpaper(
        url: link.replaceAll('[ID]', photoId.toString()),
        wallpaperLocation: AsyncWallpaper.LOCK_SCREEN,
        goToHome: false,
        toastDetails: ToastDetails(message: '$successTest 😊'),
        errorToastDetails: ToastDetails(message: '$errorText 😢'),
      )
          ? '$successTest ✔️'
          : errorText;
    } catch (e) {
      result = errorText;
    }
    return result;
  }
}
