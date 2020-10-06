import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/redux/actions.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProductDetailsPage extends StatelessWidget {
  static const routeName = '/product-details';
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Product item = ModalRoute.of(context).settings.arguments;
    String url = 'http://192.168.1.5:1337${item.picture['url']}';

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Hero(
                tag: url,
                child: Image(
                  image: NetworkImage(url),
                ),
              ),
              width: MediaQuery.of(context).size.width,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                item.name,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                '₹ ${item.price}',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                builder: (context, state) {
                  if (state.user == null) {
                    return Text('');
                  }
                  bool inCart = state.cartProducts.contains(item);
                  return RaisedButton.icon(
                    color: Theme.of(context).accentColor,
                    label: Text(inCart ? 'Remove From Cart' : 'Add To Cart'),
                    icon: Icon(
                      FlutterIcons.shopping_cart_ent,
                      color: inCart ? Colors.amber[700] : Colors.white,
                    ),
                    onPressed: () {
                      StoreProvider.of<AppState>(context)
                          .dispatch(toggleCartProductAction(item));
                      SnackBar snackBar = SnackBar(
                        duration: Duration(seconds: 2),
                        backgroundColor: Theme.of(context).primaryColorDark,
                        content: Text(
                          'Cart Updated!',
                          style: TextStyle(color: Colors.green),
                        ),
                      );
                      _scaffoldKey.currentState.hideCurrentSnackBar();
                      _scaffoldKey.currentState.showSnackBar(snackBar);
                    },
                  );
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Text(
                item.description,
                // textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
