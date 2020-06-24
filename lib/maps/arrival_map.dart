
import 'dart:async';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'components/map_pin_pill.dart';
import 'models/pin_pill_info.dart';
import 'package:Arrival/widgets/close_button.dart';
import 'package:Arrival/data/local_saved_businesses.dart';
import 'package:Arrival/styles.dart';


class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapPageState();

  void updateTargetLocation(LatLng location) {}
}

class ArrivalMapData {
  static const double cameraZoom = 16;
  static const double cameraTilt = 80;
  static const double cameraBearing = 30;
  static const LatLng sourceLocation = LatLng(42.747932, -71.167889);
  static LatLng destLocation = LatLng(37.335685, -122.0605916);
}

class MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = Set<Marker>();
// for my drawn routes on the map
  final Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  String googleAPIKey = 'AIzaSyC-OqZaQBWWRFi415UVqyiZlk-iB26rumI';
// for my custom marker pins
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
// the user's initial location and current location
// as it moves
  LocationData currentLocation;
// a reference to the destination location
  LocationData destinationLocation;
// wrapper around the location API
  Location location;
  double pinPillPosition = -100;
  PinInformation currentlySelectedPin = PinInformation(
      pinPath: '',
      avatarPath: '',
      location: LatLng(0, 0),
      locationName: '',
      labelColor: Colors.grey);
  PinInformation sourcePinInfo;
  PinInformation destinationPinInfo;

  @override
  void initState() {
    super.initState();

    // create an instance of Location
    location = Location();
    polylinePoints = PolylinePoints();

    // subscribe to changes in the user's location
    // by 'listening' to the location's onLocationChanged event
    location.onLocationChanged.listen((cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      currentLocation = cLoc;
      updatePinOnMap();
    });
    // set custom marker pins
    setSourceAndDestinationIcons();
    // set the initial location
    setInitialLocation();
  }

  void setSourceAndDestinationIcons() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.0), 'assets/icon/driving_pin.png')
        .then((onValue) {
      sourceIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.0),
        'assets/icon/destination_map_marker.png')
        .then((onValue) {
      destinationIcon = onValue;
    });
  }

  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await location.getLocation();

    // hard-coded destination for this example
    destinationLocation = LocationData.fromMap({
      'latitude': ArrivalMapData.destLocation.latitude,
      'longitude': ArrivalMapData.destLocation.longitude
    });
  }

  void updateTargetLocation(LatLng loc) {
    destinationLocation = LocationData.fromMap({
      'latitude': loc.latitude,
      'longitude': loc.longitude
    });
    showPinsOnMap();
  }

  @override
  Widget build(BuildContext context) {
    var initialCameraPosition = CameraPosition(
        zoom: ArrivalMapData.cameraZoom,
        tilt: ArrivalMapData.cameraTilt,
        bearing: ArrivalMapData.cameraBearing,
        target: ArrivalMapData.sourceLocation);
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: ArrivalMapData.cameraZoom,
          tilt: ArrivalMapData.cameraTilt,
          bearing: ArrivalMapData.cameraBearing);
    }
    return MaterialApp(
      title: 'Arrival Map',
      home: Scaffold(
        appBar: AppBar(
            title: ArrivalTitle(),
//          Positioned(
//            top: 16,
//            left: 16,
//            child: SafeArea(
//              child: ArrCloseButton(() {
//                Navigator.of(context).pop();
//              }),
//            ),
//          ),
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
//              GoogleMap(
//                  myLocationEnabled: true,
//                  compassEnabled: true,
//                  tiltGesturesEnabled: false,
//                  markers: _markers,
//                  polylines: _polylines,
//                  mapType: MapType.normal,
//                  initialCameraPosition: initialCameraPosition,
//                  onTap: (loc) {
//                    pinPillPosition = -100;
//                  },
//                  onMapCreated: (controller) {
//                    controller.setMapStyle(Utils.mapStyles);
//                    _controller.complete(controller);
//                    // my map has completed being created;
//                    // i'm ready to show the pins on the map
//                    showPinsOnMap();
//                  }),
              MapPinPillComponent(
                  pinPillPosition: pinPillPosition,
                  currentlySelectedPin: currentlySelectedPin),
            ],
          ),
        ),
      ),
    );
  }

  void showPinsOnMap() {
    // get a LatLng for the source location
    // from the LocationData currentLocation object
    var pinPosition =
    LatLng(currentLocation.latitude, currentLocation.longitude);
    // get a LatLng out of the LocationData object
    var destPosition =
    LatLng(destinationLocation.latitude, destinationLocation.longitude);

    sourcePinInfo = PinInformation(
        locationName: 'Start Location',
        location: ArrivalMapData.sourceLocation,
        pinPath: 'assets/icon/driving_pin.png',
        avatarPath: 'assets/icon/friend.png',
        labelColor: Colors.blueAccent);

    destinationPinInfo = PinInformation(
        locationName: 'End Location',
        location: ArrivalMapData.destLocation,
        pinPath: 'assets/icon/destination_map_marker.png',
        avatarPath: 'assets/icon/friend.png',
        labelColor: Colors.purple);

    // add the initial source location pin
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        onTap: () {
          setState(() {
            currentlySelectedPin = sourcePinInfo;
            pinPillPosition = 0;
          });
        },
        icon: sourceIcon));
    // destination pin
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        onTap: () {
          setState(() {
            currentlySelectedPin = destinationPinInfo;
            pinPillPosition = 0;
          });
        },
        icon: destinationIcon));
    // set the route lines on the map from source to destination
    // for more info follow this tutorial
    setPolylines();
  }

  void setPolylines() async {
    var result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        currentLocation.latitude,
        currentLocation.longitude,
        destinationLocation.latitude,
        destinationLocation.longitude);

    if (result.isNotEmpty) {
      result.forEach((point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        _polylines.add(Polyline(
            width: 2, // set the width of the polylines
            polylineId: PolylineId('poly'),
            color: Color.fromARGB(255, 40, 122, 198),
            points: polylineCoordinates));
      });
    }
  }

  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    var cPosition = CameraPosition(
      zoom: ArrivalMapData.cameraZoom,
      tilt: ArrivalMapData.cameraTilt,
      bearing: ArrivalMapData.cameraBearing,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition =
      LatLng(currentLocation.latitude, currentLocation.longitude);

      sourcePinInfo.location = pinPosition;

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          onTap: () {
            setState(() {
              currentlySelectedPin = sourcePinInfo;
              pinPillPosition = 0;
            });
          },
          position: pinPosition, // updated position
          icon: sourceIcon));
    });
  }
}

class Utils {
  static String mapStyles = '''[
  {
    'elementType': 'geometry',
    'stylers': [
      {
        'color': '#f5f5f5'
      }
    ]
  },
  {
    'elementType': 'labels.icon',
    'stylers': [
      {
        'visibility': 'off'
      }
    ]
  },
  {
    'elementType': 'labels.text.fill',
    'stylers': [
      {
        'color': '#616161'
      }
    ]
  },
  {
    'elementType': 'labels.text.stroke',
    'stylers': [
      {
        'color': '#f5f5f5'
      }
    ]
  },
  {
    'featureType': 'administrative.land_parcel',
    'elementType': 'labels.text.fill',
    'stylers': [
      {
        'color': '#bdbdbd'
      }
    ]
  },
  {
    'featureType': 'poi',
    'elementType': 'geometry',
    'stylers': [
      {
        'color': '#eeeeee'
      }
    ]
  },
  {
    'featureType': 'poi',
    'elementType': 'labels.text.fill',
    'stylers': [
      {
        'color': '#757575'
      }
    ]
  },
  {
    'featureType': 'poi.park',
    'elementType': 'geometry',
    'stylers': [
      {
        'color': '#e5e5e5'
      }
    ]
  },
  {
    'featureType': 'poi.park',
    'elementType': 'labels.text.fill',
    'stylers': [
      {
        'color': '#9e9e9e'
      }
    ]
  },
  {
    'featureType': 'road',
    'elementType': 'geometry',
    'stylers': [
      {
        'color': '#ffffff'
      }
    ]
  },
  {
    'featureType': 'road.arterial',
    'elementType': 'labels.text.fill',
    'stylers': [
      {
        'color': '#757575'
      }
    ]
  },
  {
    'featureType': 'road.highway',
    'elementType': 'geometry',
    'stylers': [
      {
        'color': '#dadada'
      }
    ]
  },
  {
    'featureType': 'road.highway',
    'elementType': 'labels.text.fill',
    'stylers': [
      {
        'color': '#616161'
      }
    ]
  },
  {
    'featureType': 'road.local',
    'elementType': 'labels.text.fill',
    'stylers': [
      {
        'color': '#9e9e9e'
      }
    ]
  },
  {
    'featureType': 'transit.line',
    'elementType': 'geometry',
    'stylers': [
      {
        'color': '#e5e5e5'
      }
    ]
  },
  {
    'featureType': 'transit.station',
    'elementType': 'geometry',
    'stylers': [
      {
        'color': '#eeeeee'
      }
    ]
  },
  {
    'featureType': 'water',
    'elementType': 'geometry',
    'stylers': [
      {
        'color': '#c9c9c9'
      }
    ]
  },
  {
    'featureType': 'water',
    'elementType': 'labels.text.fill',
    'stylers': [
      {
        'color': '#9e9e9e'
      }
    ]
  }
]''';
}