import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../scoped-models/products_model.dart';

class ProductEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/food.jpg',
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        return model.selectedIndex == null
            ? _buildTabContent(context, model)
            : Scaffold(
                appBar: AppBar(
                  title: Text('Edit Product'),
                ),
                body: _buildTabContent(context, model),
              );
      },
    );
  }

  String _initialValue(String key, ProductsModel model) {
    if (model.selectedIndex == null) {
      return '';
    } else {
      final Product product = model.products[model.selectedIndex];
      switch (key) {
        case 'title':
          return product.title;
          break;
        case 'description':
          return product.description;
          break;
        case 'price':
          return product.price.toString();
          break;
        default:
          return '';
      }
    }
  }

  Widget _buildSaveButton(BuildContext context, ProductsModel model) {
    return RaisedButton(
      child: Text('SAVE'),
      textColor: Colors.yellowAccent,
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          if (model.selectedIndex == null) {
            model.addProduct(Product.fromMap(_formData));
          } else {
            model.updateProduct(Product.fromProductWithFavorite(
                Product.fromMap(_formData),
                model.products[model.selectedIndex].isFavorite));
          }
          Navigator.pushReplacementNamed(context, '/admin');
        }
      },
    );
  }

  Widget _buildTabContent(BuildContext context, ProductsModel model) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth =
        MediaQuery.of(context).orientation == Orientation.landscape
            ? deviceWidth * 0.90
            : deviceWidth;
    final double targetPadding = deviceWidth - targetWidth;

    return Card(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  initialValue: _initialValue('title', model),
                  onSaved: (String v) => _formData['title'] = v,
                  validator: (String v) {
                    if (v.isEmpty) {
                      return 'A non-empty product title is required.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 4,
                  onSaved: (String v) => _formData['description'] = v,
                  initialValue: _initialValue('description', model),
                  validator: (String v) {
                    if (v.isEmpty) {
                      return 'A description is required.';
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  onSaved: (String v) =>
                      _formData['price'] = double.tryParse(v),
                  validator: (String v) {
                    if (double.tryParse(v) == null) {
                      return 'Incorrect price format.';
                    }
                    return null;
                  },
                  initialValue: _initialValue('price', model),
                ),
                SizedBox(
                  height: 10.0,
                ),
                _buildSaveButton(context, model),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
