import 'dart:convert';

import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/models/order.dart';
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

ThunkAction<AppState> getCartProductsAction = (Store<AppState> store) async {
  final pref = await SharedPreferences.getInstance();
  if (pref.get('user') == null) {
    return;
  }
  final userData = json.decode(pref.get('user'));
  User storedUser = User.fromJson(userData);
  if (storedUser == null) {
    return;
  }
  http.Response response = await http
      .get('http://192.168.1.5:1337/carts/${storedUser.cartId}', headers: {
    'Authorization': 'Bearer ${storedUser.jwt}',
  });

  List<Product> cartProducts = [];
  final responseData = json.decode(response.body)['products'];
  responseData.forEach((productData) {
    final Product product = Product.fromJson(productData);
    cartProducts.add(product);
  });

  store.dispatch(GetCartProductsAction(cartProducts));
};

class GetCartProductsAction {
  final List<Product> _cartProducts;

  GetCartProductsAction(this._cartProducts);

  List<Product> get cartProducts {
    return _cartProducts;
  }
}

ThunkAction<AppState> toggleCartProductAction(Product cartProduct) {
  return (Store<AppState> store) async {
    final List<Product> cartProducts = store.state.cartProducts;
    final User user = store.state.user;
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

    final List<String> cartProductIds = updatedCart.map((product) {
      return product.id;
    }).toList();

    await http.put(
      'http://192.168.1.5:1337/carts/${user.cartId}',
      body: {
        'products': json.encode(cartProductIds),
      },
      headers: {
        'Authorization': 'Bearer ${user.jwt}',
      },
    );

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

/* Card Actions */
ThunkAction<AppState> getCardsAction = (Store<AppState> store) async {
  final String customerId = store.state.user.customerId;
  http.Response response =
      await http.get('http://192.168.1.5:1337/card?$customerId');
  final responseData = json.decode(response.body);
  store.dispatch(GetCardsAction(responseData));
};

class GetCardsAction {
  final List<dynamic> _cards;

  GetCardsAction(this._cards);

  List<dynamic> get cards {
    return _cards;
  }
}

class AddCardAction {
  final dynamic _card;

  AddCardAction(this._card);

  dynamic get card {
    return _card;
  }
}

ThunkAction<AppState> getCardTokenAction = (Store<AppState> store) async {
  final String jwt = store.state.user.jwt;
  final response = await http.get('http://192.168.1.5:1337/users/me', headers: {
    'Authorization': 'Bearer $jwt',
  });
  final responseData = json.decode(response.body);
  final String cardToken = responseData['card_token'];
  store.dispatch(GetCardTokenAction(cardToken));
};

class GetCardTokenAction {
  final String _cardToken;

  GetCardTokenAction(this._cardToken);

  String get cardToken {
    return _cardToken;
  }
}

ThunkAction<AppState> updateCardTokenAction(String cardToken) {
  final token = cardToken;
  return (Store<AppState> store) async {
    final String jwt = store.state.user.jwt;
    final String id = store.state.user.id;
    await http.put(
      "http://192.168.1.5:1337/users/$id",
      body: {
        'card_token': token,
      },
      headers: {
        'Authorization': 'Bearer $jwt',
      },
    );
    store.dispatch(UpdateCardTokenAction(cardToken));
  };
}

class UpdateCardTokenAction {
  final String _cardToken;

  UpdateCardTokenAction(this._cardToken);

  dynamic get cardToken {
    return _cardToken;
  }
}

/* Order Actions */

class AddOrderAction {
  final Order _order;

  AddOrderAction(this._order);

  Order get order {
    return _order;
  }
}
