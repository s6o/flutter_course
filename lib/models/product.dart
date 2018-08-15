import 'package:flutter/material.dart';

class Product {
  int _localId = 0;
  String _remoteId = '';
  bool _inSync = false;
  bool _inTrash = false;
  final String userId;
  final String userEmail;

  final String title;
  final String description;
  final double price;
  final String image;
  final bool isFavorite;

  Product(
      {@required this.userId,
      @required this.userEmail,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.image,
      this.isFavorite = false});

  Product.fromMap(Map<String, dynamic> m)
      : _localId = m.containsKey('lid') ? m['lid'] : 0,
        _remoteId = m.containsKey('rid') ? m['rid'] : '',
        userId = m.containsKey('uid') ? m['uid'] : 'XXX',
        userEmail = m.containsKey('email') ? m['email'] : 'tester@test.com',
        title = m.containsKey('title') ? m['title'] : 'Unknown product',
        description = m.containsKey('desc') ? m['desc'] : '',
        price = m.containsKey('price') ? m['price'] : 0.00,
        image = m.containsKey('image')
            ? (m['image'] != null
                ? m['image']
                : 'https://images.yourstory.com/2016/08/125-fall-in-love.png?auto=compress')
            : 'https://images.yourstory.com/2016/08/125-fall-in-love.png?auto=compress',
        isFavorite = m.containsKey('isfav') ? m['isfav'] : false;

  Product.fromMapWithMerge(Map<String, dynamic> m, Product p)
      : _localId = m.containsKey('lid') ? m['lid'] : p.localId,
        _remoteId = m.containsKey('rid') ? m['rid'] : p.remoteId,
        userId = m.containsKey('uid') ? m['uid'] : p.userId,
        userEmail = m.containsKey('email') ? m['email'] : p.userEmail,
        title = m.containsKey('title') ? m['title'] : p.title,
        description = m.containsKey('desc') ? m['desc'] : p.description,
        price = m.containsKey('price') ? m['price'] : p.price,
        image = m.containsKey('image')
            ? (m['image'] != null ? m['image'] : p.image)
            : p.image,
        isFavorite = m.containsKey('isfav') ? m['isfav'] : p.isFavorite;

  Product.fromMapWithUser(Map<String, dynamic> m, String uid, String email)
      : _localId = m.containsKey('lid') ? m['lid'] : 0,
        _remoteId = m.containsKey('rid') ? m['rid'] : '',
        userId = uid,
        userEmail = email,
        title = m.containsKey('title') ? m['title'] : 'Unknown product',
        description = m.containsKey('desc') ? m['desc'] : '',
        price = m.containsKey('price') ? m['price'] : 0.00,
        image = m.containsKey('image')
            ? (m['image'] != null
                ? m['image']
                : 'https://images.yourstory.com/2016/08/125-fall-in-love.png?auto=compress')
            : 'https://images.yourstory.com/2016/08/125-fall-in-love.png?auto=compress',
        isFavorite = m.containsKey('isfav') ? m['isfav'] : false;

  Product.fromProductWithFavorite(Product p, bool favorite)
      : _localId = p.localId,
        _remoteId = p.remoteId,
        userId = p.userId,
        userEmail = p.userEmail,
        title = p.title,
        description = p.description,
        price = p.price,
        image = p.image,
        isFavorite = favorite;

  bool get inSync {
    return _inSync;
  }

  bool get inTrash {
    return _inTrash;
  }

  int get localId {
    return _localId;
  }

  String get remoteId {
    return _remoteId;
  }

  Product setLocaId(int id) {
    _localId = id;
    return this;
  }

  Product setRemoteId(String id) {
    _remoteId = id;
    return this;
  }

  Product setInSync(bool flag) {
    _inSync = flag;
    return this;
  }

  Product toTrash() {
    _inTrash = true;
    return this;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> m = {
      'lid': _localId,
      'uid': userId,
      'email': userEmail,
      'title': title,
      'desc': description,
      'price': price,
      'image': image,
      'isfav': isFavorite
    };
    if (_remoteId != null && _remoteId.length > 0) {
      m['rid'] = _remoteId;
    }
    return m;
  }
}
