// Importing necessary packages
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../gen_l10n/app_localizations.dart';
import 'home_screen.dart';

// Setting up logger for InternetConnectionChecker
final _logger = Logger('InternetConnectionChecker');

class InternetConnectionChecker extends StatefulWidget {
  final String language;

  const InternetConnectionChecker({Key? key, required this.language}) : super(key: key);

  @override
  InternetConnectionCheckerState createState() => InternetConnectionCheckerState();
}

class InternetConnectionCheckerState extends State<InternetConnectionChecker> with WidgetsBindingObserver {
  bool _connected = true;
  bool _isScreenActive = true;
  String _message = "Connected";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _logger.finest('Initializing InternetConnectionChecker');
    _checkConnection();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _isScreenActive = true;
    } else {
      _isScreenActive = false;
    }
  }

  // Method to check internet connection status
  void _checkConnection() async {
    while (true) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      bool currentConnection = connectivityResult != ConnectivityResult.none;
      if (_connected != currentConnection) {
        setState(() {
          _connected = currentConnection;
          _message = _connected ? "Connected" : AppLocalizations.of(context).no_internet_connection;
        });
        _logger.finest('Internet connection status changed: $_connected');
      }
      await Future.delayed(const Duration(seconds: 3));
    }
  }

  // Building the widget based on the connection status
  @override
  Widget build(BuildContext context) {
    _logger.finest('Building InternetConnectionChecker');
    return Scaffold(
      body: Center(
        child: _connected
            ? MyHomePage(language: widget.language)
            : _isScreenActive
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(_message),
          ],
        )
            : Container(),
      ),
    );
  }
}
