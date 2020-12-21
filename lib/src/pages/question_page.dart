import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/controllers/questions_controller.dart';
import 'package:loca_bird/src/elements/BlockButtonWidget.dart';
import 'package:loca_bird/src/elements/CircularLoadingWidget.dart';
import 'package:loca_bird/src/elements/DrawerWidget.dart';
import 'package:loca_bird/src/models/question.dart';
import 'package:loca_bird/src/models/route_argument.dart';
import 'package:loca_bird/widgets/question_switch.dart';

class QuestionPage extends StatefulWidget {
  RouteArgument routeArgument;

  QuestionPage({Key key, this.routeArgument}) : super(key: key);

  @override
  _QuestionPageState createState() {
    return _QuestionPageState();
  }
}

class _QuestionPageState extends StateMVC<QuestionPage> {
  QuestionController _con;
  ReqQuestion reqQuestion;

  _QuestionPageState() : super(QuestionController()) {
    _con = controller;
  }

  SwiperController _controller;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _controller = new SwiperController();

    reqQuestion = widget.routeArgument.param;
    print(reqQuestion.amount);
    print(reqQuestion.slot);
    print(reqQuestion.date);
    print(reqQuestion.restaurantid);
    print(reqQuestion.personcount);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _con.addquestion(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "",
          style: Theme.of(context)
              .textTheme
              .title
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: Container(
          child: _con.isloading
              ? Center(child: CircularLoadingWidget(height: 500))
              : SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Swiper(
                        loop: false,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 50,
                                ),
                                Card(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    height: 300,
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(18.0),
                                              child: Text(
                                                _con.question[index].statement,
                                                textAlign: TextAlign.center,
                                                softWrap: true,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: 110,
                                            height: 50,
                                            child: QuestionSwitch(
                                              txtcolor: Colors.black,
                                              firstname: S.of(context).no,
                                              lastname: S.of(context).yes,
                                              value: _con.question[index].ans,
                                              onChanged: (bool val) {
                                                setState(() {
                                                  _con.question[index].ans =
                                                      val;
                                                  print(
                                                      _con.question[index].ans);
                                                  if (!_con.question[index].ans) {
                                                    _con.question[index].ans = false;
                                                    _controller.next(animation: false);
                                                  } else {
                                                    _con.question[index].ans =
                                                        true;
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: _con.question.length,
                        itemWidth: MediaQuery.of(context).size.width * 0.9,
                        itemHeight: MediaQuery.of(context).size.height * 0.60,
                        controller: _controller,
                        layout: SwiperLayout.STACK,
                        pagination: new SwiperPagination(
                            alignment: Alignment.topCenter,
                            margin: new EdgeInsets.all(0.0),
                            builder: new SwiperCustomPagination(builder:
                                (BuildContext context,
                                    SwiperPluginConfig config) {
                              _con.activeIndex = config.activeIndex + 1;
                              return new ConstrainedBox(
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .accentColor
                                                .withOpacity(0.9)),
                                        shape: BoxShape.circle),
                                    height: 100,
                                    width: 100,
                                    child: Center(
                                      child: Text(
                                        "${config.activeIndex + 1}/${config.itemCount}",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Theme.of(context)
                                                .accentColor
                                                .withOpacity(0.9)),
                                      ),
                                    ),
                                  ),
                                ),
                                constraints:
                                    new BoxConstraints.expand(height: 50.0),
                              );
                            })),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      _controller.previous(animation: true);
                                      _con.previousque();
                                      print(_con.activeIndex);
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.arrow_back_ios,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        Text(
                                          S.of(context).previous,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor),
                                        )
                                      ],
                                    ),
                                  ),
                                  _con.activeIndex < _con.question.length
                                      ? InkWell(
                                          onTap: () {
                                            _controller.next(animation: true);
                                            _con.nextque();
                                            print(_con.activeIndex);
                                            print(_con.question.length);
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                S.of(context).next,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                color: Theme.of(context)
                                                    .accentColor,
                                              ),
                                            ],
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () async {
                                            bool submit = _con.question.every(
                                                (user) => user.ans == false);
                                            if (submit) {
                                              setState(() {
                                                _con.isloading = true;
                                              });
                                              _con.getAffirmation(
                                                  widget.routeArgument.id,
                                                  reqQuestion);
                                            } else {
                                              _con.Showdialog(
                                                  false, _con.date, _con.time);
                                            }
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                S.of(context).submit,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                color: Theme.of(context)
                                                    .accentColor,
                                              ),
                                            ],
                                          ),
                                        )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              BlockButtonWidget(
                                text: Text(
                                  S.of(context).cancel,
                                  style: TextStyle(color: Colors.black),
                                ),
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.9),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }
}
