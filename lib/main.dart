import 'package:flutter/material.dart';

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
        title: Text('Welcome'),
      ),
      body: Container(
        child: Text(
          'This is good',
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
