import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<List<String>> copyFilesToCache(List<String> fileLinks) async {
  List<String> cachedFiles = [];
  Directory cacheDir = await getTemporaryDirectory();

  // Get a list of all files in the cache directory
  List<FileSystemEntity> cacheFiles = cacheDir.listSync();

  // Remove the files from cache directory which are not in fileLinks
  for (FileSystemEntity entity in cacheFiles) {
    if (entity is File) {
      if (!fileLinks.contains(entity.path)) {
        await entity.delete();
      }
    }
  }

  for (String link in fileLinks) {
    File file = File(link);
    String fileName = link.split('/').last; // split the link by '/' and get the last item
    String newPath = '${cacheDir.path}/$fileName';
    await file.copy(newPath);
    cachedFiles.add(newPath);
  }
  return cachedFiles;
}
