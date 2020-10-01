import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/pages/login_page.dart';
import 'package:flutter_ecommerce/pages/products_page.dart';
import 'package:flutter_ecommerce/pages/register_page.dart';
import 'package:flutter_ecommerce/redux/reducers.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

void main() {
  final store = Store<AppState>(appReducer,
      initialState: AppState.initial(), middleware: [thunkMiddleware]);
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
        home: RegisterPage(),
        routes: {
          RegisterPage.routeName: (context) => RegisterPage(),
          LoginPage.routeName: (context) => LoginPage(),
          ProductsPage.routeName: (context) => ProductsPage(),
        },
      ),
    );
  }
}
