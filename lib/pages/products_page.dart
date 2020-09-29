import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  static const routeName = '/products';

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        centerTitle: true,
      ),
    );
  }
}
