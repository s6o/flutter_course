import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class RemoteStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/firebase.txt');
  }

  Future<String> readUrl() async {
    try {
      final file = await _localFile;

      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return null;
    }
  }

  Future<File> writeUrl(String url) async {
    final file = await _localFile;
    return file.writeAsString(url);
  }
}
