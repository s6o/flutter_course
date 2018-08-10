import 'package:flutter/material.dart';

class Product {
  String _id = '';
  final String title;
  final String description;
  final double price;
  final String image;
  final bool isFavorite;

  Product(
      {@required this.title,
      @required this.description,
      @required this.price,
      @required this.image,
      this.isFavorite = false});

  Product.fromMap(Map<String, dynamic> m)
      : _id = m['id'],
        title = m['title'],
        description = m.containsKey('desc') ? m['desc'] : m['description'],
        price = m['price'],
        image = m['image'],
        isFavorite = m.containsKey('isfav') ? m['isfav'] : false;

  Product.fromProductWithFavorite(Product p, bool favorite)
      : _id = p.id,
        title = p.title,
        description = p.description,
        price = p.price,
        image = p.image,
        isFavorite = favorite;

  String get id {
    return _id;
  }

  Product setId(String id) {
    id = id;
    return this;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> m = {
      'title': title,
      'desc': description,
      'price': price,
      'image':
          'https://beautifulmuslim.files.wordpress.com/2015/05/images-duckduckgo-com1.jpeg',
      'isfav': isFavorite
    };
    if (_id.length > 0) {
      m['id'] = id;
    }
    return m;
  }
}
