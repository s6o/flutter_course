import 'package:flutter/material.dart';

import './product_info.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final int index;
  final Function deleteProduct;

  ProductCard(this.product, this.index, this.deleteProduct);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ProductInfo(product),
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
}
