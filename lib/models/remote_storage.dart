import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class RemoteStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFirebaseApiKey async {
    final path = await _localPath;
    return File('$path/fbapikey.txt');
  }

  Future<File> get _localMapApiKey async {
    final path = await _localPath;
    return File('$path/gmapikey.txt');
  }

  Future<File> get _localFileFirebase async {
    final path = await _localPath;
    return File('$path/firebase.txt');
  }

  Future<bool> isSetupComplete() {
    return Future.wait([
      _localFirebaseApiKey.then((File f) => f.exists()),
      _localMapApiKey.then((File f) => f.exists()),
      _localFileFirebase.then((File f) => f.exists()),
      readFirebaseApiKey().then((String ak) => ak != null && ak.isNotEmpty),
      readUrl().then(isValidUrl),
    ]).then((List<bool> flags) => flags.every((bool f) => f));
  }

  bool isValidUrl(String url) {
    return url.startsWith('https://') && url.endsWith('firebaseio.com/');
  }

  Future<String> readFirebaseApiKey() async {
    try {
      final file = await _localFirebaseApiKey;

      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return null;
    }
  }

  Future<String> readMapApiKey() async {
    try {
      final file = await _localMapApiKey;

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

  Future<File> writeFirebaseApiKey(String ak) async {
    final file = await _localFirebaseApiKey;
    return file.writeAsString(ak);
  }

  Future<File> writeMapApiKey(String ak) async {
    final file = await _localMapApiKey;
    return file.writeAsString(ak);
  }

  Future<File> writeUrl(String url) async {
    final file = await _localFileFirebase;
    return file.writeAsString(url);
  }
}
