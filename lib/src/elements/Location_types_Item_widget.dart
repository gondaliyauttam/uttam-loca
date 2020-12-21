import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loca_bird/src/models/category.dart';
import 'package:loca_bird/src/models/location_type.dart';
import 'package:loca_bird/src/models/route_argument.dart';

// ignore: must_be_immutable
class LocationTypeItemWidget extends StatelessWidget {
  double marginLeft;
  LocationType locationType;
  String heroTag;

  LocationTypeItemWidget(
      {Key key, this.marginLeft, this.locationType, this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Hero(
          tag: heroTag + locationType.id.toString(),
          child: Container(
            margin: EdgeInsets.only(left: this.marginLeft, right: 20),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Theme.of(context).hintColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SvgPicture.network(
                locationType.iconUrl,
                height: 30,
                width: 30,
                color: Theme.of(context).accentColor,
              ),
              /* child: SvgPicture.network(
                  category.image,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),*/
            ),
          ),
        ),
        SizedBox(height: 5),
        Container(
          margin: EdgeInsets.only(left: this.marginLeft, right: 20),
          child: Text(
            locationType.name,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.body1,
          ),
        ),
      ],
    );
  }
}
