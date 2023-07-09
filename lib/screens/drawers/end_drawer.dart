import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tasks_app/screens/drawers/end_drawer_functions/wallpaper_change_method.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../../gen_l10n/app_localizations.dart';
import '../../widgets/battery_optimization.dart';
import '../../widgets/check_device_manufacturer.dart';
import '../../widgets/copy_files_to_cache .dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'end_drawer_elements/change_interval.dart';
import 'end_drawer_elements/change_method.dart';

final _logger = Logger('SettingsDrawer');

class SettingsDrawer extends StatefulWidget {
  final List<int> favoritePhotos;
  final String linkSet;
  late SharedPreferences sharedPrefs;

  Future<void> initializeSharedPreferences() async {
    sharedPrefs = await SharedPreferences.getInstance();
    _logger.info("SharedPreferences initialized");
  }

  SettingsDrawer({
    Key? key,
    required this.favoritePhotos,
    required this.linkSet,
  }) : super(key: key) {
    _logger.info("Initializing SharedPreferences");
    initializeSharedPreferences();
  }

  @override
  SettingsDrawerState createState() => SettingsDrawerState();
}

class SettingsDrawerState extends State<SettingsDrawer> {
  late double _changeInterval;
  String changedEkranGlowny = '';
  String error = '';
  double width = 0;
  double height = 0;
  bool isHuawei = false;
  final platform =
      const MethodChannel('com.example.wallpapers/battery_optimization');
  late WallpaperChangeMethod _changeMethod;

  final periodicTaskKey = "change_wallpaper_over_time";
  bool isIgnoringBatteryOptimizations = false;
  bool _changePeriodically = false;
  bool _changeOnLockScreen = false;

  @override
  void initState() {
    super.initState();
    _changeInterval = widget.sharedPrefs.getDouble('changeInterval') ??
        60.0; // default to 60 minutes
    _logger.info("Change interval retrieved: $_changeInterval");

    _changeMethod = WallpaperChangeMethod.values[
        widget.sharedPrefs.getInt('changeMethod') ??
            0]; // default to sequential
    _logger.info("Change method retrieved: $_changeMethod");

    checkDeviceManufacturer('huawei').then((result) {
      setState(() {
        isHuawei = result;
        _logger.info("Device is Huawei: $isHuawei");
        if (isHuawei) {
          width = MediaQuery.of(context).size.width;
          height = MediaQuery.of(context).size.height;
          _logger.info("Device dimensions: width: $width, height: $height");
        }
      });
    });
  }

  void _applySettings() async {
    stopService();

    List<String>? likedPhotoLinks = await checkLikedPhotoLinks();

    if (likedPhotoLinks == null) return;

    if (!await checkBatteryOptimizations()) return;

    _logger.info("Applying wallpaper settings");
    List<String> cachedLinks = await updateSharedPrefs(likedPhotoLinks);

    _logger.info("Registering new periodic task");
    await registerPeriodicTask(cachedLinks);
  }

  Future<List<String>?> checkLikedPhotoLinks() async {
    List<String>? likedPhotoLinks =
        widget.sharedPrefs.getStringList('likedPhotoLinks');

    if (likedPhotoLinks == null || likedPhotoLinks.isEmpty) {
      Fluttertoast.showToast(
          msg: "No wallpapers added",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      _logger.warning("No wallpapers added, exiting settings application");
      return null;
    }

    return likedPhotoLinks;
  }

  Future<bool> checkBatteryOptimizations() async {
    bool isIgnoringBatteryOptimizations =
        await BatteryOptimization.isIgnoringBatteryOptimizations();

    // Exit the function if the battery optimization settings are not ignored.
    if (!isIgnoringBatteryOptimizations) {
      _logger.warning(
          "Battery optimization settings are not ignored, showing dialog");
      await _showBatteryOptimizationDialog();
      isIgnoringBatteryOptimizations =
          await BatteryOptimization.isIgnoringBatteryOptimizations();
    }

    return isIgnoringBatteryOptimizations;
  }

  Future<void> _showBatteryOptimizationDialog() {
    _logger.info("Showing battery optimization dialog");
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Need for configuration'),
          content: const Text(
              'For the correct operation of the program, please remove the restrictions on the use of battery resources.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                _logger.info("User canceled battery optimization dialog");
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Go to settings'),
              onPressed: () {
                _logger
                    .info("User chose to go to battery optimization settings");
                Navigator.of(context).pop();
                BatteryOptimization.openBatteryOptimizationSettings();
              },
            ),
          ],
        );
      },
    );
  }

  Future<List<String>> updateSharedPrefs(List<String> likedPhotoLinks) async {
    List<String> cachedLinks = await copyFilesToCache(likedPhotoLinks);

    await widget.sharedPrefs.setStringList('cachedPhotoLinks', cachedLinks);
    await widget.sharedPrefs.setInt('changeMethod', _changeMethod.index);
    await widget.sharedPrefs.setString('linkSet', widget.linkSet);
    await widget.sharedPrefs.setBool('isHuawei', isHuawei);
    await widget.sharedPrefs.setDouble('width', width);
    await widget.sharedPrefs.setDouble('height', height);
    await widget.sharedPrefs
        .setString('changedEkranGlowny', changedEkranGlowny);
    await widget.sharedPrefs.setString('error', error);
    await widget.sharedPrefs.setInt('currentIndex', 0);

    return cachedLinks;
  }

  Future<void> registerPeriodicTask(List<String> cachedLinks) async {
    // This will stop any previous task and schedule a new one
    await Workmanager().cancelByUniqueName(periodicTaskKey);

    _logger.info('Registering new task with the following parameters:\n'
        'number_of_photos: ${cachedLinks.length}\n'
        'changeInterval: $_changeInterval\n'
        'changeMethod: $_changeMethod\n'
        'linkSet: ${widget.linkSet}\n'
        'isHuawei: $isHuawei\n'
        'width: $width\n'
        'height: $height\n');

    Fluttertoast.showToast(
        msg: "Periodic task registered",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);

    await Workmanager().registerPeriodicTask(
      periodicTaskKey,
      "simplePeriodicTask",
      frequency: Duration(minutes: _changeInterval.toInt()),
    );
  }

  Future<void> unregisterPeriodicTask() async {
    await Workmanager().cancelByUniqueName(periodicTaskKey);

    _logger.info('Unregistering task with the name: $periodicTaskKey');
  }

  startService() async {
    unregisterPeriodicTask();

    List<String>? likedPhotoLinks = await checkLikedPhotoLinks();

    if (likedPhotoLinks == null) return;

    List<String> cachedLinks = await updateSharedPrefs(likedPhotoLinks);

    _logger.info('Registering new task with the following parameters:\n'
        'number_of_photos: ${cachedLinks.length}\n'
        'changeInterval: $_changeInterval\n'
        'changeMethod: $_changeMethod\n'
        'linkSet: ${widget.linkSet}\n'
        'isHuawei: $isHuawei\n'
        'width: $width\n'
        'height: $height\n');

    String _ = await platform.invokeMethod('startService');

    Fluttertoast.showToast(
        msg: "Service registered",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  stopService() async {
    try {
      await platform.invokeMethod('stopService');
    } on PlatformException catch (e) {
      _logger.warning("Failed to stop service: '${e.message}'.");
    }
  }

  void _applySelectedOptions() {
    if (_changePeriodically) {
      _applySettings();
    }
    if (_changeOnLockScreen) {
      startService();
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.info("Building SettingsDrawerState");
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Settings'),
          ),
          SwitchListTile(
            title: const Text('Change periodically'),
            value: _changePeriodically,
            onChanged: (bool value) async {
              if (value) {
                isIgnoringBatteryOptimizations =
                    await BatteryOptimization.isIgnoringBatteryOptimizations();
              }
              setState(() {
                _changePeriodically = value;
                if (value) {
                  _changeOnLockScreen =
                      false; // disable the other option if this one is enabled
                }
              });
            },
          ),
          SwitchListTile(
            title: const Text('Change on lock screen'),
            value: _changeOnLockScreen,
            onChanged: (bool value) {
              setState(() {
                _changeOnLockScreen = value;
                if (value) {
                  _changePeriodically =
                      false; // disable the other option if this one is enabled
                }
              });
            },
          ),
          if (_changePeriodically)
            ChangeIntervalTile(
              changeInterval: _changeInterval,
              onChanged: (newValue) {
                setState(() {
                  _changeInterval = newValue;
                });
              },
            ),
          ChangeMethodTile(
            changeMethod: _changeMethod,
            onChanged: (newMethod) {
              setState(() {
                _changeMethod = newMethod;
              });
            },
          ),
          if (_changePeriodically || _changeOnLockScreen)
            ElevatedButton(
            onPressed: _applySelectedOptions,
            child: const Text('Apply settings'),
          ),
          if (_changePeriodically && !isIgnoringBatteryOptimizations)
            const ListTile(
              leading: Icon(Icons.warning, color: Colors.yellow),
              title: Text(
                  'Disable battery optimization for the correct changes over time'),
            ),
          if (_changePeriodically) // Show 'stop' button only if the option is active
            ElevatedButton(
              onPressed: () => {
                unregisterPeriodicTask(),
                Fluttertoast.showToast(
                    msg: "Periodic task unregistered",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0),
              },
              child: const Text('stop changes over time'),
            ),
          if (_changeOnLockScreen) // Show 'stop' button only if the option is active
            ElevatedButton(
              onPressed: () => {
                stopService(),
                Fluttertoast.showToast(
                    msg: "Service stopped",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0),
              },
              child: const Text('stop changes on lock'),
            ),
        ],
      ),
    );
  }
}
