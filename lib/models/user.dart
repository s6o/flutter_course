import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';

class User {
  final String id;
  final String email;
  final String idToken;
  final String refreshToken;
  final Duration expirationPeriod;
  DateTime _birth;

  User(
      {@required this.id,
      @required this.email,
      @required this.idToken,
      @required this.refreshToken,
      @required this.expirationPeriod}) {
    _birth = DateTime.now().toUtc();
  }

  User.fromMap(Map<String, dynamic> m)
      : id = m['id'],
        email = m['email'],
        idToken = m['idToken'],
        refreshToken = m['refreshToken'],
        expirationPeriod = Duration(seconds: m['expiration']),
        _birth = DateTime.fromMillisecondsSinceEpoch(m['birth'], isUtc: true);

  DateTime expiration() {
    return _birth.add(expirationPeriod);
  }

  String toJson() {
    Map<String, dynamic> data = {
      'id': id,
      'email': email,
      'idToken': idToken,
      'refreshToken': refreshToken,
      'birth': _birth.millisecondsSinceEpoch,
      'expiration': expirationPeriod.inSeconds
    };
    return json.encode(data);
  }
}
