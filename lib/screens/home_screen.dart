import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/main.dart';
import 'package:flutter_tasks_app/screens/drawers/custom_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../gen_l10n/app_localizations.dart';
import 'photos/list.dart';
import 'package:flutter_tasks_app/models/app_data.dart';
import 'package:logging/logging.dart';
import 'package:flutter_svg/svg.dart';

final _logger = Logger('MyHomePage');

// MyHomePage is a StatefulWidget that displays the main screen.
class MyHomePage extends StatefulWidget {
  final String language;
  const MyHomePage({Key? key, required this.language}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

// _MyHomePageState is the state object for MyHomePage.
class MyHomePageState extends State<MyHomePage> {
  late Future<AppData> _appDataFuture;
  late AppData _appData;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedCategoryId = '';
  late String _currentLanguage;
  final Map<String, String> _languageNames = {
    'en': 'English',
    'de': 'Deutsch',
    'es': 'Española',
    'pl': 'Polski'
  };

  // initState is called when the state object is created.
  @override
  void initState() {
    super.initState();
    _logger.finest('Initializing MyHomePage');
    _currentLanguage = widget.language;
    _appDataFuture = _fetchAppData();
  }

  Future<void> _onLanguageSelected(
      String language, BuildContext context) async {
    _logger.finest('Language selected: $language');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', language);
    setState(() {
      _currentLanguage = MyApp.of(context)?.setLocale(language) ?? 'en';
      _appDataFuture = _fetchAppData();
    });
  }

  void _onCategorySelected(String categoryId) {
    _logger.finest('Category selected: $categoryId');
    setState(() {
      _selectedCategoryId = categoryId;
    });
  }

  // _fetchAppData fetches AppData from the remote server.
  Future<AppData> _fetchAppData() async {
    _logger.finest('Fetching AppData');
    try {
      final response = await http.get(Uri.parse(
          'https://cf-phonewall4k.com/android/serwery_glowna.json'));
      if (response.statusCode == 200) {
        _logger.finest('AppData fetched successfully');
        return AppData.fromJson(jsonDecode(response.body));
      } else {
        _logger.warning(
            'Failed to load AppData from main server, status code: ${response.statusCode}');
        throw Exception('Failed to load AppData from main server');
      }
    } catch (e) {
      _logger.warning('Failed to load AppData from main server, trying secondary server');
      final response = await http.get(Uri.parse(
          'http://phonewall4k.com/android/serwery_glowna.json'));
      if (response.statusCode == 200) {
        _logger.finest('AppData fetched successfully from secondary server');
        return AppData.fromJson(jsonDecode(response.body));
      } else {
        _logger.warning(
            'Failed to load AppData from secondary server, status code: ${response.statusCode}');
        throw Exception('Failed to load AppData from secondary server');
      }
    }
  }

  // build returns the widget tree for MyHomePage.
  @override
  Widget build(BuildContext context) {
    _logger.finest('Building MyHomePage');
    return FutureBuilder<AppData>(
      future: _appDataFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _appData = snapshot.data!;
          return Scaffold(
            key: _scaffoldKey,
            body: Stack(
              children: [
                PhotosList(
                  appData: _appData,
                  lng: _currentLanguage,
                ),
                Positioned(
                  top: 50,
                  left: 10,
                  child: FloatingActionButton(
                    heroTag: 'menu_fab', // Add a unique hero tag
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    backgroundColor: Colors.transparent,
                    elevation: 20,
                    child: Transform.scale(
                      scale: 1.5, // adjust the scale factor to the desired size
                      child: SvgPicture.asset(
                        'assets/menu/menu_hamburger-01.svg',
                      ),
                    ),
                  ),
                ),

              ],
            ),
            drawer: CustomDrawer(
              onCategorySelected: _onCategorySelected,
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(AppLocalizations.of(context)?.error_occurred ??
                  'An error has occurred!'),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
