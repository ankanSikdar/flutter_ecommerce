import 'dart:convert';

import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/models/user.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/* User Actions */

ThunkAction<AppState> getUserAction = (Store<AppState> store) async {
  final pref = await SharedPreferences.getInstance();
  final storedUser = pref.getString('user');
  final User user =
      storedUser != null ? User.fromJson(json.decode(storedUser)) : null;

  store.dispatch(GetUserAction(user));
};

class GetUserAction {
  final User _user;

  GetUserAction(this._user);

  User get user {
    return _user;
  }
}

ThunkAction<AppState> logOutAction = (Store<AppState> store) async {
  final pref = await SharedPreferences.getInstance();
  await pref.remove('user');
  User user;
  store.dispatch(LogOutAction(user));
};

class LogOutAction {
  final User _user;

  LogOutAction(this._user);

  User get user {
    return _user;
  }
}

/* Product Actions */

ThunkAction<AppState> getProductsAction = (Store<AppState> store) async {
  http.Response response = await http.get('http://192.168.1.5:1337/products');
  final List<dynamic> responseData = json.decode(response.body);
  List<Product> products = [];
  responseData.forEach((element) {
    products.add(Product.fromJson(element));
  });
  store.dispatch(GetProductsAction(products));
};

class GetProductsAction {
  final List<Product> _products;

  GetProductsAction(this._products);

  List<Product> get products {
    return _products;
  }
}

/* Cart Product Actions */

ThunkAction<AppState> toggleCartProductAction(Product cartProduct) {
  return (Store<AppState> store) {
    final List<Product> cartProducts = store.state.cartProducts;
    final int index =
        cartProducts.indexWhere((element) => element.id == cartProduct.id);
    List<Product> updatedCart = List.from(cartProducts);
    if (index < 0) {
      // Item not in cart
      updatedCart.add(cartProduct);
    } else {
      // Item in cart already
      updatedCart.removeAt(index);
    }
    store.dispatch(ToggleCartProductAction(updatedCart));
  };
}

class ToggleCartProductAction {
  final List<Product> _cartProducts;

  ToggleCartProductAction(this._cartProducts);

  List<Product> get cartProducts {
    return _cartProducts;
  }
}
