import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/elements/ShareBookingImage.dart';
import 'package:loca_bird/src/models/booking.dart';

import 'package:loca_bird/src/repository/user_repository.dart';


class BookingTicketWidget extends StatelessWidget {
  final Booking data;

  const BookingTicketWidget({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: data.affirmation != null
                    ? CachedNetworkImage(
                        width: 100,
                        imageUrl: data.affirmation.entryQr,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    /*Image.network(
                        data.affirmation.entryQr,
                        height: 150,
                        width: 150,
                      )*/
                    : SizedBox(
                        height: 0,
                      ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              currentUser.name,
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShareBookingImage(data: data)),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.share,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        S.of(context).total_entry +
                            " : " +
                            "${data.personCount}",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          S.of(context).note__please_show_this_code_while_entering,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              color: Colors.red[900],
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              /* SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SvgPicture.asset(
                    l_cutsvg,
                    height: 50,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),

                  Expanded(child: MySeparator(color: Colors.grey)),

                  new RotatedBox(
                    quarterTurns: 2,
                    child: SvgPicture.asset(
                      l_cutsvg,
                      height: 50,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.home,
                          size: 15.0,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10.00,
                        ),
                        Expanded(
                          child: Text(
                            data.restaurant.name,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.00,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.00,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.calendar_today,
                          size: 15.0,
                          color: Colors.black,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.00),
                          child: Text(
                            data.date,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.00,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.access_time,
                          size: 15.0,
                          color: Colors.black,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.00),
                          child: Text(
                            data.time,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.00,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.person,
                              size: 15.0,
                              color: Colors.black,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.00),
                              child: Text(
                                "10" + " " + S.of(context).member,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "\€" +
                              data.amount.toString() +
                              "/" +
                              S.of(context).member,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.00,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        child: RichText(
                          text: TextSpan(
                              text: S.of(context).total_amount,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: " \€" + data.amount.toString(),
                                    style: TextStyle(
                                        fontSize: 20.00,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black))
                              ]),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.00,
                    ),
                  ],
                ),
              )),*/
            ],
          ),
        ),
      ),
    );
  }
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 8.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
