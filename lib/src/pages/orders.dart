import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/controllers/order_controller.dart';
import 'package:loca_bird/src/elements/CircularLoadingWidget.dart';
import 'package:loca_bird/src/elements/DrawerWidget.dart';
import 'package:loca_bird/src/elements/OrderItemWidget.dart';
import 'package:loca_bird/src/elements/SearchBarWidget.dart';
import 'package:loca_bird/src/elements/ShoppingCartButtonWidget.dart';
import 'package:loca_bird/src/models/route_argument.dart';
import 'package:loca_bird/src/repository/user_repository.dart';

class OrdersWidget extends StatefulWidget {
  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends StateMVC<OrdersWidget> {
  OrderController _con;

  _OrdersWidgetState() : super(OrderController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
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
        /*actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],*/
      ),
      key: _con.scaffoldKey,
      body: RefreshIndicator(
        onRefresh: _con.refreshOrders,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SearchBarWidget(),
              ),
              SizedBox(height: 10),
              _con.orders.isEmpty
                  ? CircularLoadingWidget(height: 500)
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _con.orders.length,
                      itemBuilder: (context, index) {
                        return Theme(
                          data: theme,
                          child: ExpansionTile(
                            initiallyExpanded: true,
                            title: Row(
                              children: <Widget>[
                                Expanded(child: Text('${S.of(context).order_id}: #${_con.orders.elementAt(index).id}')),
                                Text(
                                  '${_con.orders.elementAt(index).orderStatus.status}',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                            children: List.generate(_con.orders.elementAt(index).foodOrders.length, (indexFood) {
                              return OrderItemWidget(
                                  heroTag: 'my_orders',
                                  order: _con.orders.elementAt(index),
                                  foodOrder: _con.orders.elementAt(index).foodOrders.elementAt(indexFood));
                            }),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
