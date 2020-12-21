import 'package:flutter/material.dart';
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/elements/CircularLoadingWidget.dart';
import 'package:loca_bird/src/elements/NoDataView.dart';
import 'package:loca_bird/src/models/restaurantdata.dart';
import 'package:loca_bird/src/models/route_argument.dart';

import 'CardWidget.dart';

class CardsCarouselWidget extends StatefulWidget {
  List<Restaurant> restaurantsList;
  String heroTag;

  CardsCarouselWidget({Key key, this.restaurantsList, this.heroTag})
      : super(key: key);

  @override
  _CardsCarouselWidgetState createState() => _CardsCarouselWidgetState();
}

class _CardsCarouselWidgetState extends State<CardsCarouselWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.restaurantsList.isEmpty
        ? CircularLoadingWidget(height: 288)
        : widget.restaurantsList.isNotEmpty
            ? Container(
                height: 288,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.restaurantsList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/Details',
                            arguments: RouteArgument(
                              id: widget.restaurantsList.elementAt(index).id,
                              heroTag: widget.heroTag,
                            ));
                      },
                      child: CardWidget(
                          restaurant: widget.restaurantsList.elementAt(index),
                          heroTag: widget.heroTag),
                    );
                  },
                ),
              )
            : SizedBox(
                height: 50,
                child: NoDataView(S.of(context).no_location_found),
              );
  }
}
