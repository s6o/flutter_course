import 'package:flutter/material.dart';

import './pages/product_info.dart';

typedef DeleteFn = void Function(int i);

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final DeleteFn deleteProduct;

  Products(this.products, {this.deleteProduct});

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          ProductInfo(products[index]),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(Icons.info),
                onPressed: () => Navigator
                    .pushNamed<int>(context, '/product/' + index.toString())
                    .then<void>((int rindex) => deleteProduct(rindex)),
              ),
              IconButton(
                color: Colors.red,
                icon: Icon(Icons.favorite),
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return products.length > 0
        ? ListView.builder(
            itemBuilder: _buildProductItem,
            itemCount: products.length,
          )
        : Center(child: Text('No products, add some.'));
  }
}
