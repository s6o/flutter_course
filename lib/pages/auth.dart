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
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4), BlendMode.dstATop),
            image: AssetImage('assets/background.jpg'),
          ),
        ),
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (String v) => setState(() => _email = v),
                ),
                SizedBox(
                  height: 11.0,
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white),
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
        ),
      ),
    );
  }
}
