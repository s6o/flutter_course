import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/product_card.dart';
import '../scoped-models/main_model.dart';
import '../widgets/logout_tile.dart';

class ProductsPage extends StatefulWidget {
  final MainModel model;

  ProductsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductsState();
  }
}

class _ProductsState extends State<ProductsPage> {
  @override
  void initState() {
    if (widget.model.user != null) {
      widget.model.fetchProducts(widget.model.user);
    }
    super.initState();
  }

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
            Divider(),
            LogoutTile(),
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
          return RefreshIndicator(
              onRefresh: () => model.fetchProducts(model.user),
              child: _buildProductList(context, model));
        },
      ),
    );
  }

  Widget _buildProductList(BuildContext context, MainModel model) {
    return model.displayedProducts(model.user).length > 0
        ? ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                ProductCard(index),
            itemCount: model.displayedProducts(model.user).length,
          )
        : Center(child: Text('No products, add some.'));
  }
}
