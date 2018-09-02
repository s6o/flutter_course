import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:http/http.dart' as http;

import '../models/remote_storage.dart';

class LocationInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  final FocusNode _addressInput = FocusNode();
  Uri _staticMapUri;
  TextEditingController _addressInputController = TextEditingController();

  @override
  void initState() {
    getStaticMap();
    _addressInput.addListener(_updateLocation);
    super.initState();
  }

  @override
  void dispose() {
    _addressInput.removeListener(_updateLocation);
    super.dispose();
  }

  void getStaticMap([String address]) async {
    final RemoteStorage rs = RemoteStorage();
    final String mapApiKey = await rs.readMapApiKey();
    String _formattedAddress = address;
    double _latitude = 41.40338;
    double _longitude = 2.17403;

    if (address != null && address.isNotEmpty) {
      Uri reqUri = Uri.https(
        'maps.googleapis.com',
        '/maps/api/geocode/json',
        {'address': address, 'key': mapApiKey},
      );
      final http.Response response = await http.get(reqUri);
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        print(result);
        final coords = result['results'][0]['geometry']['location'];
        _formattedAddress = result['results'][0]['formatted_address'];
        _latitude = coords['lat'];
        _longitude = coords['lng'];
      } else {
        print('Location geodecode failure ${response.reasonPhrase}');
      }
    }

    try {
      final StaticMapProvider mapProvider = StaticMapProvider(mapApiKey);
      final Uri uri = mapProvider.getStaticUriWithMarkers(
          [Marker('position', 'Position', _latitude, _longitude)],
          center: Location(_latitude, _longitude),
          width: 400,
          height: 300,
          maptype: StaticMapViewType.roadmap);
      setState(() {
        _staticMapUri = uri;
        if (_formattedAddress != null) {
          _addressInputController.text = _formattedAddress;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _updateLocation() {
    if (_addressInput.hasFocus == false) {
      getStaticMap(_addressInputController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: _addressInputController,
          decoration: InputDecoration(labelText: 'Address'),
          focusNode: _addressInput,
        ),
        SizedBox(
          height: 10.0,
        ),
        (_staticMapUri == null
            ? Container()
            : Image.network(_staticMapUri.toString())),
      ],
    );
  }
}
