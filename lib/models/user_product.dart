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
            isFavorite: p.isFavorite);

  UserProduct.fromUserProductWithFavorite(UserProduct p, bool favorite)
      : userId = p.userId,
        userEmail = p.userEmail,
        super(
            title: p.title,
            description: p.description,
            price: p.price,
            image: p.image,
            isFavorite: favorite);
}
