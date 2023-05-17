import 'package:flutter_tasks_app/models/category.dart';
import 'package:flutter_tasks_app/models/photo/photo.dart';
import 'package:flutter_tasks_app/models/servers/default_servers.dart';
import 'package:flutter_tasks_app/models/servers/servers.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AppData {
  final String date;
  final String addressEnter;
  final int adFullQuantity;
  final int adFullSecondOption;
  final String adFullOptionShow;
  final int adFullAdsLoadingMilliseconds;
  final String adFullDownload;
  final String adFullShare;
  final bool adList;
  final bool adPreview;
  final DefaultServers defaultServers;
  final Servers servers; // змінено з List<Server> на Server
  final List<Photo> photos;
  final List<Category> categories;
  final List<dynamic> wishListItems = [];

  AppData({
    required this.date,
    required this.addressEnter,
    required this.adFullQuantity,
    required this.adFullSecondOption,
    required this.adFullOptionShow,
    required this.adFullAdsLoadingMilliseconds,
    required this.adFullDownload,
    required this.adFullShare,
    required this.adList,
    required this.adPreview,
    required this.defaultServers,
    required this.servers, // змінено з List<Server> на Server
    required this.photos,
    required this.categories,
  });

  factory AppData.fromJson(Map<String, dynamic> json) {
    return AppData(
      date: json['date'] as String,
      addressEnter: json['adres_wejdz'] as String,
      adFullQuantity: json['reklama_full_ilosc'] as int,
      adFullSecondOption: json['reklama_full_opcja_przerwa_sekund'] as int,
      adFullOptionShow: json['reklama_full_opcja_pokaz'] as String,
      adFullAdsLoadingMilliseconds:
          json['reklama_full_ads_loading_milisekund'] as int,
      adFullDownload: json['reklama_full_pobierz'] as String,
      adFullShare: json['reklama_full_share'] as String,
      adList: json['reklama_lista'] as bool,
      adPreview: json['reklama_podglad'] as bool,
      defaultServers: DefaultServers.fromJson(
          json['default_server'] as Map<String, dynamic>),
      servers: Servers.fromJson(json['servers'][0] as Map<String,
          dynamic>), // змінено для отримання лише першого елемента
      photos: (json['kartki'] as List<dynamic>)
          .map((photoJson) => Photo.fromJson(photoJson as Map<String, dynamic>))
          .toList(),
      categories: (json['kategorie'] as List<dynamic>)
          .map((categoryJson) =>
              Category.fromJson(categoryJson as Map<String, dynamic>))
          .toList(),
    );
  }
}
