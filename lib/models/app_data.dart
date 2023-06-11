import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AppData {
  final String connection;
  final String dataGen;
  final String imagesList;
  final String imagesPreview;
  final String imagesSetWallpapers;
  final String imagesDownload;
  final String imagesShare;
  final String categories;
  final bool downloadButton;
  final int fullAdOptionBreakSeconds;
  final String fullAdOptionShow;
  final int fullAdListLoadingMs;
  final int fullAdLoadingMs;
  final int fullAdListLoading;
  final int fullAdAmount;
  final bool fullAdSetMain;
  final String fullAdSet;
  final String fullAdDownload;
  final String fullAdShare;
  final String fullAdMore;
  final bool bottomAd;
  final String blockAndRedirect;
  final List<int> newItems;
  final List<int> top;

  AppData({
    required this.connection,
    required this.dataGen,
    required this.imagesList,
    required this.imagesPreview,
    required this.imagesSetWallpapers,
    required this.imagesDownload,
    required this.imagesShare,
    required this.categories,
    required this.downloadButton,
    required this.fullAdOptionBreakSeconds,
    required this.fullAdOptionShow,
    required this.fullAdListLoadingMs,
    required this.fullAdLoadingMs,
    required this.fullAdListLoading,
    required this.fullAdAmount,
    required this.fullAdSetMain,
    required this.fullAdSet,
    required this.fullAdDownload,
    required this.fullAdShare,
    required this.fullAdMore,
    required this.bottomAd,
    required this.blockAndRedirect,
    required this.newItems,
    required this.top,
  });



  factory AppData.fromJson(Map<String, dynamic> json) {
    return AppData(
      connection: json['polaczenie'] as String,
      dataGen: json['data_gen'] as String,
      imagesList: json['images_lista'] as String,
      imagesPreview: json['images_podglad'] as String,
      imagesSetWallpapers: json['images_set_wallpapers'] as String,
      imagesDownload: json['images_pobierz'] as String,
      imagesShare: json['images_share'] as String,
      categories: json['kategorie'] as String,
      downloadButton: json['guzik_pobierz'] as bool,
      fullAdOptionBreakSeconds: json['reklama_full_opcja_przerwa_sekund'] as int,
      fullAdOptionShow: json['reklama_full_opcja_pokaz'] as String,
      fullAdListLoadingMs: json['reklama_full_lista_loading_ms'] as int,
      fullAdLoadingMs: json['reklama_full_loading_ms'] as int,
      fullAdListLoading: json['reklama_full_lista_loading'] as int,
      fullAdAmount: json['reklama_full_ilosc'] as int,
      fullAdSetMain: json['reklama_full_set_glowny'] as bool,
      fullAdSet: json['reklama_full_ustaw'] as String,
      fullAdDownload: json['reklama_full_pobierz'] as String,
      fullAdShare: json['reklama_full_share'] as String,
      fullAdMore: json['reklama_full_wiecej'] as String,
      bottomAd: json['reklama_dol'] as bool,
      blockAndRedirect: json['blokuj_i_przekieruj'] as String,
      newItems: (json['new'] as String).split(',').map(int.parse).toList(),
      top: (json['top'] as String).split(',').map(int.parse).toList(),
    );
  }

  AppData copyWith({
    List<int>? newItems,
    List<int>? top,
  }) {
    return AppData(
      newItems: newItems ?? this.newItems,
      top: top ?? this.top,
      // copy all other fields from the current instance
      connection: this.connection,
      dataGen: this.dataGen,
      imagesList: this.imagesList,
      imagesPreview: this.imagesPreview,
      imagesSetWallpapers: this.imagesSetWallpapers,
      imagesDownload: this.imagesDownload,
      imagesShare: this.imagesShare,
      categories: this.categories,
      downloadButton: this.downloadButton,
      fullAdOptionBreakSeconds: this.fullAdOptionBreakSeconds,
      fullAdOptionShow: this.fullAdOptionShow,
      fullAdListLoadingMs: this.fullAdListLoadingMs,
      fullAdLoadingMs: this.fullAdLoadingMs,
      fullAdListLoading: this.fullAdListLoading,
      fullAdAmount: this.fullAdAmount,
      fullAdSetMain: this.fullAdSetMain,
      fullAdSet: this.fullAdSet,
      fullAdDownload: this.fullAdDownload,
      fullAdShare: this.fullAdShare,
      fullAdMore: this.fullAdMore,
      bottomAd: this.bottomAd,
      blockAndRedirect: this.blockAndRedirect,
    );
  }
}
