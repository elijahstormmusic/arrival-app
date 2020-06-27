
import 'package:location/location.dart';
import 'package:arrival_kc/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class MyLocation {
  double lat = 34.0;
  double lng = -94.0;
  LocationData currentLocation;
  Location location;
  void initState() {
    location = new Location();
//    location.onLocationChanged().listen((LocationData cLoc) {
//      currentLocation = cLoc;
//    });
    setInitialLocation();
  }
  void setInitialLocation() async {
    currentLocation = await location.getLocation();
    lat = currentLocation.latitude;
    lng = currentLocation.longitude;
  }
}

class Maps extends StatefulWidget {
  static MyLocation myself = MyLocation();
  String _query;
  Maps() {
    this._query = "";
  }
  Maps.partners(String _q) {
    this._query = "?p:"+_q;
  }
  Maps.directions(String _q) {
    this._query = "?d:"+_q+":"+myself.lat.toString()+":"+myself.lng.toString();
  }

  @override
  _MapState createState() => _MapState(_query);
}

class _MapState extends State<Maps> {
  final String query;
  _MapState(this.query);

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
          title: Text('Arrival'),
      ),
      url: 'https://arrival-app.herokuapp.com/maps'+query,
    );
  }
}
