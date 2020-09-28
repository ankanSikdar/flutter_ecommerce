import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                Text(
                  'Register',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Username',
                      icon: FaIcon(FontAwesomeIcons.userAlt),
                      border: OutlineInputBorder(),
                      hintText: 'Enter username, min length 6',
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      icon: FaIcon(FontAwesomeIcons.solidEnvelope),
                      border: OutlineInputBorder(),
                      hintText: 'Enter your email id',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      icon: FaIcon(FontAwesomeIcons.key),
                      border: OutlineInputBorder(),
                      hintText: 'Create a password',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      RaisedButton(
                        onPressed: () {},
                        elevation: 8,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          'SignUp',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: Colors.black),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                      FlatButton(
                        onPressed: () {},
                        child: Text('Existing User? Login',
                            style: Theme.of(context).textTheme.bodyText2),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
