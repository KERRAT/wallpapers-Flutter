import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class LikeState extends ChangeNotifier {
  bool _isLiked = false;
  late List<String> _likedPhotos;
  late List<String> _likedPhotoLinks;
  late Dio _dio;
  final _logger = Logger('LikeState'); // Create a Logger instance

  LikeState() {
    _dio = Dio();
  }

  Future<void> toggleLike(int currentPhotoId, String linkSet, VoidCallback refreshFavoritePhotos) async {
    try {
      _logger.info("Toggling like status for photoId: $currentPhotoId");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _isLiked = !_isLiked;
      _logger.info("New like status: $_isLiked");

      if (_isLiked) {
        String url = linkSet.replaceAll('[ID]', currentPhotoId.toString());
        _likedPhotos.add(currentPhotoId.toString());
        String filePath = await downloadAndSaveImage(url, currentPhotoId.toString());
        _likedPhotoLinks.add(filePath);
        _logger.info("Photo added to likes: $currentPhotoId");
      } else {
        _likedPhotos.remove(currentPhotoId.toString());
        _likedPhotoLinks.removeWhere((item) => item.contains(currentPhotoId.toString()));
        await deleteImage(currentPhotoId.toString());
        _logger.info("Photo removed from likes: $currentPhotoId");
      }

      await prefs.setStringList('likedPhotos', _likedPhotos);
      await prefs.setStringList('likedPhotoLinks', _likedPhotoLinks);
      notifyListeners();
      refreshFavoritePhotos();
    } catch (e) {
      _logger.severe("Error occurred while toggling like: $e");
    }
  }

  Future<void> checkLikeStatus(int currentPhotoId) async {
    try {
      _logger.info("Checking like status for photoId: $currentPhotoId");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _likedPhotos = prefs.getStringList('likedPhotos') ?? [];
      _likedPhotoLinks = prefs.getStringList('likedPhotoLinks') ?? [];
      _isLiked = _likedPhotos.contains(currentPhotoId.toString());
      _logger.info("Like status: $_isLiked");
      notifyListeners();
    } catch (e) {
      _logger.severe("Error occurred while checking like status: $e");
    }
  }

  Future<String> downloadAndSaveImage(String url, String fileName) async {
    try {
      _logger.info("Downloading image from url: $url");
      var dir = await getApplicationDocumentsDirectory();
      await _dio.download(url, '${dir.path}/$fileName.jpg');
      _logger.info("Image saved at ${dir.path}/$fileName.jpg");
      return '${dir.path}/$fileName.jpg';
    } catch (e) {
      _logger.severe("Error occurred while downloading and saving image: $e");
      return '';
    }
  }

  Future<void> deleteImage(String fileName) async {
    try {
      _logger.info("Deleting image with fileName: $fileName");
      var dir = await getApplicationDocumentsDirectory();
      var file = File('${dir.path}/$fileName.jpg');
      if (await file.exists()) {
        await file.delete();
        _logger.info("Image deleted successfully");
      } else {
        _logger.warning("File does not exist: $fileName");
      }
    } catch (e) {
      _logger.severe("Error occurred while deleting image: $e");
    }
  }

  List<String> get likedPhotos => _likedPhotos;
  bool get isLiked => _isLiked;
}

