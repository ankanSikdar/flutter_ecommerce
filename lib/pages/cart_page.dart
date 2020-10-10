import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/widgets/product_item.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_ecommerce/redux/actions.dart';

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
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: 'pk_test_rhkxUJ4HgppGdPqP7Jv5dF0G009XBKpw8r',
        androidPayMode: 'test',
      ),
    );
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
        List<Widget> cardsList = state.cards.map((c) {
          return Column(
            children: [
              ListTile(
                // leading: Text('${card['brand'].toString().toLowerCase()}'),
                leading: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Icon(
                    getCardIcon(
                        '${c['card']['brand'].toString().toLowerCase()}'),
                    size: 60,
                  ),
                ),
                title: Text(
                  '*** *** ${c['card']['last4']}',
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: Text(
                  'Expiry: ${c['card']['exp_month']}/${c['card']['exp_year']}',
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

        dynamic _addCard(String token) async {
          // Udpdate user data to include card token
          await http
              .put('http://192.168.1.5:1337/users/${state.user.id}', body: {
            'card_token': token,
          }, headers: {
            'Authorization': 'Bearer ${state.user.jwt}'
          });

          // Associate card token with stripe customer
          http.Response response =
              await http.post('http://192.168.1.5:1337/card/add', body: {
            'source': token,
            'customer': state.user.customerId,
          });
          final responseData = json.decode(response.body);
          return responseData;
        }

        return ListView(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: RaisedButton(
                onPressed: () async {
                  try {
                    final PaymentMethod response =
                        await StripePayment.paymentRequestWithCardForm(
                            CardFormPaymentRequest());
                    final card = await _addCard(response.id);
                    // Action to Add Card
                    StoreProvider.of<AppState>(context)
                        .dispatch(AddCardAction(card));
                  } catch (error) {
                    print('ERROR Adding Card $error');
                  }
                },
                child: Text('Add Card'),
                color: Theme.of(context).accentColor,
              ),
            ),
            ...cardsList
          ],
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
