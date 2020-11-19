/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'map_data.dart';


class MyLocation {
  double lat = ArrivalMapData.initalLat;
  double lng = ArrivalMapData.initalLng;
  Geolocator geolocator;
  List<Placemark> placemark;
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  StreamSubscription<Position> positionStream;
  void Function(LatLng) onRelocation;

  LatLng get latlng {
    return LatLng(lat, lng);
  }

  MyLocation({this.onRelocation}) {
    _getLocation();
  }

  void _getLocation() async {
    geolocator = await Geolocator();

    Position curLoc = await geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best
    );

    positionStream = geolocator.getPositionStream(locationOptions).listen(
        (Position position) {
            lat = position.latitude;
            lng = position.longitude;
            onRelocation(LatLng(lat, lng));
        });

    lat = curLoc.latitude;
    lng = curLoc.longitude;
  }

  @override
  String toString() {
    return '{lat:' + lat.toString() + ',lng:' + lng.toString() + '}';
  }
}
