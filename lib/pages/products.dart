import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/product_card.dart';
import '../models/product.dart';
import '../scoped-models/main_model.dart';

class ProductsPage extends StatelessWidget {
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
          ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
            return IconButton(
              icon: Icon(model.displayFavoritesOnly
                  ? Icons.favorite
                  : Icons.favorite_border),
              onPressed: () => model.toggleShowFavaorites(),
            );
          }),
        ],
      ),
      body: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return _buildProductList(context, model);
        },
      ),
    );
  }

  Widget _buildProductList(BuildContext context, MainModel model) {
    final List<Product> products = model.displayedProducts;

    return products.length > 0
        ? ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                ProductCard(index),
            itemCount: products.length,
          )
        : Center(child: Text('No products, add some.'));
  }
}
