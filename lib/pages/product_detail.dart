import 'dart:async';
import 'package:flutter/material.dart';

import './product_info.dart';

class ProductDetailPage extends StatelessWidget {
  final int index;
  final Map<String, dynamic> product;

  ProductDetailPage(this.index, this.product);

  void _showConfirmationDialog(BuildContext context) {
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
      child: Scaffold(
        appBar: AppBar(
          title: Text('Product Detail'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ProductInfo(
              product,
              withDescription: true,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: RaisedButton(
                child: Text('DELETE'),
                onPressed: () => _showConfirmationDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
