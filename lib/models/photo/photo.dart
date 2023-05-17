import 'content.dart';

class Photo {
  final List<String> categories;
  final int id;
  final String version;
  final Content? content1;
  final Content? content2;
  final Content? content3;

  Photo({
    required this.categories,
    required this.id,
    required this.version,
    required this.content1,
    this.content2,
    this.content3,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
        categories: List<String>.from(json['kategorie'] as List<dynamic>),
        id: int.parse(json['id']),
        version: json['wersja'] as String,
        content1:
            json['tresc'] != null ? Content.fromJson(json['tresc']) : null,
        content2:
            json['tresc2'] != null ? Content.fromJson(json['tresc2']) : null,
        content3:
            json['tresc3'] != null ? Content.fromJson(json['tresc3']) : null);
  }
}
