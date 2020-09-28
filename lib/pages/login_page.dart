import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/pages/register_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;

  void _onSubmit() {
    final form = _formKey.currentState;
    if (!form.validate()) {
      return;
    }
    form.save();
    print(_email);
    print(_password);
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
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password',
          icon: FaIcon(FontAwesomeIcons.key),
          border: OutlineInputBorder(),
          hintText: 'Create a password',
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
      child: Column(
        children: [
          RaisedButton(
            onPressed: _onSubmit,
            elevation: 8,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
              Navigator.pushReplacementNamed(context, RegisterPage.routeName);
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
