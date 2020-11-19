/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'map_data.dart';


class PartnerMarkersMap extends StatefulWidget {
  PartnerMarkersMap({this.onMapLoaded, this.onMapInteraction});
  final void Function() onMapLoaded;
  final void Function(LatLng) onMapInteraction;
  PartnerMarkersMapState _s;

  void addMarker(LatLng location, var info) {
    _s.addMarker(location, info);
  }
  void locateAndTakeMe(LatLng dest, LatLng client) {
    _s.locateAndTakeMe(dest, client);
  }
  void refresh() {
    _s.refresh();
  }
  void relocate(LatLng pos) {
    _s.relocate(pos);
  }

  @override
  State<StatefulWidget> createState() {
    _s = PartnerMarkersMapState(onMapLoaded, onMapInteraction);
    return _s;
  }
}

typedef Marker MarkerUpdateAction(Marker marker);

class PartnerMarkersMapState extends State<PartnerMarkersMap> {
  PartnerMarkersMapState(this.onMapLoaded, this.onMapInteraction);
  final void Function() onMapLoaded;
  final void Function(LatLng) onMapInteraction;
  static LatLng center;
  double _currentZoom;

  GoogleMapController controller;
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  PolylinePoints polylinePoints = PolylinePoints();
  MarkerId selectedMarker;
  int _markerIdCounter = 1;
  BitmapDescriptor myLocationIcon;
  BitmapDescriptor destLocationIcon;

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
    onMapLoaded();
  }

  @override
  void initState() {
    super.initState();
    center = LatLng(
      ArrivalMapData.initalLat,
      ArrivalMapData.initalLng,
    );
    _currentZoom = ArrivalMapData.initalZoom;

    _setMarkerIcons();
  }
  @override
  void dispose() {
    super.dispose();
  }
  void _setMarkerIcons() async {
    myLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/icon/driving_pin.png');
    destLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/icon/destination_map_marker.png');
  }

  void refresh() {
    setState(() {
      markers = <MarkerId, Marker>{};
    });
  }


  final MarkerId _myLocationMarkerId = MarkerId('myLocation_marker');
  final PolylineId polylineId = PolylineId('destination_polyline');
  LatLng _destination;
  void relocate(LatLng myLocation) async {
    if (_destination==null) return;

    final Marker marker = Marker(
      markerId: _myLocationMarkerId,
      position: myLocation,
      icon: myLocationIcon,
      infoWindow: InfoWindow(title: 'You are on route'),
    );

    List<LatLng> polylineCoordinates = [];
    List<PointLatLng> result = await polylinePoints
        ?.getRouteBetweenCoordinates(
            'AIzaSyDGiAXusfesRoqC7Nmanca3F1bHY0poyxc',
            myLocation.latitude,
            myLocation.longitude,
            _destination.latitude,
            _destination.longitude,
        );

    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude)
        );
      });
    }

    polylines[polylineId] = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      width: 5,
      points: polylineCoordinates,
    );

    setState(() {
      markers[_myLocationMarkerId] = marker;

      controller.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: myLocation,
            northeast: _destination,
          ),
          50,
        ),
      );
    });
  }
  void locateAndTakeMe(LatLng destination, LatLng myLocation) {
    markers = <MarkerId, Marker>{};

    _destination = destination;

    final String destIdVal = 'destination_marker';
    final MarkerId destId = MarkerId(destIdVal);

    final Marker dest = Marker(
      markerId: destId,
      position: _destination,
      icon: destLocationIcon,
      infoWindow: InfoWindow(title: 'Your destination'),
    );

    markers[destId] = dest;

    relocate(myLocation);
  }

  void addMarker(LatLng location, var info) {
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: location,
      infoWindow: InfoWindow(title: info['title'], snippet: info['info']),
      onTap: () {
        _onMarkerTapped(markerId);
      },
      onDragEnd: (LatLng position) {
        _onMarkerDragEnd(markerId, position);
      },
    );

    setState(() {
      markers[markerId] = marker;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: location,
            zoom: 16,
          ),
        ),
      );
    });
  }

  void _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }

  void _onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                actions: <Widget>[
                  FlatButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
                content: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 66),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Old position: ${tappedMarker.position}'),
                        Text('New position: $newPosition'),
                      ],
                    )));
          });
    }
  }

  void _add() {
    final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }

    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        center.latitude + sin(_markerIdCounter * pi / 6.0) / 20.0,
        center.longitude + cos(_markerIdCounter * pi / 6.0) / 20.0,
      ),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {
        _onMarkerTapped(markerId);
      },
      onDragEnd: (LatLng position) {
        _onMarkerDragEnd(markerId, position);
      },
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  void _remove() {
    setState(() {
      if (markers.containsKey(selectedMarker)) {
        markers.remove(selectedMarker);
      }
    });
  }

  void _changePosition() {
    final Marker marker = markers[selectedMarker];
    final LatLng current = marker.position;
    final Offset offset = Offset(
      center.latitude - current.latitude,
      center.longitude - current.longitude,
    );
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        positionParam: LatLng(
          center.latitude + offset.dy,
          center.longitude + offset.dx,
        ),
      );
    });
  }

  void _changeAnchor() {
    final Marker marker = markers[selectedMarker];
    final Offset currentAnchor = marker.anchor;
    final Offset newAnchor = Offset(1.0 - currentAnchor.dy, currentAnchor.dx);
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        anchorParam: newAnchor,
      );
    });
  }

  Future<void> _changeInfoAnchor() async {
    final Marker marker = markers[selectedMarker];
    final Offset currentAnchor = marker.infoWindow.anchor;
    final Offset newAnchor = Offset(1.0 - currentAnchor.dy, currentAnchor.dx);
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        infoWindowParam: marker.infoWindow.copyWith(
          anchorParam: newAnchor,
        ),
      );
    });
  }

  Future<void> _toggleDraggable() async {
    final Marker marker = markers[selectedMarker];
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        draggableParam: !marker.draggable,
      );
    });
  }

  Future<void> _toggleFlat() async {
    final Marker marker = markers[selectedMarker];
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        flatParam: !marker.flat,
      );
    });
  }

  Future<void> _changeInfo() async {
    final Marker marker = markers[selectedMarker];
    final String newSnippet = marker.infoWindow.snippet + '*';
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        infoWindowParam: marker.infoWindow.copyWith(
          snippetParam: newSnippet,
        ),
      );
    });
  }

  Future<void> _changeAlpha() async {
    final Marker marker = markers[selectedMarker];
    final double current = marker.alpha;
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        alphaParam: current < 0.1 ? 1.0 : current * 0.75,
      );
    });
  }

  Future<void> _changeRotation() async {
    final Marker marker = markers[selectedMarker];
    final double current = marker.rotation;
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        rotationParam: current == 330.0 ? 0.0 : current + 30.0,
      );
    });
  }

  Future<void> _toggleVisible() async {
    final Marker marker = markers[selectedMarker];
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        visibleParam: !marker.visible,
      );
    });
  }

  Future<void> _changeZIndex() async {
    final Marker marker = markers[selectedMarker];
    final double current = marker.zIndex;
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        zIndexParam: current == 12.0 ? 0.0 : current + 1.0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: const CameraPosition(
        target: LatLng(ArrivalMapData.initalLat, ArrivalMapData.initalLng),
        zoom: ArrivalMapData.initalZoom,
      ),
      polylines: Set<Polyline>.of(polylines.values),
      onTap: (LatLng pos) {
        onMapInteraction(pos);
      },
      markers: Set<Marker>.of(markers.values),
    );
  }
}
