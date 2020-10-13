import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/pages/cart_page.dart';
import 'package:flutter_ecommerce/pages/login_page.dart';
import 'package:flutter_ecommerce/pages/product_details_page.dart';
import 'package:flutter_ecommerce/pages/products_page.dart';
import 'package:flutter_ecommerce/pages/register_page.dart';
import 'package:flutter_ecommerce/redux/actions.dart';
import 'package:flutter_ecommerce/redux/reducers.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_thunk/redux_thunk.dart';

void main() async {
  final store = Store<AppState>(appReducer,
      initialState: AppState.initial(),
      middleware: [thunkMiddleware, LoggingMiddleware.printer()]);

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  MyApp({this.store});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.amber[700],
          accentColor: Colors.green[700],
          brightness: Brightness.dark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: GoogleFonts.notoSans().fontFamily,
          textTheme: TextTheme(
            headline5: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 18),
          ),
        ),
        initialRoute: ProductsPage.routeName,
        routes: {
          RegisterPage.routeName: (context) => RegisterPage(),
          LoginPage.routeName: (context) => LoginPage(),
          ProductsPage.routeName: (context) => ProductsPage(
                onInit: () {
                  // dispatch an action (getUserAction) to get user data
                  StoreProvider.of<AppState>(context).dispatch(getUserAction);
                  StoreProvider.of<AppState>(context)
                      .dispatch(getProductsAction);
                  StoreProvider.of<AppState>(context)
                      .dispatch(getCartProductsAction);
                },
              ),
          ProductDetailsPage.routeName: (context) => ProductDetailsPage(),
          CartPage.routeName: (context) => CartPage(
                onInit: () {
                  StoreProvider.of<AppState>(context).dispatch(getCardsAction);
                  StoreProvider.of<AppState>(context)
                      .dispatch(getCardTokenAction);
                  StoreProvider.of<AppState>(context).dispatch(getOrdersAction);
                },
              ),
        },
      ),
    );
  }
}
