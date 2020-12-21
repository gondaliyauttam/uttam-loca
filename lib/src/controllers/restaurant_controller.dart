import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/models/food.dart';
import 'package:loca_bird/src/models/gallery.dart';
import 'package:loca_bird/src/models/restaurantdata.dart';
import 'package:loca_bird/src/models/review.dart';
import 'package:loca_bird/src/models/timeslots.dart';
import 'package:loca_bird/src/repository/food_repository.dart';
import 'package:loca_bird/src/repository/gallery_repository.dart';
import 'package:loca_bird/src/repository/restaurant_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:loca_bird/src/repository/settings_repository.dart' as sett;

class RestaurantController extends ControllerMVC {
  Restaurant restaurant;
  List<TimeSlots> timeslotslist = <TimeSlots>[];
  List<Gallery> galleries = <Gallery>[];
  List<Food> foods = <Food>[];
  List<Food> trendingFoods = <Food>[];
  List<Food> featuredFoods = <Food>[];
  List<Review> reviews = <Review>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  String selectedtime = "";
  int personIndex = 0;
  bool showdetail = false;
  String selecteddate = "";
  String selecteddatename = "";
  int selecteddateIndex = 0;
  String toTime;
  bool showdateandtime = false;

  // Map daytime = new Map<String, String>();
//  Map price = new Map<String, String>();
  List<String> person = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];

  int totalamounts() {
    return ((personIndex + 1) * timeslotslist[selecteddateIndex].data.price);
  }

  RestaurantController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void previousImage() {
    setState(() {
      personIndex = personIndex > 0 ? personIndex - 1 : 0;
      print(personIndex + 1);
    });
  }

  void nextImage() {
    setState(() {
      personIndex =
          personIndex < person.length - 1 ? personIndex + 1 : personIndex;
      print(personIndex + 1);
    });
  }

  void gettotime(selectedTime) {
    DateTime tempDate = new DateFormat("hh:mm").parse(selectedTime);
    var time = tempDate
        .add(Duration(hours: timeslotslist[selecteddateIndex].data.slotLength));
    String date = DateFormat("HH:mm").format(time);
    toTime = (date).toString();
  }

  String getopenclose(starttime, endtime) {
    DateTime cTime = DateTime.now();
    DateTime startTime = new DateFormat("hh:mm").parse(starttime);
    startTime = new DateTime(
        cTime.year, cTime.month, cTime.day, startTime.hour, startTime.minute);
    DateTime endTime = new DateFormat("hh:mm").parse(endtime);
    if (endTime.isBefore(new DateTime(
        cTime.year, cTime.month, cTime.day, cTime.hour, cTime.minute))) {
      endTime = new DateTime(cTime.year, cTime.month, cTime.day + 1,
          endTime.hour, endTime.minute - 1);
    } else {
      endTime = new DateTime(
          cTime.year, cTime.month, cTime.day, endTime.hour, endTime.minute);
    }

    if (cTime.isAfter(startTime) && cTime.isBefore(endTime)) {
      return S.of(context).open;
    } else {
      return S.of(context).closed;
    }
  }

  String getPriceType() {
    if (timeslotslist[selecteddateIndex].data.priceType == "per_slot") {
      return "Slot";
    }

    return "Member";
  }

  void listenForRestaurant({String id, String message}) async {
    final Stream<Restaurant> stream = await getRestaurant(id);
    stream.listen((Restaurant _restaurant) {
      setState(() => restaurant = _restaurant);
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Verify your internet connection'),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForGalleries(String idRestaurant) async {
    final Stream<Gallery> stream = await getGalleries(idRestaurant);
    stream.listen((Gallery _gallery) {
      setState(() => galleries.add(_gallery));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForRestaurantReviews({String id, String message}) async {
    final Stream<Review> stream = await getRestaurantReviews(id);
    stream.listen((Review _review) {
      setState(() => reviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForFoods(String idRestaurant) async {
    final Stream<Food> stream = await getFoodsOfRestaurant(idRestaurant);
    stream.listen((Food _food) {
      setState(() => foods.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForTrendingFoods(String idRestaurant) async {
    final Stream<Food> stream =
        await getTrendingFoodsOfRestaurant(idRestaurant);
    stream.listen((Food _food) {
      setState(() => trendingFoods.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForFeaturedFoods(String idRestaurant) async {
    final Stream<Food> stream =
        await getFeaturedFoodsOfRestaurant(idRestaurant);
    stream.listen((Food _food) {
      setState(() => featuredFoods.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenforTimeSlots(String id) async {
    List<TimeSlots> timeslots = await getTimeSlots(id);
    if (timeslots.length != null) {
      timeslotslist = timeslots;

      setState(() {
        showdateandtime = true;
      });
    }
  }

  Future<void> refreshRestaurant() async {
    var _id = restaurant.id;
    restaurant = new Restaurant();
    galleries.clear();
    reviews.clear();
    featuredFoods.clear();
    listenForRestaurant(id: _id, message: 'Restaurant refreshed successfuly');
    listenForRestaurantReviews(id: _id);
    listenForGalleries(_id);
    listenForFeaturedFoods(_id);
    listenforTimeSlots(_id);
  }

  Future<void> openMap() async {
    LocationData currentLocation = await sett.getCurrentLocation();
    if (currentLocation != null) {
      //  String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${currentRestaurant.latitude},${currentRestaurant.longitude}';
      String origin =
          "${currentLocation.latitude},${currentLocation.longitude}"; // lat,long like 123.34,68.56
      String destination = "${restaurant.latitude},${restaurant.longitude}";
      print(origin);
      print(destination);

      String googleUrl = "https://www.google.com/maps/dir/?api=1&origin=" +
          origin +
          "&destination=" +
          destination +
          "&travelmode=driving&dir_action=navigate";
      if (await canLaunch(googleUrl)) {
        await launch(googleUrl);
      } else {
        throw 'Could not open the map.';
      }
    }
  }
}
