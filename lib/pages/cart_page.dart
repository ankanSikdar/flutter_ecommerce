import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/widgets/product_item.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CartPage extends StatefulWidget {
  static const routeName = '/cart-page';

  final Function onInit;

  CartPage({this.onInit});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    widget.onInit();
  }

  IconData getCardIcon(String brand) {
    if (brand == 'visa') {
      return FlutterIcons.cc_visa_faw;
    } else if (brand == 'jcb') {
      return FlutterIcons.cc_jcb_faw;
    } else if (brand == 'diners club') {
      return FlutterIcons.cc_diners_club_faw;
    } else if (brand == 'discover') {
      return FlutterIcons.cc_discover_faw;
    } else if (brand == 'mastercard') {
      return FlutterIcons.cc_mastercard_faw;
    } else if (brand == 'american express') {
      return FlutterIcons.cc_amex_faw;
    } else {
      return FlutterIcons.cc_stripe_faw;
    }
  }

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
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        List<Widget> cardsList = state.cards.map((card) {
          return Column(
            children: [
              ListTile(
                // leading: Text('${card['brand'].toString().toLowerCase()}'),
                leading: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Icon(
                    getCardIcon('${card['brand'].toString().toLowerCase()}'),
                    size: 60,
                  ),
                ),
                title: Text(
                  '*** *** ${card['last4']}',
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: Text(
                  'Expiry: ${card['exp_month']}/${card['exp_year']}',
                  style: TextStyle(fontSize: 15),
                ),
                trailing: FlatButton(
                  child: Text(
                    'Set as Primary',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              Divider(),
            ],
          );
        }).toList();

        return ListView(
          children: cardsList,
        );
      },
    );
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
