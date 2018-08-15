import 'package:flutter/material.dart';

import '../models/product.dart';

typedef SyncCallback = void Function(Product p);

class SyncButton extends StatelessWidget {
  final Product product;
  final SyncCallback syncCallback;

  SyncButton(this.product, this.syncCallback);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: product.inSync ? Colors.deepPurple : Colors.blueGrey,
      icon: Icon(product.inSync ? Icons.sync : Icons.sync_disabled),
      onPressed: () {
        syncCallback(product);
      },
    );
  }
}
