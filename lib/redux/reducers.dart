import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/models/user.dart';
import 'package:flutter_ecommerce/redux/actions.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    user: userReducer(
      state.user,
      action,
    ),
    products: productsReducer(state.products, action),
  );
}

userReducer(User user, dynamic action) {
  if (action is GetUserAction) {
    /* return user from action */
    return action.user;
  } else if (action is LogOutAction) {
    return action.user;
  }
  return user;
}

productsReducer(List<Product> products, dynamic action) {
  if (action is GetProductsAction) {
    return action.products;
  }
  return products;
}
