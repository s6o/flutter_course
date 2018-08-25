import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

  Widget _homeWidget(BuildContext context, MainModel model) {
    // if the Firebase API key can change 'behind the scene' then
    // this should always return the RemoteStoragePage for setup
    if (model.setupRequired) {
      return RemoteStoragePage(asSetup: true, model: model);
    } else {
      if (model.user == null) {
        return AuthPage();
      } else {
        return ProductsPage(model);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _mainModel,
      child: ScopedModelDescendant(
          builder: (BuildContext context, Widget child, MainModel model) {
        return MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            accentColor: Colors.deepPurpleAccent,
            buttonColor: Colors.deepPurple,
          ),
          home: _homeWidget(context, model),
          routes: {
            '/all': (BuildContext context) =>
                model.user != null ? ProductsPage(model) : AuthPage(),
            '/auth': (BuildContext context) => AuthPage(),
            '/admin': (BuildContext context) =>
                model.user != null ? AdminPage(model) : AuthPage(),
          },
          onGenerateRoute: (RouteSettings settings) {
            if (model.user == null) {
              return MaterialPageRoute(
                  builder: (BuildContext content) => AuthPage());
            }
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
            if (model.user == null) {
              return MaterialPageRoute(
                  builder: (BuildContext content) => AuthPage());
            } else {
              return MaterialPageRoute(
                  builder: (BuildContext context) => ProductsPage(model));
            }
          },
        );
      }),
    );
  }
}
