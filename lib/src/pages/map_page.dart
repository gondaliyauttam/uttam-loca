import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/controllers/main_map_controller.dart';
import 'package:loca_bird/src/elements/CardWidget.dart';
import 'package:loca_bird/src/elements/CardsCarouselWidget.dart';
import 'package:loca_bird/src/elements/DrawerWidget.dart';
import 'package:loca_bird/src/elements/RestaurantCardWidget.dart';
import 'package:loca_bird/src/elements/scan_dialog.dart';
import 'package:loca_bird/config/app_images.dart';
import 'package:loca_bird/src/elements/Filter_screen.dart';
import 'package:loca_bird/config/app_constant.dart';
import 'package:loca_bird/src/models/route_argument.dart';

class MapPage extends StatefulWidget {
  NewMapController con;

  MapPage({Key key, this.con}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends StateMVC<MapPage> with WidgetsBindingObserver {
  NewMapController _con;

  GoogleMapController googleMapController;
  Completer<GoogleMapController> mapController = Completer();

  @override
  void initState() {
    _con = widget.con;
    if (showpopup) {
      Timer(Duration(seconds: 2), () {
        setState(() {
          showpopup = false;

          showDialog(
            context: context,
            builder: (BuildContext context) => FilterScreen(_con),
          );
        });
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (googleMapController != null) {
      if (Theme.of(context).brightness == Brightness.dark) {
        googleMapController.setMapStyle(_con.darkMapStyle);
      } else {
        googleMapController.setMapStyle(_con.normalMapStyle);
      }
    }

    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // Google Map widget
            _con.cameraPosition == null
                ? Container(child: Center(child: CircularProgressIndicator()))
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: GoogleMap(
                      mapToolbarEnabled: false,
                      initialCameraPosition: _con.cameraPosition,
                      markers: Set.from(_con.allMarkers),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      mapType: MapType.normal,
                      zoomControlsEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        mapController.complete(controller);
                        googleMapController = controller;
                        if (Theme.of(context).brightness == Brightness.dark) {
                          googleMapController.setMapStyle(_con.darkMapStyle);
                        } else {
                          googleMapController.setMapStyle(_con.normalMapStyle);
                        }
                      },
                      onCameraMove: (CameraPosition cameraPosition) {
                        _con.cameraPosition = cameraPosition;
                        _con.updatePosition(cameraPosition);
                      },
                      onCameraIdle: () {
                        _con.getRestaurantsOfArea();
                      },
                      //  polylines: Set<Polyline>.of(_con.polylines.values),
                    ),
                  ),

            // Map markers loading indicator
            _con.cameraPosition == null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Card(
                        elevation: 2,
                        color: Colors.grey.withOpacity(0.9),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            'Loading',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(),
                    ),
                  ),

            Positioned(
              left: 5.0,
              right: 5.0,
              child: AppBar(
                leading: InkWell(
                  child: Icon(Icons.menu,
                      color: Theme.of(context).accentColor.withOpacity(1)),
                  onTap: () {
                    _con.scaffoldKey.currentState.openDrawer();
                  },
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),

            Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  InkWell(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(bottom: 2, right: 10, top: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        height: 40,
                        width: 40,
                        child: Icon(Icons.my_location,
                            color:
                                Theme.of(context).accentColor.withOpacity(1)),
                      ),
                    ),
                    onTap: () {
                      _con.goCurrentLocation(mapController);
                    },
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2, right: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        height: 40,
                        width: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: SvgPicture.asset(
                            qrcodeimg,
                            color: Theme.of(context).accentColor.withOpacity(1),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {

                      _con.scan();
                    },
                  ),
                  InkWell(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(bottom: 2, right: 10, top: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        height: 40,
                        width: 40,
                        child: Stack(
                          children: <Widget>[
                            _con.locationtypelist.length !=
                                        _con.selecteditem.length &&
                                    _con.selecteditem.length != 0
                                ? Padding(
                                    padding:
                                        const EdgeInsets.only(left: 3, top: 3),
                                    child: Icon(Icons.fiber_manual_record,
                                        color: Theme.of(context).accentColor,
                                        size: 8),
                                  )
                                : SizedBox(
                                    height: 0,
                                  ),
                            Center(
                              child: Icon(Icons.filter_list,
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(1)),
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => FilterScreen(_con),
                      );
                    },
                  ),
                ],
              ),
            ),

            _con.hidelist
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              S.of(context).hide,
                              style: Theme.of(context).textTheme.body2,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _con.hidelist = false;
                            });
                          },
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/Details',
                                arguments: RouteArgument(
                                  id: _con.restaurant.id,
                                  heroTag: "main_map_restaturant",
                                ));
                          },
                          child: CardWidget(
                              restaurant: _con.restaurant,
                              heroTag: "main_map_restaturant"),
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    height: 0,
                  ),

            _con.cameraPosition == null
                ? SizedBox(
                    height: 0,
                    width: 0,
                  )
                : Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      child: Container(
                          height: 70,
                          width: 70,
                          child: Stack(
                            children: <Widget>[
                              FlareActor("assets/animations/Location.flr",
                                  alignment: Alignment.center,
                                  fit: BoxFit.contain,
                                  animation: "Untitled"),
                              Center(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 30, left: 10),
                                child: Image.asset(
                                  markerimg,
                                  height: 40,
                                  width: 40,
                                ),
                              )),
                            ],
                          )),
                    ),
                  ),
          ],
        ),
      ),
    );
  }


}
