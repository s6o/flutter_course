import 'package:flutter/material.dart';

import './products.dart';

class AllProducts extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function addProduct;
  final Function deleteProduct;

  AllProducts(this.products, this.addProduct, this.deleteProduct);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: EdgeInsets.all(10.0),
      ),
      Expanded(
        child: Products(
          products,
          deleteProduct: deleteProduct,
        ),
      ),
    ]);
  }
}
