/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';


class MyLocation {
  double lat = 34.0;
  double lng = -94.0;
  Geolocator geolocator;
  List<Placemark> placemark;
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  StreamSubscription<Position> positionStream;

  LatLng get latlng {
    return LatLng(lat, lng);
  }
  var _state;

  MyLocation() {
    _getLocation();
  }

  void _getLocation() async {
    if (geolocator.checkGeolocationPermissionStatus()!=GeolocationPermission.location) {
      return;
    }

    positionStream = geolocator.getPositionStream(locationOptions).listen(
        (Position position) {
            print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
        });

    // await geolocator = Geolocator();
    Position curLoc = await geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best
        );

    lat = curLoc.latitude;
    lng = curLoc.longitude;

    placemark = await Geolocator().placemarkFromCoordinates(52.2165157, 6.9437819);

    print(placemark[0].country);
    print(placemark[0].position);
    print(placemark[0].locality);
    print(placemark[0].administrativeArea);
    print(placemark[0].postalCode);
    print(placemark[0].name);
    // print(placemark[0].subAdministratieArea);
    print(placemark[0].isoCountryCode);
    print(placemark[0].subLocality);
    print(placemark[0].subThoroughfare);
    print(placemark[0].thoroughfare);

    // double distanceInMeters = await Geolocator().distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);

  }
  void relocationHandler(var state) {
    _state = state;
  }

  @override
  String toString() {
    return '{lat:' + lat.toString() + ',lng:' + lng.toString() + '}';
  }
}
