/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:async';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'locator.dart';

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
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  dynamic _currentMapType = MapType.normal;

  _MapState(this.query, this.myself);


  @override
  void initState() {
    myself.relocationHandler(this);
    super.initState();
  }

  void relocate() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // GoogleMap(
          //   // mapType: _currentMapType,
          //   markers: _markers,
          //   onCameraMove: _onCameraMove,
          //   initialCameraPosition: CameraPosition(
          //     target: LatLng(myself.lat, myself.lng),
          //     zoom: 7,
          //   ),
          //   onMapCreated: (GoogleMapController controller) {
          //     _controller.complete(controller);
          //   },
          // ),
        ],
      ),
    );
  }
}
