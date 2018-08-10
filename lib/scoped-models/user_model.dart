import 'package:scoped_model/scoped_model.dart';

import '../models/user.dart';

class UserModel extends Model {
  User _authenticatedUser;

  User get user {
    return _authenticatedUser;
  }

  void login(String email, String password) {
    _authenticatedUser = User(id: 'XXX', email: email, password: password);
  }
}