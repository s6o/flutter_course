import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';

class ProductsModel extends Model {
  List<Product> _products = [];
  int _selectedIndex;

  List<Product> get products {
    return List.from(_products);
  }

  int get selectedIndex {
    return _selectedIndex;
  }

  void addProduct(Product product) {
    _products.add(product);
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
    return this;
  }

  void toggleFavorite() {
    if (_selectedIndex != null) {
      final bool favStatus = _products[_selectedIndex].isFavorite;
      _products[_selectedIndex] = Product.fromProductWithFavorite(
          _products[_selectedIndex], !favStatus);
      _selectedIndex = null;
      notifyListeners();
    } else {
      print('toggleFavorite called with an invalid selectedIndex');
    }
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
