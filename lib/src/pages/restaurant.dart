import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:loca_bird/generated/i18n.dart';

import 'package:loca_bird/src/controllers/main_map_controller.dart';

import 'package:loca_bird/src/elements/CircularLoadingWidget.dart';
import 'package:loca_bird/src/elements/DrawerWidget.dart';
import 'package:loca_bird/src/elements/GoogleSearchWidget.dart';
import 'package:loca_bird/src/elements/NoDataView.dart';
import 'package:loca_bird/src/elements/RestaurantCardWidget.dart';
import 'package:loca_bird/src/elements/Filter_screen.dart';
import 'package:loca_bird/src/models/route_argument.dart';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "AIzaSyCvokfbJ1kh66gi8qOPlPUREomqmKeDSoo";

// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

// ignore: must_be_immutable
class RestaurantWidget extends StatefulWidget {
  NewMapController con;

  RestaurantWidget({Key key, this.con}) : super(key: key);

  @override
  _RestaurantWidgetState createState() => _RestaurantWidgetState();
}

class _RestaurantWidgetState extends StateMVC<RestaurantWidget> {
  NewMapController _con;

  @override
  void initState() {
    // TODO: implement initState
    _con = widget.con;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        drawer: DrawerWidget(),
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Theme.of(context).accentColor),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Locations",
            style: Theme.of(context)
                .textTheme
                .title
                .merge(TextStyle(letterSpacing: 1.3)),
          ),
          actions: <Widget>[
            /*InkWell(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2, right: 10, top: 5),
                child: Container(
                  height: 40,
                  width: 40,
                  child: Icon(Icons.search,
                      color: Theme.of(context).accentColor.withOpacity(1)),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomSearchScaffold()),
                );
              },
            ),*/
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2, right: 10, top: 5),
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
                              padding: const EdgeInsets.only(left: 5, top: 8),
                              child: Icon(Icons.fiber_manual_record,
                                  color: Theme.of(context).accentColor,
                                  size: 8),
                            )
                          : SizedBox(
                              height: 0,
                            ),
                      Center(
                        child: Icon(Icons.filter_list,
                            color:
                                Theme.of(context).accentColor.withOpacity(1)),
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
        body: RefreshIndicator(
            onRefresh: _con.refreshrestaurant,
            child: _con.loaded
                ? CircularLoadingWidget(
                    height: 500,
                  )
                : _con.nearRestaurants.isEmpty
                    ? Center(child: NoDataView(S.of(context).no_location_found))
                    : Container(
                        color: Theme.of(context).focusColor.withOpacity(0.1),
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                          reverse: false,
                          scrollDirection: Axis.vertical,
                          itemCount: _con.nearRestaurants.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed('/Details',
                                    arguments: RouteArgument(
                                      id: _con.nearRestaurants
                                          .elementAt(index)
                                          .id,
                                      heroTag: "home_top_restaurants",
                                    ));
                              },
                              child: RestaurantCardView(
                                  restaurant:
                                      _con.nearRestaurants.elementAt(index),
                                  heroTag: "home_top_restaurants"),
                            );
                          },
                        ),
                      )));
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      mode: Mode.overlay,
      language: "en",
      components: [Component(Component.country, "fr")],
    );

    displayPrediction(p);
  }
}

Future<Null> displayPrediction(Prediction p) async {
  if (p != null) {
    // get detail (lat/lng)
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;

    BotToast.showText(text: "${p.description} - $lat/$lng");
  }
}
