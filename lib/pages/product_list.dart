import 'dart:core';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './product_edit.dart';
import '../models/product.dart';
import '../scoped-models/products_model.dart';

class ProductListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        final List<Product> products = model.products;

        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(
                  '${index.toString()}-${DateTime.now().toIso8601String()}'),
              background: Container(color: Colors.red),
              direction: DismissDirection.endToStart,
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  model.selectProduct(index)..deleteProduct();
                }
              },
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(products[index].image),
                    ),
                    title: Text(products[index].title),
                    subtitle: Text('${products[index].price} €'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                            model.selectProduct(index);
                            return ProductEditPage();
                          }),
                        );
                      },
                    ),
                  ),
                  Divider(),
                ],
              ),
            );
          },
          itemCount: products.length,
        );
      },
    );
  }
}
