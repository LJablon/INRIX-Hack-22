import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:inrix_hack_22/models/proximity_reminder.dart';
import 'dart:collection';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inrix_hack_22/backend/flask_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inrix_hack_22/app.dart';
import 'package:inrix_hack_22/models/proximity_reminder.dart';
import 'package:inrix_hack_22/backend/database_manager.dart';
import 'package:inrix_hack_22/backend/geolocation.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key, required this.proximityReminder})
      : super(key: key);
  final ProximityReminder proximityReminder;

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  void initState() {
    super.initState();
  }

  determinePositionWrap() async {
    return await determinePosition();
  }

  checkIfInsideAreaWrap(myLon, myLat, timeTresh, lon, lat) async {
    return await checkIfInsideArea(myLon, myLat, timeTresh, lon, lat);
  }

  @override
  Widget build(BuildContext context) {
    // for google maps initialization
    late GoogleMapController mapController;
    final LatLng _center = LatLng(
        widget.proximityReminder.latitude, widget.proximityReminder.latitude);
    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;
    }

    Position position = determinePositionWrap();

    List coords = checkIfInsideAreaWrap(
        position.longitude,
        position.latitude,
        widget.proximityReminder.proximity,
        widget.proximityReminder.longitude,
        widget.proximityReminder.latitude)['coords'];

    List<LatLng> points = [];
    for (int i = 0; i < coords.length; i++) {
      points.add(LatLng(coords[1], coords[1]));
    }

    // this is a list of polygons around santa clara for demo
    // List<LatLng> points = [
    //   LatLng(37.350264, -121.943206),
    //   LatLng(37.351582, -121.939321),
    //   LatLng(37.348064, -121.937111),
    //   LatLng(37.346617, -121.941263),
    // ];
    Set<Polygon> _polygon = HashSet<Polygon>();

    // initialize the polygon
    _polygon.add(Polygon(
      // given polygonId
      polygonId: PolygonId('1'),
      // initialize the list of points to display polygon
      points: points,
      // given color to polygon
      fillColor: Colors.green.withOpacity(0.3),
      // given border color to polygon
      strokeColor: Colors.green,
      geodesic: true,
      // given width of border
      strokeWidth: 4,
    ));

    return Scaffold(
      appBar: AppBar(title: const Text("Location Page")),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 11.0,
                  ),
                  polygons: _polygon),
              // add map here
              Text('Address: ${widget.proximityReminder.address}'),
              Text('Phone Number: ${widget.proximityReminder.phoneNumber}'),
              Text(
                  'Phone Number Name: ${widget.proximityReminder.phoneNumberName}'),
            ],
          ),
        ),
      ),
    );
  }
}
