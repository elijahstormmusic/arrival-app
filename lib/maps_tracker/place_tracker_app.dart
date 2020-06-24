import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'app_model.dart';
import 'place.dart';
import 'place_list.dart';
import 'place_map.dart';
import 'stub_data.dart';

enum PlaceTrackerViewType {
  map,
  list,
}

class PlaceTrackerApp extends StatefulWidget {
  @override
  _PlaceTrackerAppState createState() => _PlaceTrackerAppState();
}

class _PlaceTrackerAppState extends State<PlaceTrackerApp> {
  MapAppState appState = MapAppState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return AppModel<MapAppState>(
          initialState: MapAppState(),
          child: child,
        );
      },
      home: _PlaceTrackerHomePage(),
    );
  }
}

class _PlaceTrackerHomePage extends StatelessWidget {
  const _PlaceTrackerHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
              child: Icon(Icons.pin_drop, size: 24.0),
            ),
            Text('Businesses'),
          ],
        ),
        backgroundColor: Colors.red[700],
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
            child: IconButton(
              icon: Icon(
                MapAppState.of(context).viewType == PlaceTrackerViewType.map
                    ? Icons.list
                    : Icons.map,
                size: 32.0,
              ),
              onPressed: () {
                MapAppState.updateWith(
                  context,
                  viewType:
                      MapAppState.of(context).viewType == PlaceTrackerViewType.map
                          ? PlaceTrackerViewType.list
                          : PlaceTrackerViewType.map,
                );
              },
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index:
            MapAppState.of(context).viewType == PlaceTrackerViewType.map ? 0 : 1,
        children: <Widget>[
          PlaceMap(center: const LatLng(39.0997, 94.5786)),
          PlaceList(),
        ],
      ),
    );
  }
}

class MapAppState {
  const MapAppState({
    this.places = StubData.places,
    this.selectedCategory = PlaceCategory.favorite,
    this.viewType = PlaceTrackerViewType.map,
  })  : assert(places != null),
        assert(selectedCategory != null);

  final List<Place> places;
  final PlaceCategory selectedCategory;
  final PlaceTrackerViewType viewType;

  MapAppState copyWith({
    List<Place> places,
    PlaceCategory selectedCategory,
    PlaceTrackerViewType viewType,
  }) {
    return MapAppState(
      places: places ?? this.places,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      viewType: viewType ?? this.viewType,
    );
  }

  static MapAppState of(BuildContext context) => AppModel.of<MapAppState>(context);

  static void update(BuildContext context, MapAppState newState) {
    AppModel.update<MapAppState>(context, newState);
  }

  static void updateWith(
    BuildContext context, {
    List<Place> places,
    PlaceCategory selectedCategory,
    PlaceTrackerViewType viewType,
  }) {
    update(
      context,
      MapAppState.of(context).copyWith(
        places: places,
        selectedCategory: selectedCategory,
        viewType: viewType,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is MapAppState &&
        other.places == places &&
        other.selectedCategory == selectedCategory &&
        other.viewType == viewType;
  }

  @override
  int get hashCode => hashValues(places, selectedCategory, viewType);
}
