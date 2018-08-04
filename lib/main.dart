import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import './pages/admin.dart';
import './pages/products.dart';
import './pages/product.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final List<Map<String, String>> _products = [];

  void _addProduct(Map<String, String> product) {
    setState(() {
      _products.add(product);
    });
  }

  void _deleteProduct(int rindex) {
    if (rindex != null && rindex >= 0) {
      setState(() {
        _products.removeAt(rindex);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
      ),
//      home: AuthPage(),
      routes: {
        '/': (BuildContext context) =>
            ProductsPage(_products, _addProduct, _deleteProduct),
        '/admin': (BuildContext context) => AdminPage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');
        if (pathElements[0] != '') {
          return null;
        }
        if (pathElements[1] == 'product' && pathElements[2].length > 0) {
          final int index = int.tryParse(pathElements[2]);
          if (index != null) {
            return MaterialPageRoute<int>(
              builder: (context) => ProductPage(
                    index,
                    _products[index]['title'],
                    _products[index]['image'],
                  ),
            );
          } else {
            return null;
          }
        }
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                ProductsPage(_products, _addProduct, _deleteProduct));
      },
    );
  }
}
