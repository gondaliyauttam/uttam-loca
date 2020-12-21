import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/elements/BlockButtonWidget.dart';
import 'package:loca_bird/src/models/affirmation.dart';
import 'package:loca_bird/src/models/booking.dart';
import 'package:loca_bird/src/models/question.dart';
import 'package:loca_bird/src/models/route_argument.dart';
import 'package:loca_bird/src/repository/booking_repository.dart';
import 'package:loca_bird/src/repository/restaurant_repository.dart';

class QuestionController extends ControllerMVC {
  List<Questions> question = <Questions>[];
  int activeIndex = 1;
  int itemCount;
  Affirmation affirmation;
  Booking booking;
  Transaction transaction;
  bool isloading = false;
  GlobalKey<ScaffoldState> scaffoldKey;
  String date;
  String time;

  QuestionController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    DateTime _selectedDate = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');

    date = formatter.format(_selectedDate);

    DateTime now = DateTime.now();
    time = DateFormat('kk:mm:ss').format(now);
  }

  addquestion(BuildContext context) {
    Questions q1 = new Questions();
    q1.id = 1;
    q1.statement = S.of(context).q1;
    q1.ans = true;

    Questions q2 = new Questions();
    q2.id = 2;
    q2.statement = S.of(context).q2;
    q2.ans = true;

    Questions q3 = new Questions();
    q3.id = 3;
    q3.statement = S.of(context).q3;
    q3.ans = true;

    Questions q4 = new Questions();
    q4.id = 4;
    q4.statement = S.of(context).q4;
    q4.ans = true;

    question.add(q1);
    question.add(q2);
    question.add(q3);
    question.add(q4);
  }

  void previousque() {
    setState(() {
      activeIndex = activeIndex > 1 ? activeIndex - 1 : 1;
    });
  }

  void nextque() {
    setState(() {
      activeIndex =
          activeIndex < question.length ? activeIndex + 1 : activeIndex;
    });
  }

  void getAffirmation(String id, ReqQuestion reqQuestion) async {
    Response response = await getaffirmation(id,reqQuestion.personcount);
    if (response.statusCode == 200) {
      Affirmation affirmation =
          Affirmation.fromJson(json.decode(response.body)['data']);
      if (affirmation.id != null) {
        reqQuestion.affirmationid = affirmation.id;
        if (reqQuestion.amount == "") {
          setState(() {
            isloading = false;
          });

          Showdialog(true, date, time);
        } else {
          BookingCreate(reqQuestion);
        }
      } else {
        Showdialog(true, date, time);
      }
    } else if (response.statusCode == 401) {
      BotToast.showText(text: json.decode(response.body)['message']);

      Navigator.of(context).pop();
      throw Exception('Failed to create album.');
    }
  }

  void BookingCreate(ReqQuestion reqQuestion) async {
    try {
      Response response = await bookingcreate(reqQuestion);

      if (response.statusCode == 200) {
        booking = Booking.fromJson(json.decode(response.body)['booking']);
        if (booking.id != null) {
          if (reqQuestion.amount != "0") {
            transaction = await bookingdetails(booking.id);
            if (transaction.payurl != null) {
              Navigator.pushReplacementNamed(context, '/WebView',
                  arguments: RouteArgument(param: transaction));
            }
            print(transaction.payurl);
          } else {
            Showdialog(true, date, time);
          }
        } else {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Unavailable for booking"),
          ));
        }
      } else if (response.statusCode == 422) {
        BotToast.showText(text: "Already Booked",duration: Duration(seconds: 2));
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
    }
  }

  Showdialog(bool ans, String date, String time) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {},
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Card(
                color: Theme.of(context).accentColor.withOpacity(1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.40,
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Column(
                      children: <Widget>[
                        ans
                            ? Expanded(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          S.of(context).thank_you_details,
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          S.of(context).date + " : " + date,
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          S.of(context).time + " : " + time,
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Text(
                                      S.of(context).sorry_details,
                                      textAlign: TextAlign.center,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        BlockButtonWidget(
                          text: Text(
                            S.of(context).oK,
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          ),
                          color: Colors.white,
                          onPressed: () {
                            if (ans) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/Pages', (Route<dynamic> route) => false,
                                  arguments: 1);
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
              ),
            ),
          );
        });
  }

/*  launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
      setState(() {
        isloading = false;
      });
    } else {
      throw 'Could not launch $url';
    }
  }*/
}
