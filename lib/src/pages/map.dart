import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:loca_bird/config/app_images.dart';
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/controllers/map_controller.dart';
import 'package:loca_bird/src/elements/CardsCarouselWidget.dart';
import 'package:loca_bird/src/elements/CircularLoadingWidget.dart';
import 'package:loca_bird/src/models/restaurantdata.dart';
import 'package:loca_bird/src/models/route_argument.dart';

// ignore: must_be_immutable
class MapWidget extends StatefulWidget {
  RouteArgument routeArgument;

  MapWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends StateMVC<MapWidget> {
  MapController _con;

  _MapWidgetState() : super(MapController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.currentRestaurant = widget.routeArgument.param as Restaurant;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_con.googleMapController != null) {
      if (Theme.of(context).brightness == Brightness.dark) {
        _con.googleMapController.setMapStyle(_con.darkMapStyle);
      } else {
        _con.googleMapController.setMapStyle(_con.normalMapStyle);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).maps_explorer,
          style: Theme.of(context)
              .textTheme
              .title
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.my_location,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              _con.goCurrentLocation();
            },
          )
        ],
      ),
      body: Stack(
//        fit: StackFit.expand,
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
          _con.cameraPosition == null
              ? CircularLoadingWidget(height: 0)
              : GoogleMap(
                  mapToolbarEnabled: false,
                  mapType: MapType.normal,
                  initialCameraPosition: _con.cameraPosition,
                  markers: Set.from(_con.allMarkers),
                  onMapCreated: (GoogleMapController controller) {
                    _con.mapController.complete(controller);
                    _con.googleMapController = controller;
                    if (Theme.of(context).brightness == Brightness.dark) {
                      _con.googleMapController.setMapStyle(_con.darkMapStyle);
                    } else {
                      _con.googleMapController.setMapStyle(_con.normalMapStyle);
                    }
                  },
                  onCameraMove: (CameraPosition cameraPosition) {
                    _con.cameraPosition = cameraPosition;
                  },
                  onCameraIdle: () {
                    _con.getRestaurantsOfArea();
                  },
                  polylines: _con.polylines,

                ),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                _con.openMap();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 30,
                  width: 30,
                  child: SvgPicture.asset(directionimg, color: Theme.of(context).accentColor),
                ),
              ),
            ),
          ),
          CardsCarouselWidget(
            restaurantsList: _con.topRestaurants,
            heroTag: 'map_restaurants',
          ),
        ],
      ),
    );
  }
}
