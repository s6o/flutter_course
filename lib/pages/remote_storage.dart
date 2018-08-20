import 'dart:async';
import 'package:flutter/material.dart';

import '../models/remote_storage.dart';

class RemoteStoragePage extends StatefulWidget {
  final RemoteStorage remoteStorage = RemoteStorage();
  final bool asSetup;

  RemoteStoragePage({@required this.asSetup});

  @override
  State<StatefulWidget> createState() {
    return _RemoteStorageState();
  }
}

class _RemoteStorageState extends State<RemoteStoragePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _firebaseUrl;
  String _apiKey;
  bool _setupComplete;

  @override
  void initState() {
    super.initState();
    Future.wait([
      widget.remoteStorage.isSetupComplete(),
      widget.remoteStorage.readApiKey(),
      widget.remoteStorage.readUrl(),
    ]).then((List<dynamic> results) {
      if (results[0]) {
        // TODO: auto-redirect to /auth
      }
      setState(() {
        _setupComplete = results[0];
        _apiKey = results[1];
        _firebaseUrl = results[2];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_setupComplete == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Setup')),
        body: Center(child: CircularProgressIndicator()),
      );
    } else {
      return widget.asSetup
          ? Scaffold(
              appBar: AppBar(title: Text('Setup')),
              body: _buildCard(context),
            )
          : _buildCard(context);
    }
  }

  Widget _buildCard(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth =
        MediaQuery.of(context).orientation == Orientation.landscape
            ? deviceWidth * 0.90
            : deviceWidth;
    final double targetPadding = deviceWidth - targetWidth;

    return Card(
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              TextFormField(
                controller: TextEditingController(text: _firebaseUrl),
                autocorrect: false,
                decoration: InputDecoration(labelText: 'Firebase URL'),
                keyboardType: TextInputType.url,
                onSaved: (String v) => _firebaseUrl = v,
                validator: (String v) {
                  if (v.isEmpty) {
                    return 'A non-empty product title is required.';
                  }
                  if (!v.startsWith('https://')) {
                    return 'The Firebase URL must start with https://';
                  }
                  if (!v.endsWith('/')) {
                    return 'The Firebase URL must end with a slash /';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: TextEditingController(text: _apiKey),
                autocorrect: false,
                decoration: InputDecoration(labelText: 'API key'),
                keyboardType: TextInputType.text,
                onSaved: (String v) => _apiKey = v,
                validator: (String v) {
                  if (v.isEmpty) {
                    return 'A non-empty API key is required.';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              RaisedButton(
                child: Text('SAVE'),
                textColor: Colors.yellowAccent,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    widget.remoteStorage.writeUrl(_firebaseUrl).then((_) {
                      setState(() {});
                    });
                    widget.remoteStorage.writeApiKey(_apiKey).then((_) {
                      setState(() {});
                    });
                    if (widget.asSetup) {
                      Navigator.pushReplacementNamed(context, '/auth');
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
