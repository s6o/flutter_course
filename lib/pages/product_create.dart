import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;
  final Function deleteProduct;

  ProductCreatePage(this.addProduct, this.deleteProduct);

  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  String _title;
  String _description;
  double _price;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth =
        MediaQuery.of(context).orientation == Orientation.landscape
            ? deviceWidth * 0.90
            : deviceWidth;
    final double targetPadding = deviceWidth - targetWidth;

    return Container(
      margin: EdgeInsets.all(10.0),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: 'Title'),
            onChanged: (String v) => setState(() => _title = v),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Description'),
            maxLines: 4,
            onChanged: (String v) => setState(() => _description = v),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Price'),
            keyboardType: TextInputType.number,
            onChanged: (String v) =>
                setState(() => _price = double.tryParse(v)),
          ),
          SizedBox(
            height: 10.0,
          ),
          RaisedButton(
            child: Text('SAVE'),
            textColor: Colors.yellowAccent,
            onPressed: () {
              // TODO: validation
              widget.addProduct({
                'title': _title,
                'description': _description,
                'price': _price,
                'image': 'assets/food.jpg'
              });
              Navigator.pushReplacementNamed(context, '/all');
            },
          ),
        ],
      ),
    );
  }
}
