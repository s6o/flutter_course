import './product.dart';

class UserProduct extends Product {
  final String userId;
  final String userEmail;

  UserProduct(String userId, String userEmail, Product p)
      : userId = userId,
        userEmail = userEmail,
        super(
            title: p.title,
            description: p.description,
            price: p.price,
            image: p.image,
            isFavorite: p.isFavorite) {
    setId(p.id);
  }

  @override
  UserProduct.fromMap(Map<String, dynamic> m)
      : userId = m['uid'],
        userEmail = m['email'],
        super.fromMap(m);

  UserProduct.fromUserProductWithFavorite(UserProduct p, bool favorite)
      : userId = p.userId,
        userEmail = p.userEmail,
        super(
            title: p.title,
            description: p.description,
            price: p.price,
            image: p.image,
            isFavorite: favorite) {
    setId(p.id);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> m = super.toMap();
    m['uid'] = userId;
    m['email'] = userEmail;
    return m;
  }
}
