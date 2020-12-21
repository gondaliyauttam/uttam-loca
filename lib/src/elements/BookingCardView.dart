import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loca_bird/config/app_images.dart';
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/elements/BookingTicketWidget.dart';
import 'package:loca_bird/src/models/booking.dart';
import 'package:loca_bird/src/controllers/restaurant_controller.dart'
    as res;

class BookingExpandableListView extends StatefulWidget {
  String heroTag;
  Booking booking;

  BookingExpandableListView({
    Key key,
    this.booking,
    this.heroTag,
  }) : super(key: key);

  @override
  _BookingExpandableListViewState createState() =>
      new _BookingExpandableListViewState();
}

class _BookingExpandableListViewState extends State<BookingExpandableListView> {
  bool expandFlag = false;

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 1.0),
      child: new Column(
        children: <Widget>[
          InkWell(
            child: new Padding(
              padding: const EdgeInsets.all(5.00),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Hero(
                        tag: widget.heroTag + widget.booking.id.toString(),
                        child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                            child: CachedNetworkImage(
                              width: 100,
                              height: 120,
                              imageUrl: widget.booking.restaurant.image.url,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                   Container(
                                      width: 100,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Image.asset(
                                          appicon,
                                        ),
                                      )),
                              fadeOutDuration: const Duration(seconds: 1),
                              fadeInDuration: const Duration(seconds: 2),
                            )),
                      ),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 5, right: 5, bottom: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    widget.booking.restaurant.name,
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
                                Text(
                                  "\€" + widget.booking.amount.toString(),
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.9),
                                      fontSize: 18),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.calendar_today,
                                  size: 15.0,
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.9),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.00),
                                  child: Text(
                                    widget.booking.date,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: Theme.of(context).textTheme.body2,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.access_time,
                                        size: 15.0,
                                        color: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.9),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.00),
                                          child: Text(
                                            getFromtime(widget.booking.time) +
                                                "-" +
                                                gettotime(
                                                        widget.booking.time,
                                                        widget
                                                            .booking.slotLength)
                                                    .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .body2,
                                          ))
                                    ],
                                  ),
                                ),
                                Text(
                                  widget.booking.priceAmount.toString() +
                                      "/" +
                                      getPriceType(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.body2,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            onTap: () {
              setState(() {
                expandFlag = !expandFlag;
              });
            },
          ),
          new ExpandableContainer(
              expanded: expandFlag,
              child: BookingTicketWidget(
                data: widget.booking,
              ))
        ],
      ),
    );
  }

  String getFromtime(selectedTime) {
    DateTime tempDate = new DateFormat("HH:mm").parse(selectedTime);
    String date = DateFormat("HH:mm").format(tempDate);
    String toTime = (date).toString();
    return toTime;
  }

  String gettotime(selectedTime, slotLength) {
    DateTime tempDate = new DateFormat("HH:mm").parse(selectedTime);
    var time = tempDate.add(Duration(hours: slotLength));
    String date = DateFormat("HH:mm").format(time);
    String toTime = (date).toString();
    return toTime;
  }

  String getPriceType() {
    if (widget.booking.priceType == "per_slot") {
      return S.of(context).slot;
    }
    return S.of(context).member;
  }
}

class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandableContainer({
    @required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 200.0,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return new AnimatedContainer(
      duration: new Duration(milliseconds: 0),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child: new Container(
        child: child,
      ),
    );
  }
}
