import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/order.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/models/user.dart';

@immutable
class AppState {
  final User user;
  final List<Product> products;
  final List<Product> cartProducts;
  final List<dynamic> cards;
  final String cardToken;
  final List<Order> orders;

  AppState({
    @required this.user,
    @required this.products,
    @required this.cartProducts,
    @required this.cards,
    @required this.cardToken,
    @required this.orders,
  });

  factory AppState.initial() {
    return AppState(
      user: null,
      products: [],
      cartProducts: [],
      cards: [],
      cardToken: '',
      orders: [],
    );
  }
}
