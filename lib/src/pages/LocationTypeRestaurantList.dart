import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/controllers/home_controller.dart';
import 'package:loca_bird/src/controllers/main_map_controller.dart';
import 'package:loca_bird/src/elements/CircularLoadingWidget.dart';
import 'package:loca_bird/src/elements/NoDataView.dart';
import 'package:loca_bird/src/elements/RestaurantCardWidget.dart';
import 'package:loca_bird/src/models/route_argument.dart';

class LocationTypeRestaurantList extends StatefulWidget {
  RouteArgument routeArgument;

  LocationTypeRestaurantList({this.routeArgument});

  @override
  _LocationTypeRestaurantListState createState() =>
      _LocationTypeRestaurantListState();
}

class _LocationTypeRestaurantListState
    extends StateMVC<LocationTypeRestaurantList> {
  HomeController _con;

  _LocationTypeRestaurantListState() : super(HomeController()) {
    _con = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.routeArgument.id);
    print(widget.routeArgument.heroTag);
    _con.getLocationTypeRestaurant(widget.routeArgument.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
      ),
      body: _con.loaded
          ? CircularLoadingWidget(
              height: 500,
            )
          : _con.locationRestaurants.isNotEmpty
              ? Container(
                  color: Theme.of(context).focusColor.withOpacity(0.1),
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    reverse: false,
                    scrollDirection: Axis.vertical,
                    itemCount: _con.locationRestaurants.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/Details',
                              arguments: RouteArgument(
                                id: _con.locationRestaurants
                                    .elementAt(index)
                                    .id,
                                heroTag: widget.routeArgument.heroTag,
                              ));
                        },
                        child: RestaurantCardView(
                            restaurant:
                                _con.locationRestaurants.elementAt(index),
                            heroTag: widget.routeArgument.heroTag),
                      );
                    },
                  ),
                )
              : Center(child: NoDataView(S.of(context).no_location_found)),
    );
  }
}
