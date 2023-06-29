import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class WallpaperHandler {
  static Future<String> setWallpaperHome(String link, int photoId, String successTest, String errorText, bool resize, double width, double height) async {
    String result;
    String url = link.replaceAll('[ID]', photoId.toString());

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String filePath = '$tempPath/temp_$photoId.jpg'; // Use photoId in the filePath

    try {
      Uint8List? imageBytes;

      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        imageBytes = response.bodyBytes;

        File file = File(filePath);
        await file.writeAsBytes(imageBytes);

        if (resize) {
          var originalImage = img.decodeImage(imageBytes);
          var thumbnail = img.copyResize(originalImage!, width: width.toInt(), height: height.toInt());
          var resizedBytes = img.encodePng(thumbnail);

          filePath = '$tempPath/temp_resized_$photoId.jpg'; // Use photoId in the filePath
          file = File(filePath);
          await file.writeAsBytes(resizedBytes);
        }
      }

      if (imageBytes != null) {
        result = await AsyncWallpaper.setWallpaperFromFile(
          filePath: filePath,
          wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
          goToHome: true,
          toastDetails: ToastDetails(message: '$successTest 😊'),
          errorToastDetails: ToastDetails(message: '$errorText 😢'),
        )
            ? '$successTest ✔️'
            : errorText;

        // Clear cache after setting wallpaper
        File(filePath).delete();
      } else {
        result = errorText;
      }
    } catch (e) {
      result = errorText;
    }

    return result;
  }

  static Future<String> setWallpaperLock(String link, int photoId, String successTest, String errorText, bool resize, double width, double height) async {
    String result;
    String url = link.replaceAll('[ID]', photoId.toString());

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String filePath = '$tempPath/temp_lock_$photoId.jpg'; // Use photoId in the filePath

    try {
      Uint8List? imageBytes;

      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        imageBytes = response.bodyBytes;

        File file = File(filePath);
        await file.writeAsBytes(imageBytes);

        if (resize) {
          var originalImage = img.decodeImage(imageBytes);
          var thumbnail = img.copyResize(originalImage!, width: width.toInt(), height: height.toInt());
          var resizedBytes = img.encodePng(thumbnail);

          filePath = '$tempPath/temp_lock_resized_$photoId.jpg'; // Use photoId in the filePath
          file = File(filePath);
          await file.writeAsBytes(resizedBytes);

          var compressedImage = await FlutterImageCompress.compressAndGetFile(
            file.absolute.path,
            "$tempPath/temp_lock_compressed_$photoId.jpg", // Use photoId in the filePath
            minWidth: width.toInt(),
            minHeight: height.toInt(),
            quality: 88,
          );

          if (compressedImage != null) {
            imageBytes = await compressedImage.readAsBytes();
            filePath = compressedImage.path;
          }
        }
      }

      if (imageBytes != null) {
        result = await AsyncWallpaper.setWallpaperFromFile(
          filePath: filePath,
          wallpaperLocation: AsyncWallpaper.LOCK_SCREEN,
          goToHome: false,
          toastDetails: ToastDetails(message: '$successTest 😊'),
          errorToastDetails: ToastDetails(message: '$errorText 😢'),
        )
            ? '$successTest ✔️'
            : errorText;

        // Clear cache after setting wallpaper
        File(filePath).delete();
      } else {
        result = errorText;
      }
    } catch (e) {
      result = errorText;
    }

    return result;
  }
}
