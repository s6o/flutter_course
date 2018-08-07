import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import './pages/auth.dart';
import './pages/admin.dart';
import './pages/products.dart';
import './pages/product_detail.dart';

void main() {
  debugPaintSizeEnabled = false;
  debugPaintBaselinesEnabled = false;
  debugPaintPointersEnabled = false;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final List<Map<String, dynamic>> _products = [];

  void _addProduct(Map<String, dynamic> product) {
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

  void _updateProduct(Map<String, dynamic> product, int index) {
    setState(() {
      _products[index] = product;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
        buttonColor: Colors.deepPurple,
      ),
      home: AuthPage(),
      routes: {
        '/all': (BuildContext context) =>
            ProductsPage(_products, _addProduct, _deleteProduct),
        '/admin': (BuildContext context) =>
            AdminPage(_products, _addProduct, _deleteProduct, _updateProduct),
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
              builder: (context) => ProductDetailPage(
                    index,
                    _products[index],
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
