import 'package:flutter/material.dart';

class Product {
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

  Product.fromProductWithFavorite(Product p, bool favorite)
      : title = p.title,
        description = p.description,
        price = p.price,
        image = p.image,
        isFavorite = favorite;

  Product.fromMap(Map<String, dynamic> m)
      : title = m['title'],
        description = m['description'],
        price = m['price'],
        image = m['image'],
        isFavorite = false;
}
