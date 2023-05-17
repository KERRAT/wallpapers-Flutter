import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logging/logging.dart';

final _logger = Logger('requestStoragePermissions');

Future<bool> requestStoragePermissions() async {
  PermissionStatus status;

  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt <= 32) {
      status = await Permission.storage.request();
    } else {
      status = await Permission.photos.request();
    }
  } else if (Platform.isIOS) {
    status = await Permission.storage.request();
  } else {
    _logger.warning("Unsupported platform");
    return false;
  }
  if (status.isGranted) {
    _logger.info("Permission granted");
    return true;
  } else {
    _logger.warning("Permission denied");
    return false;
  }
}
