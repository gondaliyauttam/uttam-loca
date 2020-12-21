import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';
import 'package:loca_bird/config/app_images.dart';
import 'package:loca_bird/src/helpers/helper.dart';
import 'package:loca_bird/src/models/restaurantdata.dart';
import 'package:loca_bird/src/models/route_argument.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:loca_bird/src/repository/settings_repository.dart'
    as sett;

class CardWidget extends StatelessWidget {
  Restaurant restaurant;
  String heroTag;

  CardWidget({Key key, this.restaurant, this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 292,
      margin: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).focusColor.withOpacity(0.1),
              blurRadius: 15,
              offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Image of the card
          Hero(
            tag: this.heroTag + restaurant.id,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    restaurant.image.url,
                  ),
                  /*NetworkImage(restaurant.image.url),*/
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        restaurant.name,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.subhead,
                      ),
                      Text(
                        Helper.skipHtml(restaurant.description),
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: Helper.getStarsList(
                            double.parse(restaurant.rate),
                            Theme.of(context).accentColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: 42,
                        height: 42,
                        child: InkWell(
                          onTap: () {
                            print('Go to map');
                            openMap();
                            /* Navigator.of(context).pushNamed('/Map',
                                arguments:
                                    new RouteArgument(param: restaurant));*/
                          },
                          child: SvgPicture.asset(directionimg,
                              color: Theme.of(context).accentColor),
                        ),
                      ),
                      /* FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          print('Go to map');
                          Navigator.of(context).pushNamed('/Map',
                              arguments: new RouteArgument(param: restaurant));
                        },
                        child:   SizedBox(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(directionimg,
                              color: Theme.of(context).scaffoldBackgroundColor),
                        ),*/
                      /*Icon(Icons.directions,
                            color: Theme.of(context).primaryColor),*/
                      /*
                        color: Theme.of(context).accentColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),*/
                      Text(
                        Helper.getDistance(restaurant.distance),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> openMap() async {
    LocationData currentLocation = await sett.getCurrentLocation();
    if (currentLocation != null) {
      //  String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${currentRestaurant.latitude},${currentRestaurant.longitude}';
      String origin =
          "${currentLocation.latitude},${currentLocation.longitude}"; // lat,long like 123.34,68.56
      String destination = "${restaurant.latitude},${restaurant.longitude}";
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
  }
}
