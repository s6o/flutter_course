import 'dart:core';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './product_edit.dart';
import '../models/product.dart';
import '../scoped-models/main_model.dart';
import '../widgets/sync_button.dart';

class ProductListPage extends StatefulWidget {
  final MainModel model;

  ProductListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductListState();
  }
}

class _ProductListState extends State<ProductListPage> {
  @override
  void initState() {
    if (widget.model.user != null) {
      widget.model.fetchProducts(widget.model.user);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        final List<Product> products = model.products;

        return RefreshIndicator(
          onRefresh: () => model.fetchProducts(model.user),
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: Key(
                    '${index.toString()}-${DateTime.now().toIso8601String()}'),
                background: Container(color: Colors.red),
                direction: DismissDirection.endToStart,
                onDismissed: (DismissDirection direction) {
                  if (direction == DismissDirection.endToStart) {
                    model.selectProduct(index)..deleteProduct(model.user);
                  }
                },
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(products[index].image),
                      ),
                      title: Text(products[index].title),
                      subtitle: Text('${products[index].price} €'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SyncButton(
                              products[index], model.syncProduct, model.user),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  model.selectProduct(index);
                                  return ProductEditPage();
                                }),
                              ).then((_) => model.selectProduct(null));
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                  ],
                ),
              );
            },
            itemCount: products.length,
          ),
        );
      },
    );
  }
}
