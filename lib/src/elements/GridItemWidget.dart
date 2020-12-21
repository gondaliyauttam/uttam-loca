import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loca_bird/config/app_images.dart';
import 'package:loca_bird/src/helpers/helper.dart';
import 'package:loca_bird/src/models/restaurantdata.dart';
import 'package:loca_bird/src/models/route_argument.dart';

class GridItemWidget extends StatelessWidget {
  Restaurant restaurant;
  String heroTag;

  GridItemWidget({Key key, this.restaurant, this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        Navigator.of(context).pushNamed('/Details',
            arguments: RouteArgument(id: restaurant.id, heroTag: heroTag));
      },
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).focusColor.withOpacity(0.05),
                  offset: Offset(0, 5),
                  blurRadius: 5)
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Hero(
                  tag: heroTag + restaurant.id,
                  child: CachedNetworkImage(
                    imageUrl: restaurant.image.thumb,
                    height: 82,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        Center(
                          child: Container(
                              width: 80,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(
                                  appicon,
                                ),
                              )),
                        ),
                  ) /*Image.network(
                  restaurant.image.thumb,
                  fit: BoxFit.cover,
                  height: 82,
                  width: double.infinity,
                ),*/
                  ),
            ),
            SizedBox(height: 5),
            Text(
              restaurant.name,
              style: Theme.of(context).textTheme.body1,
              softWrap: false,
              overflow: TextOverflow.fade,
            ),
            SizedBox(height: 2),
            Row(
              children: Helper.getStarsList(double.parse(restaurant.rate),Theme.of(context).accentColor),
            ),
          ],
        ),
      ),
    );
  }
}
