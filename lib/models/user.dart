import 'package:flutter/material.dart';

class User {
  String id;
  String username;
  String email;
  String jwt;
  String cartId;
  String customerId;

  User({
    @required this.id,
    @required this.username,
    @required this.email,
    @required this.jwt,
    @required this.cartId,
    @required this.customerId,
  });

  factory User.fromJson(Map<String, dynamic> jsonData) {
    return User(
      id: jsonData['_id'],
      username: jsonData['username'],
      email: jsonData['email'],
      jwt: jsonData['jwt'],
      cartId: jsonData['cart_id'],
      customerId: jsonData['customer_id'],
    );
  }
}
