
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyLocation {
  double lat = 34.0;
  double lng = -94.0;
  LocationData currentLocation;
  Location location;
  _MapState _state;

  void initState() {
    location = new Location();
    location.onLocationChanged.listen((LocationData cLoc) {
      currentLocation = cLoc;
      if (_state != null) {
        _state.relocate();
      }
    });
    setInitialLocation();
  }
  void setInitialLocation() async {
    currentLocation = await location.getLocation();
    lat = currentLocation.latitude;
    lng = currentLocation.longitude;
  }
  void relocationHandler(_MapState state) {
    _state = state;
  }

  @override
  String toString() {
    return '{lat:' + lat.toString() + ',lng:' + lng.toString() + '}';
  }
}

class Maps extends StatefulWidget {
  static MyLocation myself = MyLocation();
  String _query;
  Maps() {
    this._query = "?m:"+myself.lat.toString()+":"+myself.lng.toString();
  }
  Maps.partners(String _q) {
    this._query = "?p:"+_q+":"+myself.lat.toString()+":"+myself.lng.toString();
  }
  Maps.directions(String _q) {
    this._query = "?d:"+_q+":"+myself.lat.toString()+":"+myself.lng.toString();
  }

  @override
  _MapState createState() => _MapState(_query, myself);
}

class _MapState extends State<Maps> {
  final String query;
  MyLocation myself;
  WebViewController _webViewController;
  _MapState(this.query, this.myself);

  @override
  void initState() {
    myself.relocationHandler(this);
    super.initState();
  }

  void relocate() {
    _webViewController?.evaluateJavascript(
        'Data.Relocate(' + myself.toString() + ');'
    );
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'https://arrival-app.herokuapp.com/maps'+query,
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: Set.from([
        JavascriptChannel(
            name: 'AppAndPageCommunication',
            onMessageReceived: (JavascriptMessage message) {
              if (message.message=='reached dest') {
                print('you have reached your destination!');
              }
              else if (message.message=='directions') {
                print('finding directions');
              }
              else print('function could not be found');
            })
      ]),
      onWebViewCreated: (WebViewController w) {
        _webViewController = w;
      },
    );
  }
}
