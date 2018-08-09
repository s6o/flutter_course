import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './product_info.dart';
import '../models/product.dart';
import '../scoped-models/main_model.dart';

class ProductCard extends StatelessWidget {
  final int index;

  ProductCard(this.index);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      final Product product = model.displayedProducts[index];
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
                  onPressed: () {
                    Navigator
                        .pushNamed<int>(context, '/product/' + index.toString())
                        .then<void>((int rindex) {
                      if (rindex >= 0) {
                        model.selectProduct(rindex)..deleteProduct();
                      }
                    });
                  },
                ),
                IconButton(
                  color: Colors.red,
                  icon: Icon(product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  onPressed: () {
                    model.selectProduct(index)..toggleFavorite();
                  },
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
