import 'package:flutter/material.dart';

typedef AddProductFn = void Function(Map<String, String>);

class ProductControl extends StatelessWidget {
  final AddProductFn addProduct;

  ProductControl(this.addProduct);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        addProduct({'title': 'Choclate', 'image': 'assets/food.jpg'});
      },
      color: Theme.of(context).primaryColorDark,
      textColor: Colors.yellowAccent,
      child: Text('Add Product'),
    );
  }
}
