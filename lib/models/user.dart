import 'package:flutter/material.dart';

class User {
  String id;
  String username;
  String email;
  String jwt;
  String cartId;

  User({
    @required this.id,
    @required this.username,
    @required this.email,
    @required this.jwt,
    @required this.cartId,
  });

  factory User.fromJson(Map<String, dynamic> jsonData) {
    return User(
      id: jsonData['id'],
      username: jsonData['username'],
      email: jsonData['email'],
      jwt: jsonData['jwt'],
      cartId: jsonData['cart_id'],
    );
  }
}
