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
    return Container(
      margin: EdgeInsets.all(10.0),
      child: ListView(
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
            color: Theme.of(context).primaryColor,
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
