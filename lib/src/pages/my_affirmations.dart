import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/controllers/order_controller.dart';
import 'package:loca_bird/src/elements/AffirmationCardView.dart';
import 'package:loca_bird/src/elements/CircularLoadingWidget.dart';
import 'package:loca_bird/src/elements/NoDataView.dart';

class MyAffirmationWidget extends StatefulWidget {
  OrderController con;

  MyAffirmationWidget(this.con);

  @override
  _MyAffirmationWidgetState createState() => _MyAffirmationWidgetState();
}

class _MyAffirmationWidgetState extends StateMVC<MyAffirmationWidget> {
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
          if (_con.lastpageaffirm >= _con.nextPageaffirm) {
            print("last page" + _con.lastpageaffirm.toString());
            print("next page" + _con.nextPageaffirm.toString());
            _con.loadMoreAffirmation();
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
              _con.isloadingaffirmation
                  ? CircularLoadingWidget(height: 500)
                  : _con.affirmations.isEmpty
                      ? Center(child: NoDataView(S.of(context).no_affirmation))
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: _con.affirmations.length,
                          itemBuilder: (context, index) {
                            return AffirmationExpandableListView(
                              affirmation: _con.affirmations[index],
                              heroTag: "affirmation_view",
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
