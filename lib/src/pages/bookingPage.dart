import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/controllers/order_controller.dart';
import 'package:loca_bird/src/elements/BlockButtonWidget.dart';
import 'package:loca_bird/src/elements/DrawerWidget.dart';
import 'package:loca_bird/src/models/route_argument.dart';
import 'package:loca_bird/src/pages/my_affirmations.dart';
import 'package:loca_bird/src/pages/my_booking.dart';
import 'package:loca_bird/src/repository/user_repository.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends StateMVC<BookingPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController scrollController = ScrollController();
  OrderController _con;

  _BookingPageState() : super(OrderController()) {
    _con = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Theme.of(context).accentColor),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).my_booking,
          style: Theme.of(context)
              .textTheme
              .title
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: currentUser.apiToken == null
          ? Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      S.of(context).please_login_to_show_your_bookings_and_affirmations,
                      style: Theme.of(context).textTheme.body2,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    BlockButtonWidget(
                      text: Text(
                        S.of(context).login,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      color: Theme.of(context).accentColor.withOpacity(0.9),
                      onPressed: () {
                        // Navigator.of(context).pushNamed('/Login',arguments: new RouteArgument(param: false));
                        _con.goToSecondScreen();
                      },
                    ),
                  ],
                ),
              ),
            )
          : Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.00),
                    child: Material(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: TabBar(
                          controller: _tabController,
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(S.of(context).affirmation),
                              ),
                            ),
                            Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(S.of(context).my_booking),
                              ),
                            ),
                          ]),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        MyAffirmationWidget(_con),
                        MyBookingWidget(_con),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
