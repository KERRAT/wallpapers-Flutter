import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../../gen_l10n/app_localizations.dart';
import '../../widgets/check_device_manufacturer.dart';
import '../../widgets/set_wallpaper.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum WallpaperChangeMethod { sequential, random }

class SettingsDrawer extends StatefulWidget {
  final List<int> favoritePhotos;
  final String linkSet;

  const SettingsDrawer(
      {super.key, required this.favoritePhotos, required this.linkSet});

  @override
  SettingsDrawerState createState() => SettingsDrawerState();
}

class SettingsDrawerState extends State<SettingsDrawer> {
  late SharedPreferences _sharedPrefs;
  double _changeInterval = 15.0;
  String changedEkranGlowny = '';
  String error = '';
  double width = 0;
  double height = 0;
  bool isHuawei = false;
  WallpaperChangeMethod _changeMethod = WallpaperChangeMethod.sequential;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _sharedPrefs = prefs;
        _changeInterval =
            prefs.getDouble('changeInterval') ?? 15.0; // default to 10 minutes
        _changeMethod = WallpaperChangeMethod
            .values[prefs.getInt('changeMethod') ?? 0]; // default to sequential
      });
    });
    checkDeviceManufacturer('huawei').then((result) {
      setState(() {
        isHuawei = result;
        if (isHuawei) {
          width = MediaQuery.of(context).size.width;
          height = MediaQuery.of(context).size.height;
        }
      });
    });
  }

  void _applySettings() async {
    List<String> likedPhotoLinks = _sharedPrefs.getStringList('likedPhotoLinks') ?? [];

    if(likedPhotoLinks.isEmpty){
      Fluttertoast.showToast(
          msg: "no wallpapes added",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return;
    }

    List<String> cachedLinks = await copyFilesToCache(likedPhotoLinks);
    await _sharedPrefs.setStringList('cachedPhotoLinks', cachedLinks);
    await _sharedPrefs.setDouble('changeInterval', _changeInterval);
    await _sharedPrefs.setInt('changeMethod', _changeMethod.index);
    await _sharedPrefs.setString('linkSet', widget.linkSet);
    await _sharedPrefs.setBool('isHuawei', isHuawei);
    await _sharedPrefs.setDouble('width', width);
    await _sharedPrefs.setDouble('height', height);
    await _sharedPrefs.setString('changedEkranGlowny', changedEkranGlowny);
    await _sharedPrefs.setString('error', error);
    await _sharedPrefs.setInt('currentIndex', 0);



    // This unique name is used to identify this task. It must be unique among all tasks.
    const simpleTaskKey = "simpleTask";

    // This will stop any previous task and schedule a new one
    await Workmanager().cancelByUniqueName(simpleTaskKey);

    Fluttertoast.showToast(
        msg: "Periodic task registered",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

    await Workmanager().registerPeriodicTask(
      simpleTaskKey,
      "simplePeriodicTask",
      frequency: Duration(minutes: _changeInterval.toInt()),
    );
  }

  Future<List<String>> copyFilesToCache(List<String> fileLinks) async {
    List<String> cachedFiles = [];
    for (String link in fileLinks) {
      File file = File(link);
      String fileName = link.split('/').last; // split the link by '/' and get the last item
      Directory cacheDir = await getTemporaryDirectory();
      String newPath = '${cacheDir.path}/$fileName';
      await file.copy(newPath);
      cachedFiles.add(newPath);
    }
    return cachedFiles;
  }


  String getReadableInterval(double value) {
    if (value < 60.0) {
      return '${value.round().toString()} m';
    } else {
      return '${(value / 60.0).round().toString()} hr';
    }
  }

  double getSliderValue(double value) {
    if (value <= 60.0) {
      return value / 5.0;
    } else {
      return 12.0 + (value - 60.0) / 60.0;
    }
  }

  double getRealValue(double value) {
    if (value <= 12.0) {
      return value * 5.0;
    } else {
      return 60.0 + (value - 12.0) * 60.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    changedEkranGlowny = AppLocalizations.of(context).wallpaper_changed_ekran_glowny;
    error = AppLocalizations.of(context).error;
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
          ListTile(
            title: const Text('Change Interval'),
            subtitle: Slider(
              value: getSliderValue(_changeInterval),
              min: 3.0,
              max: 35.0, // 12 * 5 minutes + 24 hours
              divisions: 32, // to provide 5 minutes and 1 hour steps
              onChanged: (newValue) {
                setState(() {
                  _changeInterval = getRealValue(newValue);
                });
              },
              label: getReadableInterval(_changeInterval),
            ),
            trailing: SizedBox(
              width: 35.0, // you can adjust this value as per your requirement
              child: Text(
                getReadableInterval(_changeInterval),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          ListTile(
            title: const Text('Change Method'),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _changeMethod == WallpaperChangeMethod.sequential
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _changeMethod = WallpaperChangeMethod.sequential;
                    });
                  },
                  child: const Text(
                    'Sequential',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _changeMethod == WallpaperChangeMethod.random
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _changeMethod = WallpaperChangeMethod.random;
                    });
                  },
                  child: const Text(
                    'Random',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _applySettings,
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int changeMethodIndex = prefs.getInt('changeMethod') ?? 0;
    WallpaperChangeMethod changeMethod =
    WallpaperChangeMethod.values[changeMethodIndex];

    List<String> cachedPhotoLinks = prefs.getStringList('cachedPhotoLinks') ?? [];
    bool isHuawei = prefs.getBool('isHuawei') ?? false;
    double width = prefs.getDouble('width') ?? 0;
    double height = prefs.getDouble('height') ?? 0;
    String changedEkranGlowny = prefs.getString('changedEkranGlowny') ?? '';
    String error = prefs.getString('error') ?? '';

    if (changeMethod == WallpaperChangeMethod.sequential) {
      int currentIndex = prefs.getInt('currentIndex') ?? 0;
      if (currentIndex >= cachedPhotoLinks.length) {
        currentIndex = 0;
      }
      await WallpaperHandler.setWallpaperHome(
          file: File(cachedPhotoLinks[currentIndex]),
          successTest: changedEkranGlowny,
          errorText: error,
          resize: isHuawei,
          width: width,
          height: height);
      prefs.setInt('currentIndex', currentIndex + 1);
    } else {
      var rng = Random();
      int randomIndex = rng.nextInt(cachedPhotoLinks.length);
      await WallpaperHandler.setWallpaperHome(
          file: File(cachedPhotoLinks[randomIndex]),
          successTest: changedEkranGlowny,
          errorText: error,
          resize: isHuawei,
          width: width,
          height: height);
    }

    return Future.value(true);
  });
}