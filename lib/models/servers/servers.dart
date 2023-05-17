import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Servers {
  final String address;
  final String serverStatus;
  final String imgList;
  final String addressGen;
  final String addressGenV2;
  final String recommendedExit;
  final String wishList;
  final String recommendedApps;
  final int pringLess;
  final int pingPlus;

  Servers({
    required this.address,
    required this.serverStatus,
    required this.imgList,
    required this.addressGen,
    required this.addressGenV2,
    required this.recommendedExit,
    required this.wishList,
    required this.recommendedApps,
    required this.pringLess,
    required this.pingPlus,
  });

  factory Servers.fromJson(Map<String, dynamic> json) {
    return Servers(
      address: json['adres'] as String,
      serverStatus: json['server_status'] as String,
      imgList: json['img_list'] as String,
      addressGen: json['adres_gen'] as String,
      addressGenV2: json['adres_gen_v2'] as String,
      recommendedExit: json['polecane_wyjdz'] as String,
      wishList: json['lista_zyczen'] as String,
      recommendedApps: json['polecane_apki'] as String,
      pringLess: json['pring<'] as int,
      pingPlus: json['ping+'] as int,
    );
  }
}
