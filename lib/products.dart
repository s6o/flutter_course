import 'package:flutter/material.dart';

typedef DeleteFn = void Function(int i);

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final DeleteFn deleteProduct;

  Products(this.products, {this.deleteProduct});

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(products[index]['image']),
          Text(products[index]['title']),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text('Details'),
                onPressed: () => Navigator
                    .pushNamed<int>(context, '/product/' + index.toString())
                    .then<void>((int rindex) => deleteProduct(rindex)),
              )
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
