import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/controllers/restaurant_controller.dart';
import 'package:loca_bird/src/elements/BlockButtonWidget.dart';
import 'package:loca_bird/src/models/question.dart';
import 'package:loca_bird/src/models/route_argument.dart';
import 'package:loca_bird/src/repository/user_repository.dart';

class CustomDialog extends StatefulWidget {
  String id;
  CustomDialog(this.id);
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.00),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              BlockButtonWidget(
                text: Text(
                  S.of(context).i_want_tonenter,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                ),
                color: Theme.of(context)
                    .accentColor
                    .withOpacity(0.9),
                onPressed: () {
                  if (currentUser.apiToken == null) {
                    Navigator.of(context).pushNamed('/Login',
                        arguments:
                        new RouteArgument(param: false));
                  }else{
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => PersonDialog(widget.id),
                    );
                  }

                },
              ),
              SizedBox(height: 30,),
              BlockButtonWidget(
                text: Text(
                  S.of(context).i_want_tonreserve,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                ),
                color: Theme
                    .of(context)
                    .accentColor
                    .withOpacity(0.9),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/Details',
                      arguments: RouteArgument(
                        id: widget.id,
                        heroTag: "",
                      ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class PersonDialog extends StatefulWidget {
  String id;
  PersonDialog(this.id);

  @override
  _PersonDialogState createState() => _PersonDialogState();
}

class _PersonDialogState extends StateMVC<PersonDialog> {
  RestaurantController _con;

  _PersonDialogState() : super(RestaurantController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child:Center(child: Text(
                  S.of(context).total_person,
                  style: Theme.of(context).textTheme.display1,
                ),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: <Widget>[
                    Center(
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
                    SizedBox(height: 20,),
                    BlockButtonWidget(
                      text: Text(
                        S.of(context).go,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                      color: Theme
                          .of(context)
                          .accentColor
                          .withOpacity(0.9),
                      onPressed: () {
                        ReqQuestion req = new ReqQuestion();
                        req.slot ="";
                        req.date = "";
                        req.amount ="";
                        req.personcount =int.parse(_con.person[_con.personIndex]);
                        req.restaurantid =
                            int.parse(widget.id);
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(
                            '/QuestionPage',arguments:  RouteArgument(
                            id: widget.id,
                            heroTag: "details",
                            param: req
                        ));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
