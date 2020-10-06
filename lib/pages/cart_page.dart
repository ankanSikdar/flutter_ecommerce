import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CartPage extends StatefulWidget {
  static const routeName = '/cart-page';

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  cartTab() {
    return Text('cart');
  }

  cardsTab() {
    return Text('cards');
  }

  ordersTab() {
    return Text('orders');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Carts Page'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(FlutterIcons.shopping_cart_ent)),
              Tab(icon: Icon(FlutterIcons.credit_card_ent)),
              Tab(icon: Icon(FlutterIcons.receipt_mdi)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            cartTab(),
            cardsTab(),
            ordersTab(),
          ],
        ),
      ),
    );
  }
}
