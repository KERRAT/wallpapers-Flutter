// Importing necessary packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tasks_app/screens/internet_connection_checker.dart';
import 'package:flutter_tasks_app/widgets/like_controller.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizer/sizer.dart';

import 'gen_l10n/app_localizations.dart';


// Setting up logger for the main file
final _logger = Logger('main');

void main() async {
  // Attaching color formatter to logger
  PrintAppender(formatter: const ColorFormatter()).attachToLogger(Logger.root);

  // Ensuring Widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Setting system UI mode and style
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  // Setting preferred device orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  _logger.finest('App started');

  // Setting up available locales
  Set<Locale> availableLocales = MyApp._availableLocales;

  // Loading saved language preference
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedLanguage = prefs.getString('selected_language');
  Locale deviceLocale = WidgetsBinding.instance.window.locale;

  // Checking if device locale is supported
  if (!availableLocales
      .any((locale) => locale.languageCode == deviceLocale.languageCode)) {
    deviceLocale = const Locale('en');
  }

  // Running the app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LikeState()),
        // add other providers here
      ],
      child: MyApp(
          language: savedLanguage != null ? Locale(savedLanguage) : deviceLocale
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final Locale language;

  const MyApp({Key? key, required this.language}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();

  // List of supported locales
  static final Set<Locale> _availableLocales = {
    const Locale('en'),
    const Locale('de'),
    const Locale('es'),
    const Locale('pl'),
  };

  // Getter for available locales
  static Set<Locale> get availableLocales => _availableLocales;

  // Method to get ancestor state of MyAppState
  static MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>();
}

class MyAppState extends State<MyApp> {
  late Locale _locale;

  get locale => _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.language;
    _logger
        .finest('MyAppState initialized with locale: ${_locale.languageCode}');
  }

  // Method to set locale
  String setLocale(String language) {
    setState(() {
      _locale = Locale(language);
    });
    _logger.finest('Locale changed to: ${_locale.languageCode}');
    return _locale.languageCode;
  }

  // Building the MaterialApp with localization support
  @override
  Widget build(BuildContext context) {
    _logger.finest('Building MaterialApp');
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: DefaultTextStyle(
                  child: child!,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)));
        },
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: MyApp._availableLocales.toList(),
        locale: _locale,
        home: ChangeNotifierProvider(
          create: (context) => LikeState(),
          child: Scaffold(
            body: InternetConnectionChecker(
              language: _locale.languageCode,
            ),
          ),
        ),
      );
    });
  }
}
