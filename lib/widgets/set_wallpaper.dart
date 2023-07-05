import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

final _logger = Logger('WallpaperHandler');

class WallpaperHandler {
  static Future<String> setWallpaperHome({
    String? link,
    File? file,
    int? photoId,
    required String successTest,
    required String errorText,
    bool resize = false,
    double width = 0,
    double height = 0,
  }) async {
    _logger.info('setWallpaperHome started.');
    return setWallpaper(
      link: link,
      file: file,
      photoId: photoId,
      successTest: successTest,
      errorText: errorText,
      resize: resize,
      width: width,
      height: height,
      wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
      goToHome: true,
      tempId: 'temp',
    );
  }

  static Future<String> setWallpaperLock({
    String? link,
    File? file,
    int? photoId,
    required String successTest,
    required String errorText,
    bool resize = false,
    double width = 0,
    double height = 0,
  }) async {
    _logger.info('setWallpaperLock started.');
    return setWallpaper(
      link: link,
      file: file,
      photoId: photoId,
      successTest: successTest,
      errorText: errorText,
      resize: resize,
      width: width,
      height: height,
      wallpaperLocation: AsyncWallpaper.LOCK_SCREEN,
      goToHome: false,
      tempId: 'temp_lock',
    );
  }

  static Future<String> setWallpaper({
    String? link,
    File? file,
    int? photoId,
    String? successTest,
    String? errorText,
    bool? resize,
    double? width,
    double? height,
    int? wallpaperLocation,
    bool? goToHome,
    String? tempId,
  }) async {
    String result;
    String filePath = await getFilePath(photoId: photoId, tempId: tempId);

    if (photoId != null && link != null){
      link = link.replaceAll('[ID]', photoId.toString());
    }

    try {
      String? imagePath = await getImageBytes(link: link, file: file, filePath: filePath);

      if (resize == true && imagePath != null) {
        Uint8List? imageBytes = await File(imagePath).readAsBytes();
        imageBytes = await resizeImage(imageBytes: imageBytes, filePath: filePath, width: width, height: height, photoId: photoId, tempId: tempId);
        if (imageBytes != null) {
          await File(imagePath).writeAsBytes(imageBytes);
        }
      }

      if (imagePath != null) {
        result = await setWallpaperFromFile(
          filePath: imagePath,
          wallpaperLocation: wallpaperLocation ?? AsyncWallpaper.HOME_SCREEN,
          goToHome: goToHome ?? false,
          successTest: successTest ?? '',
          errorText: errorText ?? '',
          file: file,
        );
      } else {
        result = errorText ?? '';
      }
    } catch (e) {
      print('Exception: $e');
      result = errorText ?? '';
    }

    return result;
  }

  static Future<String> getFilePath({int? photoId, String? tempId}) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    return '$tempPath/${tempId}_$photoId.jpg';
  }

  static Future<String?> getImageBytes({String? link, File? file, String? filePath}) async {
    if (link != null && await _hasInternetConnection()) {

      var client = http.Client();
      http.Response response;
      try {
        response = await client.get(Uri.parse(link));
        _logger.info('Started image download: $link');
      } catch (e) {
        _logger.warning('Failed to load image: $e');
        return null;
      }

      if (response.statusCode == 200) {
        String? contentType = response.headers['content-type'];
        if (contentType != null && contentType.startsWith('image/')) {
          Uint8List? imageBytes = response.bodyBytes;
          await File(filePath!).writeAsBytes(imageBytes);
          _logger.info('Image download complete: $link');
          return filePath;
        } else {
          _logger.warning('Not an image file: $link');
          return null;
        }
      }
    } else if (file != null) {
      _logger.info('Loaded image from file.');
      return file.path; // return the path of the original file
    }
    return null;
  }

  static Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _logger.info('Internet connection available.');
        return true;
      }
    } on SocketException catch (_) {
      _logger.warning('No internet connection available.');
      return false;
    }
    return false;
  }

  static Future<Uint8List?> resizeImage({Uint8List? imageBytes, String? filePath, double? width, double? height, int? photoId, String? tempId}) async {
    if (imageBytes != null) {
      var originalImage = img.decodeImage(imageBytes);
      var thumbnail = img.copyResize(originalImage!, width: width?.toInt() ?? 0, height: height?.toInt() ?? 0);
      var resizedBytes = img.encodePng(thumbnail);
      _logger.info('Image resized.');

      filePath = await getFilePath(photoId: photoId, tempId: '${tempId}_resized');
      await File(filePath).writeAsBytes(resizedBytes);

      return resizedBytes;
    }
    return null;
  }

  static Future<String> setWallpaperFromFile({
    required String filePath,
    required int wallpaperLocation,
    required bool goToHome,
    required String successTest,
    required String errorText,
    File? file,
  }) async {
    String result = await AsyncWallpaper.setWallpaperFromFile(
      filePath: filePath,
      wallpaperLocation: wallpaperLocation,
      goToHome: file != null ? false : goToHome,
      toastDetails: file != null ? null : ToastDetails(message: '$successTest 😊'),
      errorToastDetails: file != null ? null : ToastDetails(message: '$errorText 😢'),
    )
        ? '$successTest ✔️'
        : errorText;

    if(result == '$successTest ✔️') {
      _logger.info('Wallpaper successfully set from file.');
    } else {
      _logger.severe('Failed to set wallpaper from file: $result');
    }

    // Clear cache after setting wallpaper
    if(file != null) {
      File(filePath).delete();
    }

    return result;
  }
}