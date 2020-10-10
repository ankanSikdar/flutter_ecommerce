import 'package:flutter/material.dart';

class CardTile extends StatelessWidget {
  final IconData iconData;
  final String last4;
  final String expMonth;
  final String expYear;
  final Function onPressed;

  CardTile({
    this.iconData,
    this.last4,
    this.expMonth,
    this.expYear,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(
              iconData,
              size: 60,
            ),
          ),
          title: Text(
            '*** *** $last4',
            style: TextStyle(fontSize: 18),
          ),
          subtitle: Text(
            'Expiry: $expMonth/$expYear',
            style: TextStyle(fontSize: 15),
          ),
          trailing: FlatButton(
            child: Text(
              'Set as Primary',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            onPressed: onPressed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
