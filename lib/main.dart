// Importing necessary packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tasks_app/screens/drawers/end_drawer.dart';
import 'package:flutter_tasks_app/screens/internet_connection_checker.dart';
import 'package:flutter_tasks_app/widgets/like_controller.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:workmanager/workmanager.dart';

import 'gen_l10n/app_localizations.dart';


// Setting up logger for the main file
final _logger = Logger('main');

void main() async {
  // Attaching color formatter to logger
  PrintAppender(formatter: const ColorFormatter()).attachToLogger(Logger.root);

  WidgetsFlutterBinding.ensureInitialized();

  // This will initialize the WorkManager with an entrypoint of backgroundCallbackDispatcher (see below)
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true, // Should be false in production code.
  );

  // Setting system UI mode and style
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  // Setting preferred device orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  _logger.finest('App started');

  Locale deviceLocale = WidgetsBinding.instance.window.locale;

  bool isLocaleSupported = AppLocalizations.localizationsDelegates
      .any((delegate) => delegate.isSupported(deviceLocale));

  if (!isLocaleSupported) {
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
          language: deviceLocale
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final Locale language;

  const MyApp({Key? key, required this.language}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();

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
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  child: child!));
        },
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
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
