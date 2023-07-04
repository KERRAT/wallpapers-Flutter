import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

final _logger = Logger('ImageShare');

Future<void> shareImage(String imageUrl) async {
  try {
    http.Response response = await http.get(Uri.parse(imageUrl));

    // Check if the request was successful
    if (response.statusCode == 200) {
      _logger.info("Image downloaded successfully");
    } else {
      _logger.warning(
          "Error downloading image: HTTP status ${response.statusCode}");
      return;
    }

    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/card.png';
    File(path).writeAsBytesSync(response.bodyBytes);

    await Share.shareXFiles([XFile(path)]);
  } on PlatformException catch (error) {
    _logger.warning(
        "PlatformException: code: ${error.code}, message: ${error.message}");
  }
}
