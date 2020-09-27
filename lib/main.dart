import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.amber[700],
        accentColor: Colors.grey[700],
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: GoogleFonts.notoSans().fontFamily,
        textTheme: TextTheme(
          headline5: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 18),
        ),
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Ankan'),
      ),
      body: Container(
        child: Text(
          '₹ 799.99 Rupees only',
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.assistant_photo),
      ),
    );
  }
}
