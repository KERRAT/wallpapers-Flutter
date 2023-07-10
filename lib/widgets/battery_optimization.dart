import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

final _logger = Logger('BatteryOptimization');

class BatteryOptimization {
  static const platform = const MethodChannel('com.example.wallpapers/battery_optimization');

  static Future<void> openApplicationSettings() async {
    try {
      await platform.invokeMethod('openApplicationSettings');
    } on PlatformException catch (e) {
      _logger.warning(e);
    }
  }

  static Future<void> openPermissionDialog() async {
    try {
      await platform.invokeMethod('openPermissionDialog');
    } on PlatformException catch (e) {
      _logger.warning(e);
    }
  }

  static Future<bool> isIgnoringBatteryOptimizations() async {
    try {
      final bool isIgnoring = await platform.invokeMethod('isIgnoringBatteryOptimizations');
      return isIgnoring;
    } on PlatformException catch (e) {
      _logger.warning(e);
      return false;
    }
  }
}
