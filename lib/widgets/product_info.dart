import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductInfo extends StatelessWidget {
  final Product product;
  final bool withDescription;

  ProductInfo(this.product, {this.withDescription = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Image.network(product.image),
        Container(
          padding: EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                product.title,
                style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oswald'),
              ),
              SizedBox(
                width: 15.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.5),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  '${product.price.toString()} €',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        _productDescription(context, withDescription),
        Container(
          margin: EdgeInsets.only(top: 5.0),
          padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.location_on),
              Text('Sikupilli Prisma, Tallinn'),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text('Added by: ${product.userEmail}')
      ],
    );
  }

  Widget _productDescription(BuildContext context, bool visible) {
    if (visible) {
      return Container(
        margin: EdgeInsets.all(10.0),
        child: Text(
          product.description,
          textAlign: TextAlign.justify,
        ),
      );
    }
    return Container();
  }
}
