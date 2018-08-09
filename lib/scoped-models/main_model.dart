import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/products_model.dart';
import '../scoped-models/user_model.dart';

class MainModel extends Model with ProductsModel, UserModel {}
