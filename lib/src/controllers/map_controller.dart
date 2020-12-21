import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:loca_bird/config/app_images.dart';
import 'package:loca_bird/src/helpers/helper.dart';
import 'package:loca_bird/src/helpers/maps_util.dart';
import 'package:loca_bird/src/models/restaurantdata.dart';
import 'package:loca_bird/src/repository/restaurant_repository.dart';
import 'package:loca_bird/src/repository/settings_repository.dart'
    as sett;
import 'package:url_launcher/url_launcher.dart';

class MapController extends ControllerMVC {
  Restaurant currentRestaurant;
  List<Restaurant> topRestaurants = <Restaurant>[];
  List<Marker> allMarkers = <Marker>[];
  LocationData currentLocation;
  Set<Polyline> polylines = new Set();
  CameraPosition cameraPosition;
  MapsUtil mapsUtil = new MapsUtil();
  Completer<GoogleMapController> mapController = Completer();
  GoogleMapController googleMapController;
  String darkMapStyle, normalMapStyle;
  PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];

  //Map<PolylineId, Polyline> polylines = {};

  MapController() {
    rootBundle.loadString('assets/dark_map_style.json').then((string) {
      darkMapStyle = string;
    });
    rootBundle.loadString('assets/normal_map_style.json').then((string) {
      normalMapStyle = string;
    });
    getCurrentLocation();
    getDirectionSteps();
  }

  void listenForNearRestaurants(
      LocationData myLocation, LocationData areaLocation) async {
    final Stream<Restaurant> stream =
        await getNearRestaurants(myLocation, areaLocation);
    stream.listen((Restaurant _restaurant) {
      setState(() {
        topRestaurants.add(_restaurant);
      });
      Helper.getMarkers(
          context,
          _restaurant.toMap(),
          multiplemarker[_restaurant.locationType[0].name.toLowerCase()]
              [_restaurant.counterColor.toLowerCase()], () {
        print(_restaurant.toMap());
      }).then((marker) {
        setState(() {
          allMarkers.add(marker);
        });
      });
      /* Helper.getMarker(_restaurant.toMap()).then((marker) {
        setState(() {
          allMarkers.add(marker);
        });
      });*/
    }, onError: (a) {}, onDone: () {});
  }

  void getCurrentLocation() async {
    try {
      currentLocation = await sett.getCurrentLocation();
      setState(() {
        cameraPosition = CameraPosition(
          target: LatLng(double.parse(currentRestaurant.latitude),
              double.parse(currentRestaurant.longitude)),
          zoom: 14.50,
        );
      });
      Helper.getMyPositionMarker(
              currentLocation.latitude, currentLocation.longitude)
          .then((marker) {
        setState(() {
          allMarkers.add(marker);
        });
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
  }

  Future<void> goCurrentLocation() async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 14.50,
    )));
  }

  void getRestaurantsOfArea() async {
    setState(() {
      topRestaurants = <Restaurant>[];
      LocationData areaLocation = LocationData.fromMap({
        "latitude": cameraPosition.target.latitude,
        "longitude": cameraPosition.target.longitude
      });
      if (cameraPosition != null) {
        listenForNearRestaurants(currentLocation, areaLocation);
      } else {
        listenForNearRestaurants(currentLocation, currentLocation);
      }
    });
  }

  void getDirectionSteps() async {
    currentLocation = await sett.getCurrentLocation();
    mapsUtil
        .get("origin=" +
            currentLocation.latitude.toString() +
            "," +
            currentLocation.longitude.toString() +
            "&destination=" +
            currentRestaurant.latitude +
            "," +
            currentRestaurant.longitude +
            "&key=${GlobalConfiguration().getString('google_maps_key')}")
        .then((dynamic res) {
      List<LatLng> _latLng = res as List<LatLng>;
      _latLng.insert(
          0, new LatLng(currentLocation.latitude, currentLocation.longitude));
      setState(() {
        polylines.add(new Polyline(
            visible: true,
            polylineId: new PolylineId(currentLocation.hashCode.toString()),
            points: _latLng,
            color: Color(0xFFea5c44),
            width: 6));
      });
    });
  }

  Future<void> openMap() async {
    //  String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${currentRestaurant.latitude},${currentRestaurant.longitude}';
    String origin =
        "${currentLocation.latitude},${currentLocation.longitude}"; // lat,long like 123.34,68.56
    String destination =
        "${currentRestaurant.latitude},${currentRestaurant.longitude}";
    print(origin);
    print(destination);

    String googleUrl = "https://www.google.com/maps/dir/?api=1&origin=" +
        origin +
        "&destination=" +
        destination +
        "&travelmode=driving&dir_action=navigate";
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  /*createPolylines() async {
    currentLocation = await sett.getCurrentLocation();
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GlobalConfiguration().getString('google_maps_key'), // Google Maps API Key
      PointLatLng(currentLocation.latitude, currentLocation.longitude),
      PointLatLng(double.parse( currentRestaurant.latitude), double.parse(currentRestaurant.longitude)),
      travelMode: TravelMode.driving,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map
    polylines[id] = polyline;
  }*/

  Future refreshMap() async {
    setState(() {
      topRestaurants = <Restaurant>[];
    });
    listenForNearRestaurants(currentLocation, currentLocation);
  }
}
