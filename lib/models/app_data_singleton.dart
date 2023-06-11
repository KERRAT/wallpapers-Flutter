import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'app_data.dart';

final _logger = Logger('AppDataRepository');

class AppDataRepository {
  static final AppDataRepository _appDataRepository =
      AppDataRepository._internal();

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
          Uri.parse('https://cf-phonewall4k.com/android/serwery_glowna.json'));
      if (response.statusCode == 200) {
        _logger.finest('AppData fetched successfully');
        return AppData.fromJson(jsonDecode(response.body));
      } else {
        _logger.warning(
            'Failed to load AppData from main server, status code: ${response.statusCode}');
        throw Exception('Failed to load AppData from main server');
      }
    } catch (e) {
      _logger.warning(
          'Failed to load AppData from main server, trying secondary server');
      final response = await client
          .get(Uri.parse('http://phonewall4k.com/android/serwery_glowna.json'));
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

  Future<AppData> fetchCategoryData(String categoryId) async {
    _logger.finest('Fetching Category Data for id: $categoryId');

    // If _appData is null, fetch it
    if (_appData == null) {
      _logger.info('AppData is null, fetching AppData first');
      _appData = await fetchAppData();
    }

    final response = await client.get(
        Uri.parse(_appData!.categories.replaceAll('[ID_KAT]', categoryId)));
    if (response.statusCode == 200) {
      _logger.finest('Category Data fetched successfully');
      Map<String, dynamic> responseData = jsonDecode(response.body);
      // Creating new AppData with updated "new" and "top" fields
      try {
        List<int>? newItems;
        List<int>? top;

        if (responseData["new"] != null) {
          newItems = (responseData["new"] as String)
              .split(",")
              .map((e) => int.parse(e))
              .toList();
        }

        if (responseData["top"] != null) {
          top = (responseData["top"] as String)
              .split(",")
              .map((e) => int.parse(e))
              .toList();
        }

        _appData = _appData?.copyWith(
          newItems: newItems,
          top: top,
        );
      } catch (e) {
        _logger.warning('Failed to process responseData: $e');
      }

      return _appData!;
    } else {
      _logger.warning(
          'Failed to load Category Data, status code: ${response.statusCode}');
      throw Exception('Failed to load Category Data');
    }
  }
}
