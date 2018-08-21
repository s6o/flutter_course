import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/remote_storage.dart';
import '../models/user.dart';

class UserModel extends Model {
  User _authenticatedUser;

  User get user {
    return _authenticatedUser;
  }

  void restoreUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String data = prefs.getString('user');
    if (data != null) {
      final User restoredUser = User.fromMap(json.decode(data));
      final DateTime current = DateTime.now().toUtc();
      if (current.millisecondsSinceEpoch <
          restoredUser.expiration().millisecondsSinceEpoch) {
        _authenticatedUser = restoredUser;
        notifyListeners();
      }
    }
  }

  Future<User> login(String email, String password) async {
    RemoteStorage rs = RemoteStorage();
    String url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=';

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final String apiKey = await rs.readApiKey();

    final http.Response response = await http.post(url + apiKey,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(authData));

    if (response.statusCode == 200) {
      return _createUser(response);
    } else {
      String msg = _errorMessage(response);
      return Future.error(msg);
    }
  }

  Future<User> signup(String email, String password) async {
    RemoteStorage rs = RemoteStorage();
    String url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=';

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final String apiKey = await rs.readApiKey();

    final http.Response response = await http.post(url + apiKey,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(authData));

    if (response.statusCode == 200) {
      return _createUser(response);
    } else {
      String msg = _errorMessage(response);
      return Future.error(msg);
    }
  }

  String _errorMessage(http.Response response) {
    final Map<String, dynamic> result = json.decode(response.body);
    if (result.containsKey('error')) {
      String msg = '${response.statusCode} | ${response.reasonPhrase}';

      switch (result['error']['message']) {
        case 'EMAIL_EXISTS':
          msg = 'The email is alreay in use.';
          break;

        case 'EMAIL_NOT_FOUND':
          msg = 'Unknown user.';
          break;

        case 'INVALID_PASSWORD':
          msg = 'Authentication failure.';
          break;

        case 'OPERATION_NOT_ALLOWED':
          msg = 'Password sign-in is disabled.';
          break;

        case 'TOO_MANY_ATTEMPTS_TRY_LATER':
          msg = 'Too many failed attempts, try again later.';
          break;

        case 'USER_DISABLED':
          msg = 'Access for user has been disabled.';
          break;
      }
      return msg;
    } else {
      return '${response.statusCode} | ${response.reasonPhrase}';
    }
  }

  Future<User> _createUser(http.Response response) {
    final Map<String, dynamic> result = json.decode(response.body);
    List<String> requiredKeys = [
      'localId',
      'email',
      'idToken',
      'refreshToken',
      'expiresIn'
    ];
    if (requiredKeys.every((String key) => result.containsKey(key))) {
      int expires = int.tryParse(result['expiresIn']);
      _authenticatedUser = User(
          id: result['localId'],
          email: result['email'],
          idToken: result['idToken'],
          refreshToken: result['refreshToken'],
          expirationPeriod: expires == null
              ? Duration(seconds: 3600)
              : Duration(seconds: expires));
      SharedPreferences.getInstance().then((SharedPreferences prefs) {
        prefs.setString('user', _authenticatedUser.toJson());
      }).catchError((e) {
        print('Failed to store User in SharedPreferences' + e.toString());
      });
      notifyListeners();
      return Future.value(_authenticatedUser);
    } else {
      return Future.error('Unexpected response, missing data to create user.');
    }
  }
}
