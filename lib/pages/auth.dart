import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authenticate'),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              onChanged: (String v) => setState(() => _email = v),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (String v) => setState(() => _password = v),
            ),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              child: Text('LOGIN'),
              color: Theme.of(context).accentColor,
              textColor: Colors.yellowAccent,
              onPressed: () {
                print(_email);
                print(_password);
                Navigator.pushReplacementNamed(context, '/all');
              },
            ),
          ],
        ),
      ),
    );
  }
}
