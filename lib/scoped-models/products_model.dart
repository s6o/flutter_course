import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/user_product.dart';
import '../models/remote_storage.dart';

class ProductsModel extends Model {
  List<Product> _products = [];
  int _selectedIndex;
  bool _showFavorites = false;

  List<Product> get products {
    return List.from(_products);
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return _products.where((Product p) => p.isFavorite == true).toList();
    }
    return List.from(_products);
  }

  int get selectedIndex {
    return _selectedIndex;
  }

  void addProduct(Product product) {
    RemoteStorage rs = RemoteStorage();
    rs.readUrl().then((String url) {
      print('URL: ${url}products.json');
      print('JSON ${toJson(product)}');
      http
          .post(url + 'products.json', body: toJson(product))
          .then((http.Response response) {
        if (response.statusCode == 200) {
          Map<String, dynamic> data = json.decode(response.body);
          final Product newProduct = product.setId(data['name']);
          _products.add(newProduct);
        } else {
          print('Remote Storage failed: HTTP ${response.statusCode} | ' +
              response.reasonPhrase);
          _products.add(product);
        }
      });
    });
    notifyListeners();
  }

  void deleteProduct() {
    if (_selectedIndex != null &&
        _selectedIndex >= 0 &&
        _products.length >= _selectedIndex + 1) {
      _products.removeAt(_selectedIndex);
      _selectedIndex = null;
      notifyListeners();
    } else {
      print('deleteProduct called with an invalid selectedIndex');
    }
  }

  ProductsModel selectProduct(int index) {
    _selectedIndex = index;
    if (_selectedIndex != null && _selectedIndex >= 0) {
      notifyListeners();
    }
    return this;
  }

  void toggleFavorite() {
    if (_selectedIndex != null) {
      final bool favStatus = _products[_selectedIndex].isFavorite;
      // TODO: extract to a generic, so that new types won't require another 'is' check
      if (_products[_selectedIndex] is UserProduct) {
        _products[_selectedIndex] = UserProduct.fromUserProductWithFavorite(
            _products[_selectedIndex], !favStatus);
      } else {
        _products[_selectedIndex] = Product.fromProductWithFavorite(
            _products[_selectedIndex], !favStatus);
      }
      _selectedIndex = null;
      notifyListeners();
    } else {
      print('toggleFavorite called with an invalid selectedIndex');
    }
  }

  void toggleShowFavaorites() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }

  String toJson<T extends Product>(T product) {
    return json.encode(product.toMap());
  }

  void updateProduct(Product product) {
    if (_selectedIndex != null && _selectedIndex >= 0) {
      _products[selectedIndex] = product;
      _selectedIndex = null;
      notifyListeners();
    } else {
      print('updateProduct called with an invalid selectedIndex');
    }
  }
}
