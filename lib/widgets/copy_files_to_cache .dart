import 'dart:io';

import 'package:path_provider/path_provider.dart';

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