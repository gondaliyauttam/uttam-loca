import 'package:flutter/material.dart';
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/elements/Location_types_Item_widget.dart';
import 'package:loca_bird/src/elements/CircularLoadingWidget.dart';
import 'package:loca_bird/src/elements/NoDataView.dart';
import 'package:loca_bird/src/models/location_type.dart';
import 'package:loca_bird/src/models/route_argument.dart';

class LocationTypeWidget extends StatelessWidget {
  List<LocationType> locationtypes;
  String heroTag;

  LocationTypeWidget({Key key, this.heroTag, this.locationtypes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.locationtypes.isEmpty
        ? CircularLoadingWidget(height: 150)
        : locationtypes.isNotEmpty
            ? Container(
                height: 150,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                  itemCount: this.locationtypes.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    double _marginLeft = 0;
                    (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            '/LocationTypeRestaurantList',
                            arguments: RouteArgument(
                                id: locationtypes
                                    .elementAt(index)
                                    .id
                                    .toString(),
                                heroTag: heroTag));
                      },
                      child: LocationTypeItemWidget(
                        marginLeft: _marginLeft,
                        locationType: this.locationtypes.elementAt(index),
                        heroTag: heroTag,
                      ),
                    );
                  },
                ))
            : SizedBox(
                height: 50,
                child: NoDataView(S.of(context).no_location_found),
              );
  }
}
