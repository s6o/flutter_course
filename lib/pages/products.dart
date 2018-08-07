import 'package:flutter/material.dart';

import '../widgets/products_all.dart';
import '../models/product.dart';

class ProductsPage extends StatelessWidget {
  final List<Product> products;
  final Function addProduct;
  final Function deleteProduct;

  ProductsPage(this.products, this.addProduct, this.deleteProduct);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Choose'),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Manage Products'),
              onTap: () => Navigator.pushNamed(context, '/admin'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {},
          ),
        ],
      ),
      body: ProductsAll(products, deleteProduct: deleteProduct),
    );
  }
}
