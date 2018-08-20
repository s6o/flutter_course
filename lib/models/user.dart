import 'package:flutter/material.dart';

class User {
  final String id;
  final String email;
  final String idToken;
  final String refreshToken;
  final int expiresInSeconds;

  User(
      {@required this.id,
      @required this.email,
      @required this.idToken,
      @required this.refreshToken,
      @required this.expiresInSeconds});
}
