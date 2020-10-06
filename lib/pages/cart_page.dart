import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/widgets/product_item.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CartPage extends StatefulWidget {
  static const routeName = '/cart-page';

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  cartTab() {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemBuilder: (context, index) {
            return ProductItem(state.cartProducts[index]);
          },
          itemCount: state.cartProducts.length,
        );
      },
    );
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
