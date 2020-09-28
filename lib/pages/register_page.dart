import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:email_validator/email_validator.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _username, _email, _password;

  void _onSubmit() {
    final form = _formKey.currentState;
    if (!form.validate()) {
      return;
    }
    form.save();
    print(_username);
    print(_email);
    print(_password);
  }

  Widget _showTitle() {
    return Text(
      'Register',
      style: Theme.of(context).textTheme.headline5,
    );
  }

  Widget _showUsernameInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Username',
          icon: FaIcon(FontAwesomeIcons.userAlt),
          border: OutlineInputBorder(),
          hintText: 'Enter username, min length 6',
        ),
        keyboardType: TextInputType.text,
        onSaved: (newValue) => _username = newValue,
        validator: (value) {
          if (value.isEmpty) {
            return 'Username must be provided';
          }
          if (value.length < 6) {
            return 'Username must be atleast 6 characters';
          }
          if (value.length > 20) {
            return 'Username cannot be greater than 20 characters';
          }
          return null;
        },
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
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
    );
  }

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
            key: _formKey,
            child: Column(
              children: [
                _showTitle(),
                _showUsernameInput(),
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
