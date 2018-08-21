import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';

import './pages/auth.dart';
import './pages/admin.dart';
import './pages/products.dart';
import './pages/product_detail.dart';
import './pages/remote_storage.dart';
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
  final _mainModel = MainModel();

  @override
  void initState() {
    _mainModel.restoreUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _mainModel,
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.deepPurpleAccent,
          buttonColor: Colors.deepPurple,
        ),
        home: RemoteStoragePage(asSetup: true, model: _mainModel),
        routes: {
          '/all': (BuildContext context) => ProductsPage(_mainModel),
          '/auth': (BuildContext context) => AuthPage(),
          '/admin': (BuildContext context) => AdminPage(_mainModel),
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
              builder: (BuildContext context) => ProductsPage(_mainModel));
        },
      ),
    );
  }
}
