import 'dart:convert';

import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/models/user.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
