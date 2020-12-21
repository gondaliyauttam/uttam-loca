import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/controllers/order_controller.dart';
import 'package:loca_bird/src/elements/BookingCardView.dart';
import 'package:loca_bird/src/elements/CircularLoadingWidget.dart';
import 'package:loca_bird/src/elements/NoDataView.dart';

class MyBookingWidget extends StatefulWidget {
  OrderController con;

  MyBookingWidget(this.con);

  @override
  _MyBookingWidgetState createState() => _MyBookingWidgetState();
}

class _MyBookingWidgetState extends StateMVC<MyBookingWidget> {
  OrderController _con;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con = widget.con;

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!_con.moreLoading) {
          if (_con.lastpagebooking >= _con.nextPagebooking) {
            print("last page" + _con.lastpagebooking.toString());
            print("next page" + _con.nextPagebooking.toString());
            _con.loadMoreBooking();
          }
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _con.refreshOrders,
        child: SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: 10),
              _con.isloadingbooking
                  ? CircularLoadingWidget(height: 500)
                  : _con.bookings.isEmpty
                      ? Center(child: NoDataView(S.of(context).no_booking))
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: _con.bookings.length,
                          itemBuilder: (context, index) {
                            return BookingExpandableListView(
                              booking: _con.bookings[index],
                              heroTag: "booking_view",
                            );
                          },
                        ),
              Container(
                height: _con.moreLoading ? 50.0 : 0,
                color: Colors.transparent,
                child: Center(
                  child: new CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
