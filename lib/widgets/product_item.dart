import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/pages/product_details_page.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProductItem extends StatelessWidget {
  final Product item;

  ProductItem(this.item);

  @override
  Widget build(BuildContext context) {
    String url = 'http://192.168.1.5:1337${item.picture['url']}';
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          ProductDetailsPage.routeName,
          arguments: item,
        );
      },
      child: GridTile(
        child: Hero(
          tag: url,
          child: Image(
            image: NetworkImage(url),
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black45,
          title: Text(
            item.name,
            style: TextStyle(fontSize: 16),
          ),
          subtitle: Text(
            '₹${item.price}',
            style: TextStyle(fontSize: 14),
          ),
          trailing: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (context, state) {
              if (state.user == null) {
                return Text('');
              }
              return IconButton(
                icon: Icon(FlutterIcons.cart_plus_faw),
                onPressed: () {},
              );
            },
          ),
        ),
      ),
    );
  }
}
