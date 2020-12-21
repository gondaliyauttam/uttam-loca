import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loca_bird/src/models/question.dart';
import 'package:loca_bird/widgets/question_switch.dart';

class QuestionSingleCard extends StatefulWidget {
  Questions question;
  Function movenext;
  Function moveback;
  int totalquestion;

  QuestionSingleCard(
      {this.question, this.movenext, this.moveback, this.totalquestion});

  @override
  _QuestionSingleCardState createState() => _QuestionSingleCardState();
}

class _QuestionSingleCardState extends State<QuestionSingleCard> {
  bool isSwitched = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSwitched = widget.question.ans;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 50,
          ),

          Positioned(
            top: 0,
            child: Draggable(

              childWhenDragging: Container(),
              feedback: Card(
                elevation: 12,
                color: Colors.yellow,
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      color: Theme.of(context).accentColor.withOpacity(0.9),
                      elevation: 1,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Text(
                                widget.question.statement,
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
                            height: 20,
                          ),
                          Container(
                            width: 110,
                            height: 50,
                            child: QuestionSwitch(
                              txtcolor: Colors.black,
                              firstname: "No",
                              lastname: "Yes",
                              value: isSwitched,
                              onChanged: (bool val) {
                                setState(() {
                                  isSwitched = val;
                                  print(isSwitched);
                                  if (isSwitched) {
                                    widget.movenext();
                                    widget.question.ans = true;
                                  } else {
                                    widget.question.ans = false;
                                  }
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              child: Card(
                elevation: 12,
                color: Colors.yellow,
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      color: Theme.of(context).accentColor.withOpacity(0.9),
                      elevation: 1,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Text(
                                widget.question.statement,
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
                            height: 20,
                          ),
                          Container(
                            width: 110,
                            height: 50,
                            child: QuestionSwitch(
                              txtcolor: Colors.black,
                              firstname: "No",
                              lastname: "Yes",
                              value: isSwitched,
                              onChanged: (bool val) {
                                setState(() {
                                  isSwitched = val;
                                  print(isSwitched);
                                  if (isSwitched) {
                                    widget.movenext();
                                    widget.question.ans = true;
                                  } else {
                                    widget.question.ans = false;
                                  }
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
