import 'package:flutter/material.dart';

import '../models/product.dart';

typedef SyncCallback = void Function(Product p, String idToken);

class SyncButton extends StatelessWidget {
  final Product product;
  final SyncCallback syncCallback;
  final String idToken;

  SyncButton(this.product, this.syncCallback, this.idToken);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: product.inSync ? Colors.deepPurple : Colors.blueGrey,
      icon: Icon(product.inSync ? Icons.sync : Icons.sync_disabled),
      onPressed: () {
        syncCallback(product, idToken);
      },
    );
  }
}
