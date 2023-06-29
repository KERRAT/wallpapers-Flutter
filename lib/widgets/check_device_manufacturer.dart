import 'package:device_info_plus/device_info_plus.dart';

Future<bool> checkDeviceManufacturer(String man) async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  String manufacturer = androidInfo.manufacturer;
  return manufacturer.toLowerCase() == man.toLowerCase();
}
