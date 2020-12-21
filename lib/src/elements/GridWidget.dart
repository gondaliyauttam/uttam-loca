import 'package:flutter/material.dart';
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/elements/GridItemWidget.dart';
import 'package:loca_bird/src/elements/NoDataView.dart';
import 'package:loca_bird/src/models/restaurantdata.dart';

class GridWidget extends StatelessWidget {
  List<Restaurant> restaurantsList;
  String heroTag;

  GridWidget({Key key, this.restaurantsList, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return restaurantsList.isNotEmpty
        ? GridView.count(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.symmetric(vertical: 10),
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 2
                    : 4,
            children: List.generate(restaurantsList.length, (index) {
              return GridItemWidget(
                  restaurant: restaurantsList.elementAt(index),
                  heroTag: heroTag);
            }),
          )
        : SizedBox(
            height: 50,
            child: NoDataView(S.of(context).no_location_found),
          );
  }
}
