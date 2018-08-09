import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';

import './pages/auth.dart';
import './pages/admin.dart';
import './pages/products.dart';
import './pages/product_detail.dart';
import './scoped-models/main_model.dart';

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
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: MainModel(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.deepPurpleAccent,
          buttonColor: Colors.deepPurple,
        ),
        home: AuthPage(),
        routes: {
          '/all': (BuildContext context) => ProductsPage(),
          '/admin': (BuildContext context) => AdminPage(),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'product' && pathElements[2].length > 0) {
            final int index = int.tryParse(pathElements[2]);
            if (index != null && index >= 0) {
              return MaterialPageRoute<int>(
                builder: (context) => ProductDetailPage(index),
              );
            } else {
              return null;
            }
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage());
        },
      ),
    );
  }
}
