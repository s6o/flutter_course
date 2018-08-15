import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/remote_storage.dart';

class ProductsModel extends Model {
  Map<int, Product> _products = Map();
  int _selectedIndex;
  bool _showFavorites = false;

  List<Product> get products {
    return _products.values.where((Product p) => !p.inTrash).toList();
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return _products.values
          .where((Product p) => p.isFavorite && !p.inTrash)
          .toList();
    }
    return products;
  }

  int get selectedIndex {
    return _selectedIndex;
  }

  void addProduct(Product product) {
    int pid = DateTime.now().microsecondsSinceEpoch;
    _products[pid] = product.setLocaId(pid)..setInSync(false);
    notifyListeners();
  }

  void deleteProduct() {
    if (_selectedIndex != null && _selectedIndex >= 0) {
      final Product delProduct = _showFavorites
          ? displayedProducts[_selectedIndex]
          : products[_selectedIndex];

      _products[delProduct.localId] = delProduct.toTrash();
      _selectedIndex = null;
      syncManually(delProduct);
      notifyListeners();
    }
  }

  void fetchProducts() async {
    print('Fetching remote products...');

    RemoteStorage rs = RemoteStorage();
    String url = await rs.readUrl();

    if (rs.isValidUrl(url)) {
      http.Response response = await http.get(url + 'products.json');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data != null) {
          final List<Product> remoteProducts = data
              .map((String id, dynamic m) {
                Product product = Product.fromMap(m);
                return MapEntry(id, product);
              })
              .values
              .toList();

          remoteProducts.forEach((Product p) {
            if (_products.containsKey(p.localId) == false) {
              _products[p.localId] = p.setInSync(true);
            }
          });
          notifyListeners();
        }
      } else {
        print(
            'Fetching products from Remote Storage failed: HTTP ${response.statusCode} | ' +
                response.reasonPhrase);
      }
    } else {
      print('Missing corret remote storage URL.');
    }
  }

  ProductsModel selectProduct(int index) {
    _selectedIndex = index;
    if (_selectedIndex != null && _selectedIndex >= 0) {
      notifyListeners();
    }
    return this;
  }

  void syncManually(Product product) async {
    if (product.inSync == false) {
      if (product.remoteId.length <= 0) {
        _syncNewProduct(product);
      } else if (product.remoteId.length > 0) {
        _syncUpdatedProduct(product);
      }
    }

    if (product.inTrash) {
      _syncRemovedProduct(product);
    }
  }

  void _syncNewProduct(Product product) async {
    RemoteStorage rs = RemoteStorage();
    String url = await rs.readUrl();

    if (rs.isValidUrl(url)) {
      http.Response response =
          await http.post(url + 'products.json', body: toJson(product));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        final Product remoteProduct = product.setRemoteId(data['name']);

        http
            .put(url + 'products/${remoteProduct.remoteId}.json',
                body: toJson(remoteProduct))
            .then((http.Response response) {
          if (response.statusCode == 200) {
            _products[remoteProduct.localId] = remoteProduct.setInSync(true);
            notifyListeners();
          } else {
            print(
                'Remote Storage remote ID update failed: HTTP ${response.statusCode} | ' +
                    response.reasonPhrase);
          }
        });
      } else {
        print('Remote Storage add failed: HTTP ${response.statusCode} | ' +
            response.reasonPhrase);
      }
    } else {
      print('Missing corret remote storage URL.');
    }
  }

  void _syncRemovedProduct(Product product) async {
    RemoteStorage rs = RemoteStorage();
    String url = await rs.readUrl();

    if (rs.isValidUrl(url)) {
      if (product.remoteId != null && product.remoteId.length > 0) {
        http
            .delete(url + 'products/${product.remoteId}.json')
            .then((http.Response response) {
          if (response.statusCode == 200) {
            _products.remove(product.localId);
            notifyListeners();
          } else {
            print(
                'Remote Storage delete failed: HTTP ${response.statusCode} | ' +
                    response.reasonPhrase);
          }
        });
      } else {
        print('Skipping (remote) delete, no valid remote id.');
      }
    } else {
      print('deleteProduct is missing corret remote storage URL.');
    }
  }

  void _syncUpdatedProduct(Product product) async {
    RemoteStorage rs = RemoteStorage();
    String url = await rs.readUrl();

    if (rs.isValidUrl(url)) {
      if (product.remoteId != null && product.remoteId.length > 0) {
        http
            .put(url + 'products/${product.remoteId}.json',
                body: toJson(product))
            .then((http.Response response) {
          if (response.statusCode == 200) {
            _products[product.localId] = product.setInSync(true);
            notifyListeners();
          } else {
            print(
                'Remote Storage update failed: HTTP ${response.statusCode} | ' +
                    response.reasonPhrase);
          }
        });
      } else {
        print('Remote Storage sync is missing product\'s remote ID');
      }
    } else {
      print('Missing corret remote storage URL.');
    }
  }

  void toggleFavorite() {
    if (_selectedIndex != null) {
      final bool favStatus = products[_selectedIndex].isFavorite;
      updateProduct(Product.fromProductWithFavorite(
          products[_selectedIndex], !favStatus));
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
      _products[product.localId] = product.setInSync(false);
      _selectedIndex = null;
      notifyListeners();
    }
  }
}
