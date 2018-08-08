import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/product_info.dart';
import '../scoped-models/products_model.dart';

class ProductDetailPage extends StatelessWidget {
  final int index;

  ProductDetailPage(this.index);

  void _showConfirmationDialog(BuildContext context, ProductsModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('This action cannot be undone.'),
          actions: <Widget>[
            FlatButton(
              child: Text('DISCARD'),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text('CONTINUE'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, index);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, -1);
        return Future.value(false);
      },
      child: ScopedModelDescendant<ProductsModel>(
        builder: (BuildContext context, Widget child, ProductsModel model) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Product Detail'),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ProductInfo(
                  model.products[index],
                  withDescription: true,
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: RaisedButton(
                    child: Text('DELETE'),
                    textColor: Colors.yellowAccent,
                    onPressed: () => _showConfirmationDialog(context, model),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
