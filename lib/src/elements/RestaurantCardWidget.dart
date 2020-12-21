import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loca_bird/config/app_color.dart';
import 'package:loca_bird/config/app_images.dart';
import 'package:loca_bird/src/helpers/helper.dart';
import 'package:loca_bird/src/models/restaurantdata.dart';
import 'package:loca_bird/src/models/route_argument.dart';

class RestaurantCardView extends StatelessWidget {
  String heroTag;
  Restaurant restaurant;

  RestaurantCardView({Key key, this.restaurant, this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.of(context).pushNamed('/Details',
            arguments: RouteArgument(
              id: restaurant.id,
              heroTag: heroTag,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.all(5.00),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            /*  boxShadow: [
              BoxShadow(
                  color: Theme.of(context).focusColor.withOpacity(0.1),
                  blurRadius: 15,
                  offset: Offset(0, 5)),
            ],*/
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Hero(
                  tag: heroTag + restaurant.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    child: CachedNetworkImage(
                      width: 100,
                      imageUrl: restaurant.image.thumb,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Container(
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              appicon,
                            ),
                          )),
                      fadeOutDuration: const Duration(seconds: 1),
                      fadeInDuration: const Duration(seconds: 3),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, right: 5, bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              restaurant.name,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.9),
                                  fontSize: 18),
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            width: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5, left: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  restaurant.counterColor == "green"
                                      ? new Container(
                                          width: 10,
                                          height: 10,
                                          decoration: new BoxDecoration(
                                            color: green_active_color,
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      : new Container(
                                          width: 10,
                                          height: 10,
                                          decoration: new BoxDecoration(
                                            color: green_dark_color,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                  restaurant.counterColor == "yellow"
                                      ? new Container(
                                          width: 10,
                                          height: 10,
                                          decoration: new BoxDecoration(
                                            color: yellow_active_color,
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      : new Container(
                                          width: 10,
                                          height: 10,
                                          decoration: new BoxDecoration(
                                            color: yellow_dark_color,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                  restaurant.counterColor == "red"
                                      ? new Container(
                                          width: 10,
                                          height: 10,
                                          decoration: new BoxDecoration(
                                            color: red_active_color,
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      : new Container(
                                          width: 10,
                                          height: 10,
                                          decoration: new BoxDecoration(
                                            color: red_dark_color,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Row(),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 3, top: 3),
                            child: Icon(Icons.arrow_forward_ios,
                                color: Theme.of(context).accentColor),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            Helper.getDistance(restaurant.distance),
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: restaurant.locationType != []
                                ? Container(
                                    height: 25,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: ListView.builder(
                                        reverse: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            restaurant.locationType.length,
                                        itemBuilder: (context, index) {
                                          return SvgPicture.network(
                                            restaurant
                                                .locationType[index].iconUrl,
                                            color:
                                                Theme.of(context).accentColor,
                                            height: 25,
                                            width: 25,
                                          );
                                        },
                                      ),
                                    ))
                                : SvgPicture.asset(
                                    defaultsvg,
                                    color: Theme.of(context).accentColor,
                                    height: 25,
                                    width: 25,
                                  ),
                          ),
                        ],
                      ),
                      /*  Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: Helper.getStarsList(
                                  double.parse(restaurant.rate),
                                  Theme.of(context).accentColor),
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            width: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5, left: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  restaurant.counterColor == "green"
                                      ? new Container(
                                          width: 10,
                                          height: 10,
                                          decoration: new BoxDecoration(
                                            color: green_active_color,
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      : new Container(
                                          width: 10,
                                          height: 10,
                                          decoration: new BoxDecoration(
                                            color: green_dark_color,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                  restaurant.counterColor == "yellow"
                                      ? new Container(
                                          width: 10,
                                          height: 10,
                                          decoration: new BoxDecoration(
                                            color: yellow_active_color,
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      : new Container(
                                          width: 10,
                                          height: 10,
                                          decoration: new BoxDecoration(
                                            color: yellow_dark_color,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                  restaurant.counterColor == "red"
                                      ? new Container(
                                          width: 10,
                                          height: 10,
                                          decoration: new BoxDecoration(
                                            color: red_active_color,
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      : new Container(
                                          width: 10,
                                          height: 10,
                                          decoration: new BoxDecoration(
                                            color: red_dark_color,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              restaurant.name,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.9),
                                  fontSize: 18),
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 3, top: 3),
                            child: Icon(Icons.arrow_forward_ios,
                                color: Theme.of(context).accentColor),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            Helper.getDistance(restaurant.distance),
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: restaurant.locationType != []
                                ? Container(
                                    height: 25,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: ListView.builder(
                                        reverse: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            restaurant.locationType.length,
                                        itemBuilder: (context, index) {
                                          return SvgPicture.network(
                                            restaurant
                                                .locationType[index].iconUrl,
                                            color:
                                                Theme.of(context).accentColor,
                                            height: 25,
                                            width: 25,
                                          );
                                        },
                                      ),
                                    ))
                                : SvgPicture.asset(
                                    defaultsvg,
                                    color: Theme.of(context).accentColor,
                                    height: 25,
                                    width: 25,
                                  ),
                          ),
                        ],
                      ),*/
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
