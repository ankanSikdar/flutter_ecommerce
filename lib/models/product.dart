import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final num price;
  final Map<String, dynamic> picture;

  Product({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.price,
    @required this.picture,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'picture': picture,
    };
  }

  factory Product.fromJson(Map<String, dynamic> data) {
    return Product(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      price: data['price'],
      picture: data['picture'],
    );
  }
}
