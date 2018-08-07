import 'package:flutter/material.dart';

import './product_card.dart';
import '../models/product.dart';

typedef DeleteFn = void Function(int i);

class ProductsAll extends StatelessWidget {
  final List<Product> products;
  final DeleteFn deleteProduct;

  ProductsAll(this.products, {this.deleteProduct});

  @override
  Widget build(BuildContext context) {
    return products.length > 0
        ? ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                ProductCard(products[index], index, deleteProduct),
            itemCount: products.length,
          )
        : Center(child: Text('No products, add some.'));
  }
}
