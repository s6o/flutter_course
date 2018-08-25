import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/user.dart';

typedef SyncCallback = void Function(Product p, User user);

class SyncButton extends StatelessWidget {
  final Product product;
  final SyncCallback syncCallback;
  final User user;

  SyncButton(this.product, this.syncCallback, this.user);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: product.inSync ? Colors.deepPurple : Colors.blueGrey,
      icon: Icon(product.inSync ? Icons.sync : Icons.sync_disabled),
      onPressed: () {
        syncCallback(product, user);
      },
    );
  }
}
