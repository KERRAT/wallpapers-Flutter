// ignore: file_names
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Category {
  String id;
  String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as String,
        name: json['nazwa'] as String,
      );
}
