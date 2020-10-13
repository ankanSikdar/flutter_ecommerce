import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/models/order.dart';
import 'package:flutter_ecommerce/widgets/card_tile.dart';
import 'package:flutter_ecommerce/widgets/product_item.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_ecommerce/redux/actions.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  static const routeName = '/cart-page';

  final Function onInit;

  CartPage({this.onInit});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSubmitting = false;

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

  cartTab(AppState state) {
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
  }

  cardsTab(AppState state) {
    if (state.cards.length == 0) {
      return Center(
        child: Text('No Cards Added'),
      );
    }
    List<Widget> cardsList = state.cards.map((c) {
      return CardTile(
        iconData: getCardIcon('${c['card']['brand'].toString().toLowerCase()}'),
        last4: c['card']['last4'].toString(),
        expMonth: c['card']['exp_month'].toString(),
        expYear: c['card']['exp_year'].toString(),
        trailingButton: c['id'] != state.cardToken
            ? FlatButton(
                child: Text(
                  'Set as Primary',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
                onPressed: () {
                  StoreProvider.of<AppState>(context)
                      .dispatch(updateCardTokenAction(c['id']));
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              )
            : Chip(
                label: Text('Primary'),
                avatar: CircleAvatar(
                  child: Icon(
                    FlutterIcons.check_circle_faw,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.green,
                ),
              ),
      );
    }).toList();

    dynamic _addCard(String token) async {
      // Udpdate user data to include card token
      await http.put('http://192.168.1.5:1337/users/${state.user.id}', body: {
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
                // Action to Update Card Token
                StoreProvider.of<AppState>(context)
                    .dispatch(UpdateCardTokenAction(card['id']));
                // Show Snackbar
                SnackBar snackBar = SnackBar(
                  content: Text(
                    'Card Added Successfully',
                    style: TextStyle(color: Colors.green),
                  ),
                  backgroundColor: Theme.of(context).primaryColorDark,
                );
                _scaffoldKey.currentState.showSnackBar(snackBar);
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
  }

  ordersTab(AppState state) {
    if (state.orders.length < 1) {
      return Center(
        child: Text('No Orders Placed Yet!'),
      );
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('₹ ${state.orders[index].amount}'),
          leading: CircleAvatar(
            backgroundColor: Colors.green,
            child: Icon(
              Icons.local_shipping,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            DateFormat('MMM dd, yyyy - kk:mm')
                .format(state.orders[index].createdAt),
            style: TextStyle(fontSize: 14),
          ),
        );
      },
      itemCount: state.orders.length,
    );
  }

  String calculateTotalPrice(cartProducts) {
    double totalPrice = 0.0;
    cartProducts.forEach((product) {
      totalPrice += product.price;
    });
    return totalPrice.toStringAsFixed(2);
  }

  Future _showCheckoutDialog(AppState state) {
    return showDialog(
      context: context,
      builder: (context) {
        if (state.cards.length < 1) {
          return AlertDialog(
            title: Text('No Credit Card Found'),
            content: SingleChildScrollView(
              child: Text(
                  'Add a credit card to your account before checking out',
                  style: Theme.of(context).textTheme.bodyText2),
            ),
          );
        }

        String cartSummary = '';
        state.cartProducts.forEach((element) {
          cartSummary += '• ${element.name}, ₹${element.price}\n';
        });
        final primaryCard = state.cards
            .singleWhere((card) => card['id'] == state.cardToken)['card'];
        return AlertDialog(
          title: Text('Checkout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  'CART ITEMS (${state.cartProducts.length})',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  '$cartSummary',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  'CARD DETAILS',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  'Brand: ${primaryCard['brand']}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  'Card Number: ${primaryCard['last4']}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  'Expires On: ${primaryCard['exp_month']}/${primaryCard['exp_year']}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  'Total Price: ₹${calculateTotalPrice(state.cartProducts)}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Theme.of(context).errorColor),
                )),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              color: Colors.green,
              child: Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    ).then((value) async {
      _checkOutCardProducts() async {
        // Create a new order in Stapi
        final response =
            await http.post('http://192.168.1.5:1337/orders', body: {
          'amount': calculateTotalPrice(state.cartProducts),
          'products': json.encode(state.cartProducts),
          'source': state.cardToken,
          'customer': state.user.customerId,
        }, headers: {
          'Authorization': 'Bearer ${state.user.jwt}',
        });
        final responseData = json.decode(response.body);
        print(responseData);
        return responseData;
      }

      if (value == true) {
        // Show Loading Spinner
        setState(() {
          _isSubmitting = true;
        });
        // Checkout Cart Products (Create new order data in Strapi & charge card with Stripe)
        final newOrderData = await _checkOutCardProducts();
        // Create order instance
        Order newOrder = Order.fromJson(newOrderData);
        // Pass order instance to a new action (AddOrderAction)
        StoreProvider.of<AppState>(context).dispatch(AddOrderAction(newOrder));
        // Clear out our cartProducts
        StoreProvider.of<AppState>(context).dispatch(clearCartProductsAction);
        // Hide Loading Spinner
        setState(() {
          _isSubmitting = false;
        });
        // Show success dialog
        _showSuccessDialog();
      }
    });
  }

  Future _showSuccessDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Congratulations!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Order Placed Successfully.\nCheck your email for the receipt of your purchase. \n\nOrder Summary will appear in the orders tab.\nThank You :)',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: _isSubmitting,
          child: DefaultTabController(
            length: 3,
            child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text(
                    'Items: ${state.cartProducts.length}, Price: ₹${calculateTotalPrice(state.cartProducts)}'),
                centerTitle: true,
                bottom: TabBar(
                  tabs: [
                    Tab(icon: Icon(FlutterIcons.shopping_cart_ent)),
                    Tab(icon: Icon(FlutterIcons.credit_card_ent)),
                    Tab(icon: Icon(FlutterIcons.receipt_mdi)),
                  ],
                ),
              ),
              floatingActionButton: state.cartProducts.length > 0
                  ? FloatingActionButton.extended(
                      onPressed: () {
                        _showCheckoutDialog(state);
                      },
                      label: Text('Checkout',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      icon: Icon(FlutterIcons.local_atm_mdi),
                      backgroundColor: Colors.green,
                    )
                  : Text(''),
              body: TabBarView(
                children: [
                  cartTab(state),
                  cardsTab(state),
                  ordersTab(state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
