import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/pages/cart_page.dart';
import 'package:flutter_ecommerce/pages/login_page.dart';
import 'package:flutter_ecommerce/widgets/product_item.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_ecommerce/redux/actions.dart';

class ProductsPage extends StatefulWidget {
  static const routeName = '/products';

  final Function onInit;

  ProductsPage({this.onInit});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    widget.onInit();
  }

  final _appBar = PreferredSize(
    preferredSize: Size.fromHeight(60.0),
    child: StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return AppBar(
          centerTitle: true,
          title:
              state.user != null ? Text(state.user.username) : Text('Welcome!'),
          leading: state.user == null
              ? Text('')
              : IconButton(
                  icon: Icon(FlutterIcons.shop_ent),
                  onPressed: () {
                    Navigator.pushNamed(context, CartPage.routeName);
                  },
                ),
          actions: [
            StoreConnector<AppState, VoidCallback>(
              converter: (store) {
                return () => store.dispatch(logOutAction);
              },
              builder: (context, callback) {
                if (state.user == null) {
                  return FlatButton(
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, LoginPage.routeName);
                    },
                  );
                }
                return IconButton(
                  icon: Icon(FlutterIcons.log_out_ent),
                  onPressed: callback,
                );
              },
            )
          ],
        );
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: StoreConnector<AppState, AppState>(
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
              return ProductItem(state.products[index]);
            },
            itemCount: state.products.length,
          );
        },
      ),
    );
  }
}
