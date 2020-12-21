import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String firstname, lastname;
  final Color txtcolor;

  QuestionSwitch(
      {Key key,
      this.value,
      this.onChanged,
      this.firstname,
      this.lastname,
      this.txtcolor})
      : super(key: key);

  @override
  _QuestionSwitchState createState() => _QuestionSwitchState();
}

class _QuestionSwitchState extends State<QuestionSwitch>
    with SingleTickerProviderStateMixin {

  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 60));

  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(24.0)),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              alignment:
                  widget.value ? Alignment.centerRight : Alignment.centerLeft,
              child: widget.value
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Center(
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 14, right: 14, top: 8, bottom: 8),
                              child: Text(
                                widget.lastname,
                                style: TextStyle(color: widget.txtcolor),
                              ),
                            ),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _animationController.reverse();
                            widget.onChanged(false);
                          },
                          child: Center(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 14, right: 14, top: 8, bottom: 8),
                                child: Text(
                                  widget.firstname,
                                  style: TextStyle(color: widget.txtcolor),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            _animationController.forward();
                            widget.onChanged(true);

                          },
                          child: Center(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 14, right: 14, top: 8, bottom: 8),
                                child: Text(
                                  widget.lastname,
                                  style: TextStyle(color: widget.txtcolor),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 14, right: 14, top: 8, bottom: 8),
                              child: Text(
                                widget.firstname,
                                style: TextStyle(color: widget.txtcolor),
                              ),
                            ),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
