import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class LikeState extends ChangeNotifier {
  bool _isLiked = false;
  late List<String> _likedPhotos;
  late List<String> _likedPhotoLinks;
  late Dio _dio;

  LikeState() {
    _dio = Dio();
  }

  Future<void> toggleLike(int currentPhotoId, String linkSet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLiked = !_isLiked;
    if (_isLiked) {
      String url = linkSet.replaceAll('[ID]', currentPhotoId.toString());
      _likedPhotos.add(currentPhotoId.toString());
      String filePath = await downloadAndSaveImage(url, currentPhotoId.toString());
      _likedPhotoLinks.add(filePath);
    } else {
      _likedPhotos.remove(currentPhotoId.toString());
      _likedPhotoLinks.removeWhere((item) => item.contains(currentPhotoId.toString()));
      await deleteImage(currentPhotoId.toString());
    }
    await prefs.setStringList('likedPhotos', _likedPhotos);
    await prefs.setStringList('likedPhotoLinks', _likedPhotoLinks);
    notifyListeners();  // Notify listeners that _isLiked has changed
  }

  Future<void> checkLikeStatus(int currentPhotoId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _likedPhotos = prefs.getStringList('likedPhotos') ?? [];
    _likedPhotoLinks = prefs.getStringList('likedPhotoLinks') ?? [];
    _isLiked = _likedPhotos.contains(currentPhotoId.toString());
    notifyListeners();
  }

  Future<String> downloadAndSaveImage(String url, String fileName) async {
    var dir = await getApplicationDocumentsDirectory();
    await _dio.download(url, '${dir.path}/$fileName.jpg');
    return '${dir.path}/$fileName.jpg';
  }

  Future<void> deleteImage(String fileName) async {
    var dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$fileName.jpg');
    if (await file.exists()) {
      await file.delete();
    }
  }

  List<String> get likedPhotos => _likedPhotos;
  bool get isLiked => _isLiked;
}
