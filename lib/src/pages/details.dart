import 'dart:async';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:loca_bird/config/app_images.dart';
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/controllers/restaurant_controller.dart';
import 'package:loca_bird/src/elements/BlockButtonWidget.dart';
import 'package:loca_bird/src/elements/CircularLoadingWidget.dart';
import 'package:loca_bird/src/elements/GalleryCarouselWidget.dart';
import 'package:loca_bird/src/elements/HoursView.dart';
import 'package:loca_bird/src/helpers/helper.dart';
import 'package:loca_bird/src/models/route_argument.dart';
import 'package:loca_bird/src/repository/user_repository.dart';
import 'package:loca_bird/widgets/date_view.dart';
import 'package:loca_bird/widgets/mutlichip_timeslots.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:loca_bird/src/models/question.dart';

class DetailsWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  DetailsWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _DetailsWidgetState createState() {
    return _DetailsWidgetState();
  }
}

class _DetailsWidgetState extends StateMVC<DetailsWidget> {
  RestaurantController _con;
  ScrollController scrollController = new ScrollController();
  DateTime _selectedDate = DateTime.now();
  int selectedSlotIndex = 0;

  _DetailsWidgetState() : super(RestaurantController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForRestaurant(id: widget.routeArgument.id);
    _con.listenForGalleries(widget.routeArgument.id);
    _con.listenForRestaurantReviews(id: widget.routeArgument.id);
    _con.listenForFeaturedFoods(widget.routeArgument.id);
    _con.listenforTimeSlots(widget.routeArgument.id);
    /* Timer(Duration(seconds: 2), () {
      setState(() {
        showdateandtime = true;
      });
    });*/

    DateTime tempDate = new DateFormat("hh:mm").parse("10:30");
    var berlinWallAdd10 = tempDate.add(Duration(hours: 2));
    print(berlinWallAdd10.hour);
    print(berlinWallAdd10.minute);

    super.initState();
  }

  Widget information() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            leading:
                SvgPicture.asset(infoimg, color: Theme.of(context).accentColor),
            title: Text(
              S.of(context).information,
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          margin: const EdgeInsets.symmetric(vertical: 5),
          color: Theme.of(context).primaryColor,
          child: Helper.applyHtml(context, _con.restaurant.information),
        ),
      ],
    );
  }

  Widget address() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      margin: const EdgeInsets.symmetric(vertical: 5),
      color: Theme.of(context).primaryColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: 24,
            height: 24,
            child: SvgPicture.asset(locationimg,
                color: Theme.of(context).accentColor),
          ),
          Expanded(
            child: Text(
              _con.restaurant.address,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: Theme.of(context).textTheme.body2,
            ),
          ),
          SizedBox(width: 10),
          SizedBox(
            width: 42,
            height: 42,
            child: InkWell(
              onTap: () {
                _con.openMap();
                /*  Navigator.of(context).pushNamed('/Map',
                    arguments: new RouteArgument(param: _con.restaurant));*/
              },
              child: SvgPicture.asset(directionimg,
                  color: Theme.of(context).accentColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget telephone() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      margin: const EdgeInsets.symmetric(vertical: 5),
      color: Theme.of(context).primaryColor,
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _con.restaurant.phone != null
                    ? InkWell(
                        onTap: () {
                          if (Platform.isAndroid) {
                            launch("tel:${_con.restaurant.phone}");
                          } else {
                            launch("tel://${_con.restaurant.phone}");
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3, bottom: 3),
                          child: Text(
                            '${_con.restaurant.phone}',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.body2,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
                _con.restaurant.mobile != null
                    ? InkWell(
                        onTap: () {
                          if (Platform.isAndroid) {
                            launch("tel:${_con.restaurant.mobile}");
                          } else {
                            launch("tel://${_con.restaurant.mobile}");
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3, bottom: 3),
                          child: Text(
                            '${_con.restaurant.mobile}',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.body2,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
              ],
            ),
          ),
          SizedBox(width: 10),
          SizedBox(
            width: 42,
            height: 42,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                if (_con.restaurant.phone != null) {
                  if (Platform.isAndroid) {
                    launch("tel:${_con.restaurant.phone}");
                  } else {
                    launch("tel://${_con.restaurant.phone}");
                  }
                } else if (_con.restaurant.mobile != null) {
                  if (Platform.isAndroid) {
                    launch("tel:${_con.restaurant.mobile}");
                  } else {
                    launch("tel://${_con.restaurant.mobile}");
                  }
                }
              },
              child: Icon(
                Icons.call,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              color: Theme.of(context).accentColor.withOpacity(0.9),
              shape: StadiumBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget opencloseTime(context) {
    return Column(
      children: <Widget>[
        _con.timeslotslist[0].data != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.symmetric(vertical: 5),
                color: Theme.of(context).primaryColor,
                child: ExpansionTile(
                  title: _con.timeslotslist[0].data.dayOff
                      ? Row(
                          children: <Widget>[
                            Text(
                              S.of(context).hours +
                                  " : " +
                                  S.of(context).today_close,
                              style: Theme.of(context).textTheme.body2,
                            ),
                          ],
                        )
                      : Row(
                          children: <Widget>[
                            Text(
                              S.of(context).hours +
                                  _con.getopenclose(
                                      _con.timeslotslist[0].data.startTime,
                                      _con.timeslotslist[0].data.endTime) +
                                  " ",
                              style: Theme.of(context).textTheme.body2,
                            ),
                            Text(
                              DateFormat("HH:mm").format(DateFormat("hh:mm")
                                  .parse(_con.timeslotslist[0].data.startTime)),
                              style: Theme.of(context).textTheme.body2,
                            ),
                            Text(" - ",
                                style: Theme.of(context).textTheme.body2),
                            Text(
                              DateFormat("HH:mm").format(DateFormat("hh:mm")
                                  .parse(_con.timeslotslist[0].data.endTime)),
                              style: Theme.of(context).textTheme.body2,
                            ),
                          ],
                        ),
                  children:
                      List.generate(_con.timeslotslist.length, (indexFood) {
                    return HoursView(_con.timeslotslist[indexFood]);
                  }),
                ),
              )
            : SizedBox(
                height: 0,
              ),
      ],
    );
  }

  Widget notifyAvailable(context) {
    return Column(
      children: <Widget>[
        _con.restaurant.counterColor == "red"
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                margin: const EdgeInsets.symmetric(vertical: 5),
                color: Theme.of(context).primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      S.of(context).notify_me_when_available,
                      style: Theme.of(context).textTheme.body1,
                    ),
                    InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.notifications_active,
                          color: Theme.of(context).accentColor,
                        )),
                  ],
                ),
              )
            : SizedBox(
                height: 0,
              ),
      ],
    );
  }

  Widget getVerticalDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 0.5,
        color: Theme.of(context).accentColor.withOpacity(0.9),
      ),
    );
  }

  Widget totalperson() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            title: Text(
              S.of(context).total_person,
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                  child: Icon(
                    Icons.remove,
                    size: 25.0,
                    color: Theme.of(context).accentColor.withOpacity(0.9),
                  ),
                  onTap: _con.previousImage,
                ),
                Container(
                  width: 100,
                  child: Center(
                      child: Text(
                    _con.person[_con.personIndex],
                    style: TextStyle(
                        color: Theme.of(context).accentColor.withOpacity(0.9),
                        fontSize: 30),
                  )),
                ),
                InkWell(
                  child: Icon(
                    Icons.add,
                    size: 25.0,
                    color: Theme.of(context).accentColor.withOpacity(0.9),
                  ),
                  onTap: _con.nextImage,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  dateView(BuildContext context) {
    changedateformete(_selectedDate);
    return Container(
        height: 50.00,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: DatePickerTimeline(
            _con.timeslotslist,
            _selectedDate,
            _con.selecteddateIndex,
            onDateChange: (date) {
              setState(() {
                _selectedDate = date;
                changedateformete(date);
                _con.selectedtime = "";
                _con.showdetail = false;
                print(_con.selecteddate);
              });
            },
            onIndexChange: (index) {
              _con.selecteddateIndex = index;
            },
          ),
        ));
  }

  changedateformete(DateTime dateTime) {
    var formatter = new DateFormat('yyyy-MM-dd');
    _con.selecteddate = formatter.format(dateTime);
    _con.selecteddatename = new DateFormat('EEEE').format(dateTime);
  }

  buildTimeSlots() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _con.timeslotslist.length != null
          ? _con.timeslotslist[_con.selecteddateIndex].data != null
              ? _con.timeslotslist[_con.selecteddateIndex].data.slotInfo
                          .length !=
                      0
                  ? Column(
                      children: <Widget>[
                        MultiSelectChip(
                          _con.timeslotslist[_con.selecteddateIndex].data
                              .slotInfo,
                          onSelectionChanged: (selectedList) {
                            print(selectedList);
                            setState(() {
                              _con.selectedtime = selectedList;
                              _con.gettotime(selectedList);
                            });
                          },
                          onSelectedIndex: (index) {
                            setState(() {
                              selectedSlotIndex = index;
                              print(selectedSlotIndex);
                            });
                          },
                        ),
                        getVerticalDivider(),
                        totalperson(),
                        getVerticalDivider(),
                        SizedBox(
                          height: 50,
                        ),
                        _con.selectedtime != null
                            ? Column(
                                children: <Widget>[
                                  Center(
                                    child: BlockButtonWidget(
                                      text: Text(
                                        S.of(context).reserve_now,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.9),
                                      onPressed: () {
                                        if (currentUser.apiToken == null) {
                                          Navigator.of(context).pushNamed(
                                              '/Login',
                                              arguments: new RouteArgument(
                                                  param: false));
                                        } else {
                                          setState(() {
                                            if (_con.selectedtime != "") {
                                              _con.showdetail = true;
                                              Timer(
                                                Duration(milliseconds: 100),
                                                () =>
                                                    scrollController.animateTo(
                                                        scrollController
                                                            .position
                                                            .maxScrollExtent,
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    500),
                                                        curve: Curves.easeOut),
                                              );
                                            } else {}
                                          });

                                          print("sucess");
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                ],
                              )
                            : BotToast.showText(
                                text: S.of(context).please_select_time),
                        _con.showdetail
                            ? bookingDetails()
                            : SizedBox(height: 0),
                      ],
                    )
                  : noslots(context)
              : noslots(context)
          : noslots(context),
    );
  }

  Widget bookingDetails() {
    return Column(
      children: <Widget>[
        getVerticalDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            title: Text(
              S.of(context).booking_details,
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ),
        Container(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 10.00,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.home,
                    size: 15.0,
                    color: Theme.of(context).accentColor.withOpacity(0.9),
                  ),
                  SizedBox(
                    width: 10.00,
                  ),
                  Expanded(
                    child: Text(
                      _con.restaurant.name,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.display2,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.00,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.calendar_today,
                    size: 15.0,
                    color: Theme.of(context).accentColor.withOpacity(0.9),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.00),
                    child: Text(
                      _con.selecteddate,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.body2,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15.00,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.access_time,
                    size: 15.0,
                    color: Theme.of(context).accentColor.withOpacity(0.9),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.00),
                    child: _con.selectedtime != ""
                        ? Text(
                            _con.selectedtime +
                                S.of(context).to +
                                _con.toTime.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.body2,
                          )
                        : Text(
                            "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.body2,
                          ),
                  )
                ],
              ),
              SizedBox(
                height: 15.00,
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
                        color: Theme.of(context).accentColor.withOpacity(0.9),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.00),
                        child: Text(
                          _con.person[_con.personIndex] +
                              " " +
                              S.of(context).member,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "\€" +
                        _con.timeslotslist[_con.selecteddateIndex].data.price
                            .toString() +
                        "/" +
                        _con.getPriceType(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.body2,
                  ),
                ],
              ),
              SizedBox(
                height: 10.00,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  child: RichText(
                    text: _con.getPriceType != "Slot"
                        ? TextSpan(
                            text: S.of(context).total_amount,
                            style: Theme.of(context).textTheme.body2,
                            children: <TextSpan>[
                                TextSpan(
                                    text:
                                        " \€" + _con.totalamounts().toString(),
                                    style: TextStyle(
                                        fontSize: 20.00,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.9)))
                              ])
                        : TextSpan(
                            text: S.of(context).total_amount,
                            style: Theme.of(context).textTheme.body2,
                            children: <TextSpan>[
                                TextSpan(
                                    text: " \€" +
                                        _con
                                            .timeslotslist[
                                                _con.selecteddateIndex]
                                            .data
                                            .price
                                            .toString(),
                                    style: TextStyle(
                                        fontSize: 20.00,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.9)))
                              ]),
                  ),
                ),
              ),
              SizedBox(
                height: 30.00,
              ),
            ],
          ),
        )),
        BlockButtonWidget(
          text: Text(
            S.of(context).confirm_booking,
            style: TextStyle(color: Colors.black),
          ),
          color: Theme.of(context).accentColor.withOpacity(0.9),
          onPressed: () {
            if (_con.selectedtime == "") {
              BotToast.showText(text: S.of(context).please_select_time);
            } else {
              ReqQuestion req = new ReqQuestion();
              req.slot = _con.selectedtime;
              req.date = _con.selecteddate;
              req.amount = _con.totalamounts().toString().toString();
              req.restaurantid = int.parse(widget.routeArgument.id);
              req.slotlength =
                  _con.timeslotslist[_con.selecteddateIndex].data.slotLength;
              req.personcount = int.parse(_con.person[_con.personIndex]);
              req.priceamount = _con
                  .timeslotslist[_con.selecteddateIndex].data.price
                  .toString();
              req.pricetype =
                  _con.timeslotslist[_con.selecteddateIndex].data.priceType;
              Navigator.of(context).pushNamed('/QuestionPage',
                  arguments: RouteArgument(
                      id: widget.routeArgument.id,
                      heroTag: "details",
                      param: req));
            }
          },
        ),
        SizedBox(
          height: 150,
        )
      ],
    );
  }

  Widget noslots(context) {
    return SizedBox(
      child: Text(
        S.of(context).no_slots_avilable,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: Theme.of(context).textTheme.body2,
      ),
    );
  }

  Widget ReserveationTime(context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            title: Text(
              S.of(context).reserve,
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ),
        _con.showdateandtime
            ? Column(
                children: <Widget>[
                  dateView(context),
                  _con.timeslotslist.length != null
                      ? buildTimeSlots()
                      : SizedBox(
                          height: 0,
                        ),
                ],
              )
            : CircularLoadingWidget(
                height: 20,
              ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
        body: RefreshIndicator(
          onRefresh: _con.refreshRestaurant,
          child: _con.restaurant == null
              ? CircularLoadingWidget(height: 500)
              : CustomScrollView(
                  controller: scrollController,
                  primary: false,
                  shrinkWrap: false,
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor:
                          Theme.of(context).accentColor.withOpacity(0.9),
                      expandedHeight: 300,
                      elevation: 0,
                      iconTheme:
                          IconThemeData(color: Theme.of(context).accentColor),
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        background: Hero(
                            tag: widget.routeArgument.heroTag +
                                _con.restaurant.id,
                            child: CachedNetworkImage(
                              imageUrl: _con.restaurant.image.url,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fadeOutDuration: const Duration(seconds: 1),
                              fadeInDuration: const Duration(seconds: 2),
                            ) /* Image.network(
                            _con.restaurant.image.url,
                            fit: BoxFit.cover,
                          ),*/
                            ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Wrap(
                        children: [
                          _con.restaurant.closed
                              ? Container(
                                  height: 40,
                                  width: double.infinity,
                                  color: Colors.red,
                                  child: Center(
                                      child: Text(
                                    S.of(context).temporary_closed,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: "Poppins"),
                                  )),
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 20, left: 20, bottom: 10, top: 25),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    _con.restaurant.name,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    maxLines: 2,
                                    style: Theme.of(context).textTheme.display2,
                                  ),
                                ),
                                /* _con.restaurant.rate != "0"
                                    ? SizedBox(
                                        height: 32,
                                        child: Chip(
                                          padding: EdgeInsets.all(0),
                                          label: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(_con.restaurant.rate,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .body2
                                                      .merge(TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor))),
                                              Icon(
                                                Icons.star_border,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                          backgroundColor: Theme.of(context)
                                              .accentColor
                                              .withOpacity(0.9),
                                          shape: StadiumBorder(),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 0,
                                      ),*/
                              ],
                            ),
                          ),
                          _con.restaurant.description != ""
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: Html(
                                    data: _con.restaurant.description,
                                    defaultTextStyle: Theme.of(context)
                                        .textTheme
                                        .body1
                                        .merge(TextStyle(fontSize: 14)),
                                  ),
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                          ImageThumbCarouselWidget(
                              galleriesList: _con.galleries),
                          _con.restaurant.information != ""
                              ? information()
                              : SizedBox(
                                  height: 0,
                                ),
                          address(),
                          _con.restaurant.phone != null ||
                                  _con.restaurant.mobile != null
                              ? telephone()
                              : SizedBox(
                                  height: 0,
                                ),
                          _con.showdateandtime
                              ? opencloseTime(context)
                              : SizedBox(
                                  height: 0,
                                ),
                          notifyAvailable(context),
                          _con.restaurant.closed
                              ? SizedBox(
                                  height: 0,
                                )
                              : ReserveationTime(context),
                        ],
                      ),
                    ),
                  ],
                ),
        ));
  }
}
