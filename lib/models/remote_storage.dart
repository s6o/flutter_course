import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class RemoteStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFileApiKey async {
    final path = await _localPath;
    return File('$path/apikey.txt');
  }

  Future<File> get _localFileFirebase async {
    final path = await _localPath;
    return File('$path/firebase.txt');
  }

  Future<bool> isSetupComplete() {
    return Future.wait([
      _localFileApiKey.then((File f) => f.exists()),
      _localFileFirebase.then((File f) => f.exists()),
      readApiKey().then((String ak) => ak != null && ak.isNotEmpty),
      readUrl().then(isValidUrl),
    ]).then((List<bool> flags) => flags.every((bool f) => f));
  }

  bool isValidUrl(String url) {
    return url.startsWith('https://') && url.endsWith('firebaseio.com/');
  }

  Future<String> readApiKey() async {
    try {
      final file = await _localFileApiKey;

      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return null;
    }
  }

  Future<String> readUrl() async {
    try {
      final file = await _localFileFirebase;

      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return null;
    }
  }

  Future<File> writeApiKey(String ak) async {
    final file = await _localFileApiKey;
    return file.writeAsString(ak);
  }

  Future<File> writeUrl(String url) async {
    final file = await _localFileFirebase;
    return file.writeAsString(url);
  }
}
