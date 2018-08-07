import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, String> _formData = {
    'email': null,
    'password': null,
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Email',
                          filled: true,
                          fillColor: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (String v) => _formData['email'] = v,
                    ),
                    SizedBox(
                      height: 11.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Password',
                          filled: true,
                          fillColor: Colors.white),
                      obscureText: true,
                      onSaved: (String v) => _formData['password'] = v,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    RaisedButton(
                      child: Text('LOGIN'),
                      color: Theme.of(context).accentColor,
                      textColor: Colors.yellowAccent,
                      onPressed: () {
                        //if (_formKey.currentState.validate()) {
                        Navigator.pushReplacementNamed(context, '/all');
                        //}
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
