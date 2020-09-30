import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/pages/products_page.dart';
import 'package:flutter_ecommerce/pages/register_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _email, _password;
  bool _obscureText = true;
  bool _isLoading = false;

  void _onSubmit() {
    final form = _formKey.currentState;
    if (!form.validate()) {
      return;
    }
    form.save();
    _loginUser();
  }

  void _loginUser() async {
    setState(() {
      _isLoading = true;
    });
    final response = await http.post('http://192.168.1.5:1337/auth/local',
        body: {'identifier': _email, 'password': _password});
    final responseData = json.decode(response.body);
    setState(() {
      _isLoading = false;
    });
    if (response.statusCode != 200) {
      final errorMessage = responseData['message'][0]['messages'][0]['message'];
      _showErrorSnack(errorMessage);
    } else {
      _storeUserData(responseData);
      final username = responseData['user']['username'];
      _showSuccessSnack(username);
      _redirectUser();
      print('Data: $responseData');
    }
  }

  Future<void> _storeUserData(Map responseData) async {
    final pref = await SharedPreferences.getInstance();

    Map<String, dynamic> user = responseData['user'];
    user.putIfAbsent('jwt', () => responseData['jwt']);

    pref.setString('user', json.encode(user));
  }

  void _showSuccessSnack(String username) {
    SnackBar snackBar = SnackBar(
      content: Text(
        'Welcome Back $username!',
        style: TextStyle(color: Colors.green),
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
    _formKey.currentState.reset();
  }

  void _showErrorSnack(String message) {
    SnackBar snackBar = SnackBar(
      content: Text(
        'ERROR: $message',
        style: TextStyle(color: Theme.of(context).errorColor),
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _redirectUser() {
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, ProductsPage.routeName);
    });
  }

  Widget _showTitle() {
    return Text(
      'Login',
      style: Theme.of(context).textTheme.headline5,
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Email',
          icon: FaIcon(FontAwesomeIcons.solidEnvelope),
          border: OutlineInputBorder(),
          hintText: 'Enter your email id',
        ),
        keyboardType: TextInputType.emailAddress,
        onSaved: (newValue) => _email = newValue,
        validator: (value) {
          if (value.isEmpty) {
            return 'Email must be provided';
          }
          if (!EmailValidator.validate(value)) {
            return 'Enter a valid email';
          }
          return null;
        },
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextFormField(
        obscureText: _obscureText,
        decoration: InputDecoration(
          labelText: 'Password',
          icon: FaIcon(FontAwesomeIcons.key),
          border: OutlineInputBorder(),
          hintText: 'Create a password',
          suffixIcon: GestureDetector(
            child: Icon(
              _obscureText ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
            ),
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
        onSaved: (newValue) => _password = newValue,
        validator: (value) {
          if (value.isEmpty) {
            return 'Password must be provided';
          }
          if (value.length < 6) {
            return 'Password must be atleast 6 characters';
          }
          return null;
        },
      ),
    );
  }

  Widget _showFormActionsInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: _isLoading
          ? CircularProgressIndicator()
          : Column(
              children: [
                RaisedButton(
                  onPressed: _onSubmit,
                  elevation: 8,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    'Login',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: Colors.black),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, RegisterPage.routeName);
                  },
                  child: Text('New User? Register',
                      style: Theme.of(context).textTheme.bodyText2),
                )
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _showTitle(),
                _showEmailInput(),
                _showPasswordInput(),
                _showFormActionsInput(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
