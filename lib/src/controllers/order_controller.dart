import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:loca_bird/src/models/affirmation.dart';
import 'package:loca_bird/src/models/booking.dart';
import 'package:loca_bird/src/models/pagination.dart';
import 'package:loca_bird/src/models/order.dart';
import 'package:loca_bird/src/models/route_argument.dart';
import 'package:loca_bird/src/repository/order_repository.dart';
import 'package:loca_bird/src/repository/user_repository.dart';

class OrderController extends ControllerMVC {
  List<Order> orders = <Order>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  List<Booking> bookings = <Booking>[];
  List<Affirmation> affirmations = <Affirmation>[];
  bool moreLoading = false;
  bool isloadingbooking = true;
  bool isloadingaffirmation = true;

  int nextPagebooking = 1;
  int lastpagebooking;

  int nextPageaffirm = 1;
  int lastpageaffirm;

  OrderController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    if(currentUser.apiToken != null){
      listenForAffirmation();
      listenForBooking();
    }

  }
  void goToSecondScreen()async {
    var result = await Navigator.of(context).pushNamed('/Login',arguments: new RouteArgument(param: false));

    if(result=true){
      if(currentUser.apiToken != null){
        listenForAffirmation();
        listenForBooking();
      }
    }
    print(result);
  }

  void listenForOrders({String message}) async {
    final Stream<Order> stream = await getOrders();
    stream.listen((Order _order) {
      setState(() {
        orders.add(_order);
      });
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

  Future<void> refreshOrders() async {
    orders.clear();
    bookings.clear();
    affirmations.clear();
    nextPagebooking = 1;
    nextPageaffirm = 1;
    isloadingaffirmation = true;
    isloadingbooking = true;
    //   listenForOrders(message: 'Order refreshed successfuly');
    listenForBooking(message: 'Booking refreshed successfuly');
    listenForAffirmation(message: 'Booking refreshed successfuly');
  }

  void listenForAffirmation({String message}) async {
    try {
      PaginationData pagination =
          await getAffirmationlist(pagenumber: nextPageaffirm);

      setState(() {
        isloadingaffirmation = false;
      });

      if (affirmations.length == null) {
        nextPageaffirm = 1;
      } else {
        nextPageaffirm = pagination.currentPage + 1;
        print("nextpage" + nextPageaffirm.toString());
      }

      if (pagination.data != []) {

        pagination.data.forEach((element) {
          affirmations.add(element);
        });
      }

      lastpageaffirm = pagination.lastPage;
      print("lastpage : " + lastpageaffirm.toString());
    } catch (e) {
      throw "no data";
    }
  }

  void loadMoreAffirmation() async {
    setState(() {
      moreLoading = true;
    });

    try {
      if (nextPageaffirm == 0) {
        affirmations.clear();
      }
      PaginationData pagination =
          await getAffirmationlist(pagenumber: nextPageaffirm);

      if (nextPageaffirm == 1) {
        affirmations.clear();
      }
      if (affirmations.length == null) {
        nextPageaffirm = 1;
      } else {
        nextPageaffirm = pagination.currentPage + 1;
      }

      pagination.data.forEach((element) {
        affirmations.add(element);
      });
      setState(() {
        moreLoading = false;
      });
    } catch (e) {}
    setState(() {
      moreLoading = false;
    });
  }

  void listenForBooking({String message}) async {
    try {
      PaginationData pagination =
          await getBookings(pagenumber: nextPagebooking);

      setState(() {
        isloadingbooking = false;
      });

      if (bookings.length == null) {
        nextPagebooking = 1;
      } else {
        nextPagebooking = pagination.currentPage + 1;
        print("nextpage" + nextPagebooking.toString());
      }
      if (pagination.data != []) {
        pagination.data.forEach((element) {
          bookings.add(element);
        });
      }

      lastpagebooking = pagination.lastPage;
      print("lastpage : " + lastpagebooking.toString());
    } catch (e) {
      throw "no data";
    }
  }

  void loadMoreBooking() async {
    setState(() {
      moreLoading = true;
    });

    try {
      if (nextPagebooking == 0) {
        bookings.clear();
      }
      PaginationData pagination =
          await getBookings(pagenumber: nextPagebooking);

      if (nextPagebooking == 1) {
        bookings.clear();
      }
      if (bookings.length == null) {
        nextPagebooking = 1;
      } else {
        nextPagebooking = pagination.currentPage + 1;
      }

      pagination.data.forEach((element) {
        bookings.add(element);
      });
      setState(() {
        moreLoading = false;
      });
    } catch (e) {}
    setState(() {
      moreLoading = false;
    });
  }
}
