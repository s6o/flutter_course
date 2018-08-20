import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main_model.dart';

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
  bool _signup = false;
  final TextEditingController _pwdController = TextEditingController();

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
                      validator: (String v) {
                        if (v.isEmpty) {
                          return 'Non empty email address is required.';
                        }
                      },
                    ),
                    SizedBox(
                      height: 11.0,
                    ),
                    TextFormField(
                      controller: _pwdController,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          filled: true,
                          fillColor: Colors.white),
                      obscureText: true,
                      onSaved: (String v) => _formData['password'] = v,
                      validator: (String v) {
                        if (v.isEmpty) {
                          return 'Non empty password is required.';
                        }
                        if (v.length < 6) {
                          return 'Minimum expected password length is 6 characters.';
                        }
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    _buildPwdCheck(context),
                    SizedBox(
                      height: _signup ? 10.0 : 0.0,
                    ),
                    ScopedModelDescendant<MainModel>(
                      builder: (BuildContext context, Widget child,
                          MainModel model) {
                        return RaisedButton(
                          child: _signup ? Text('SIGN UP') : Text('LOGIN'),
                          color: Theme.of(context).accentColor,
                          textColor: Colors.yellowAccent,
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }
                            _formKey.currentState.save();
                            if (_signup) {
                              model
                                  .signup(
                                      _formData['email'], _formData['password'])
                                  .then((_) {
                                Navigator.pushReplacementNamed(context, '/all');
                              }).catchError((e) {
                                _showError(context, 'Sign Up Failed', e);
                              });
                            } else {
                              model
                                  .login(
                                      _formData['email'], _formData['password'])
                                  .then((_) {
                                Navigator.pushReplacementNamed(context, '/all');
                              }).catchError((e) {
                                _showError(context, 'Authentication Failed', e);
                              });
                            }
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    FlatButton(
                      child: _signup
                          ? Text('Switch to Login')
                          : Text('Switch to Sign Up'),
                      onPressed: () {
                        setState(() {
                          _signup = !_signup;
                        });
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

  Widget _buildPwdCheck(BuildContext context) {
    return (_signup
        ? TextFormField(
            decoration: InputDecoration(
                labelText: 'Confirm Password',
                filled: true,
                fillColor: Colors.white),
            obscureText: true,
            validator: (String v) {
              if (v.isEmpty) {
                return 'Non empty confirmation password is required.';
              }
              if (_pwdController.text != v) {
                return 'Password Confirmation must match Password.';
              }
            },
          )
        : Container());
  }

  void _showError(BuildContext context, String title, Object e) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(e),
            actions: <Widget>[
              FlatButton(
                child: Text('DISMISS'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
