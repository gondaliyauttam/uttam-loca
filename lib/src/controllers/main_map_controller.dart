import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:loca_bird/src/elements/scan_dialog.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:loca_bird/config/app_images.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:loca_bird/src/helpers/helper.dart';
import 'package:loca_bird/src/models/location_type.dart';
import 'package:loca_bird/src/models/restaurantdata.dart';
import 'package:loca_bird/src/models/availableColor.dart';
import 'package:loca_bird/src/repository/restaurant_repository.dart';
import 'package:loca_bird/config/app_constant.dart';
import 'package:loca_bird/src/repository/settings_repository.dart' as settings;
import 'package:qrscan/qrscan.dart' as scanner;

class NewMapController extends ControllerMVC {
  List<Restaurant> nearRestaurants = <Restaurant>[];
  List<AvailableColor> availablecolor = <AvailableColor>[];
  List<LocationType> locationtypelist = <LocationType>[];
  List<Marker> allMarkers = <Marker>[];
  LocationData currentLocation;
  LocationData myLocation;
  CameraPosition cameraPosition;
  String darkMapStyle, normalMapStyle;
  Restaurant restaurant;
  perm.PermissionStatus _permissionStatus = perm.PermissionStatus.undetermined;
  List<int> selecteditem = new List<int>();
  bool loaded = true;
  bool isselected = true;
  GlobalKey<ScaffoldState> scaffoldKey;
  bool hidelist = false;

  Timer timer;

  /*  PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};*/

  Future<void> refreshrestaurant() async {
    nearRestaurants.clear();
    listenForNearRestaurants(currentLocation,
        message: 'Resturant refreshed successfuly');
  }

  NewMapController() {
    getlocationtype();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    rootBundle.loadString('assets/dark_map_style.json').then((string) {
      darkMapStyle = string;
    });
    rootBundle.loadString('assets/normal_map_style.json').then((string) {
      normalMapStyle = string;
    });
    timer = Timer.periodic(
        Duration(seconds: apicall), (Timer t) => getStatusUpdats());
  }

  Future<void> requestPermission(perm.Permission permission) async {
    final status = await permission.request();
    setState(() {
      print(status);
      _permissionStatus = status;
      print(_permissionStatus);
      if (_permissionStatus.isGranted) {
        getCurrentLocation();

        locationpermission = true;
      } else {
        requestPermission(perm.Permission.location);
      }
    });
  }

  void getCurrentLocation() async {
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
      print(currentLocation);
      setState(() {
        cameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 14.50,
        );
        listenForNearRestaurants(currentLocation);
      });

      settings.setCurrentLocation().then((locationData) {
        setState(() {
          settings.locationData = locationData;
        });
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
  }

  Future<void> goCurrentLocation(
      Completer<GoogleMapController> mapController) async {
    final GoogleMapController controller = await mapController.future;
    setState(() {
      if (Theme.of(context).brightness == Brightness.dark) {
        controller.setMapStyle(darkMapStyle);
      } else {
        controller.setMapStyle(normalMapStyle);
      }
      hidelist = false;
    });
    var location = new Location();
    myLocation = await location.getLocation();
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(myLocation.latitude, myLocation.longitude),
      zoom: 14.50,
    )));
  }

  void updatePosition(CameraPosition _position) {
    print(
        'inside updatePosition ${_position.target.latitude} ${_position.target.longitude}');
    Map<String, double> map = {
      'latitude': _position.target.latitude,
      'longitude': _position.target.longitude
    };
    currentLocation = new LocationData.fromMap(map);

    /* Marker marker = allMarkers.firstWhere(
        (p) => p.markerId == MarkerId('marker_2'),
        orElse: () => null);

    allMarkers.remove(marker);*/
  }

  void getRestaurantsOfArea() async {
    if (currentLocation == null) {
      currentLocation = myLocation;
    }
    setState(() {
      listenForNearRestaurants(currentLocation);
    });
  }

  void getLocationTypeRestaurant(String id) {
    selecteditem.clear();
    selecteditem.add(int.parse(id));
    listenForNearRestaurants(currentLocation);
  }

  void listenForNearRestaurants(LocationData myLocation,
      {String message}) async {
    nearRestaurants.clear();
    final Stream<Restaurant> stream =
        await getMapRestaurants(myLocation, selecteditem);

    stream.listen(
        (Restaurant _restaurant) {
          setState(() {
            nearRestaurants.add(_restaurant);
            notifyListeners();
          });
        },
        onError: (a) {},
        onDone: () {
          setState(() {
            loaded = false;
            allMarkers.clear();
          });
          if (nearRestaurants.isNotEmpty) {
            nearRestaurants.forEach((element) {
              Helper.getMarkers(
                  context,
                  element.toMap(),
                  /* multiplemarker[element.locationType[0].name.toLowerCase()]
                      [element.counterColor.toLowerCase()]*/
                  element.counterColorImage, () {
                print(element.toMap());
                setState(() {
                  restaurant = element;
                  hidelist = true;
                });
              }).then((marker) {
                setState(() {
                  allMarkers.add(marker);
                });
              });
            });
            getStatusUpdats();
          } else {}

          if (message != null) {
            scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(message),
            ));
          }
        });
  }

  void getlocationtype() async {
    final Stream<LocationType> stream = await getLocationType();
    stream.listen((LocationType _locationType) {
      setState(() => locationtypelist.add(_locationType));
    }, onError: (a) {
      print(a);
    }, onDone: () {
      locationtypelist.forEach((element) {
        selecteditem.add(element.id);
      });
    });
  }

  @override
  void deactivate() {
    timer.cancel();
  }

  Future<void> getfiltereddata() async {
    setState(() {
      loaded = true;
      allMarkers.clear();
      nearRestaurants.clear();
      listenForNearRestaurants(currentLocation);
    });
  }

  void getStatusUpdats() async {
    List<int> ids = new List<int>();

    if (nearRestaurants.length != 0) {
      nearRestaurants.forEach((element) {
        ids.add(int.parse(element.id));
      });
      if (ids.length != 0) {
        List<AvailableColor> ac = await getstatusupdates(pagenumber: ids);
        if (ac.length != 0) {
          availablecolor = ac;
          nearRestaurants.forEach((element) {
            availablecolor.forEach((a) {
              if (element.id == a.id.toString()) {
                element.counterColor = a.counterColor;
              }
            });
          });
        }
      }
    }
  }

  Future scan() async {
    final status = await perm.Permission.camera.request();
    if (status.isGranted) {
      String barcode = await scanner.scan();

      if (barcode == null) {
        print('nothing return.');
      } else {
        print(barcode);
        var id = barcode.substring(barcode.lastIndexOf('/') + 1);
        print(id);

        if (isNumeric(id)) {
          showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog(id),
          );
        } else {
          BotToast.showText(
              text: "Not Valid QR Code",
              duration: Duration(
                seconds: 1,
              ));
        }
      }
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

/*createPolylines(String latitude, String longitude) async {
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GlobalConfiguration().getString('google_maps_key'), // Google Maps API Key
      PointLatLng(myLocation.latitude, myLocation.longitude),
      PointLatLng(double.parse(latitude), double.parse(longitude)),
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
}
