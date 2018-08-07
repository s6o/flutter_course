import 'package:flutter/material.dart';

class ProductEditPage extends StatefulWidget {
  final Function addProduct;
  final Function deleteProduct;
  final Function updateProduct;
  final Map<String, dynamic> product;
  final int productIndex;

  ProductEditPage(
      {this.addProduct,
      this.deleteProduct,
      this.updateProduct,
      this.product,
      this.productIndex});

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
    return widget.product == null
        ? _buildTabContent(context)
        : Scaffold(
            appBar: AppBar(
              title: Text('Edit Product'),
            ),
            body: _buildTabContent(context),
          );
  }

  String _initialValue(String key) {
    if (widget.product == null) {
      return '';
    } else {
      if (widget.product[key] is double) {
        return widget.product[key].toString();
      }
      return widget.product[key];
    }
  }

  Widget _buildTabContent(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth =
        MediaQuery.of(context).orientation == Orientation.landscape
            ? deviceWidth * 0.90
            : deviceWidth;
    final double targetPadding = deviceWidth - targetWidth;

    return GestureDetector(
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
                initialValue: _initialValue('title'),
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
                initialValue: _initialValue('description'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onSaved: (String v) => _formData['price'] = double.tryParse(v),
                validator: (String v) {
                  if (double.tryParse(v) == null) {
                    return 'Incorrect price format.';
                  }
                  return null;
                },
                initialValue: _initialValue('price'),
              ),
              SizedBox(
                height: 10.0,
              ),
              RaisedButton(
                child: Text('SAVE'),
                textColor: Colors.yellowAccent,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    if (widget.productIndex == null) {
                      widget.addProduct(_formData);
                    } else {
                      widget.updateProduct(_formData, widget.productIndex);
                    }
                    Navigator.pushReplacementNamed(context, '/admin');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
