import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikeState extends ChangeNotifier {
  bool _isLiked = false;
  late List<String> _likedPhotos;


  Future<void> toggleLike(int currentPhotoId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLiked = !_isLiked;
    if (_isLiked) {
      _likedPhotos.add(currentPhotoId.toString());
    } else {
      _likedPhotos.remove(currentPhotoId.toString());
    }
    await prefs.setStringList('likedPhotos', _likedPhotos);
    notifyListeners();  // Notify listeners that _isLiked has changed
  }

  Future<void> checkLikeStatus(int currentPhotoId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _likedPhotos = prefs.getStringList('likedPhotos') ?? [];
    _isLiked = _likedPhotos.contains(currentPhotoId.toString());
  }

  List<String> get likedPhotos => _likedPhotos;
  bool get isLiked => _isLiked;
}