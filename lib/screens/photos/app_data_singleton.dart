import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import '../../models/app_data.dart';

final _logger = Logger('AppDataRepository');

class AppDataRepository {
  static final AppDataRepository _appDataRepository = AppDataRepository._internal();

  factory AppDataRepository() {
    return _appDataRepository;
  }

  AppDataRepository._internal();

  AppData? _appData;
  http.Client client = http.Client();

  Future<AppData> fetchAppData() async {
    if (_appData != null) {
      return _appData!;
    } else {
      _appData = await _fetchAppData();
      return _appData!;
    }
  }

  Future<AppData> _fetchAppData() async {
    _logger.finest('Fetching AppData');
    try {
      final response = await client.get(
          Uri.parse('https://cf-phonewall4k.com/android/serwery_glowna.json')
      );
      if (response.statusCode == 200) {
        _logger.finest('AppData fetched successfully');
        return AppData.fromJson(jsonDecode(response.body));
      } else {
        _logger.warning(
            'Failed to load AppData from main server, status code: ${response.statusCode}'
        );
        throw Exception('Failed to load AppData from main server');
      }
    } catch (e) {
      _logger.warning(
          'Failed to load AppData from main server, trying secondary server'
      );
      final response = await client.get(
          Uri.parse('http://phonewall4k.com/android/serwery_glowna.json')
      );
      if (response.statusCode == 200) {
        _logger.finest('AppData fetched successfully from secondary server');
        return AppData.fromJson(jsonDecode(response.body));
      } else {
        _logger.warning(
            'Failed to load AppData from secondary server, status code: ${response.statusCode}'
        );
        throw Exception('Failed to load AppData from secondary server');
      }
    }
  }
}
