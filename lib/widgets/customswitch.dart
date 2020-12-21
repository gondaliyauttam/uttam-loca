import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loca_bird/config/app_images.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  Color color;

  CustomSwitch({Key key, this.value, this.onChanged, this.color})
      : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Center(
          child: Container(
            alignment: Alignment.center,
            width: 120.0,
            height: 35.0,
            decoration: BoxDecoration(
                border: Border.all(color: widget.color),
                borderRadius: BorderRadius.circular(24.0)),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 2.0, bottom: 2.0, right: 2.0, left: 2.0),
              child: Container(
                child: widget.value
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              _animationController.forward();
                              widget.onChanged(false);
                            },
                            child: Container(
                                width: 50,
                                height: 25,
                                padding: EdgeInsets.only(left: 8),
                                child: Image.asset(
                                  markerimg,
                                )),
                          ),
                          Container(
                              width: 50,
                              height: 30,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24)),
                                  color: widget.color),
                              child: Icon(
                                Icons.format_list_bulleted,
                                size: 23,
                                color: Colors.white,
                              )),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              width: 50,
                              height: 30,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24)),
                                  color: widget.color),
                              child: Image.asset(
                                markerimg,
                              )),
                          InkWell(
                            onTap: () {
                              _animationController.reverse();
                              widget.onChanged(true);
                            },
                            child: Container(
                                padding: EdgeInsets.only(right: 8),
                                width: 50,
                                height: 30,
                                child: Icon(
                                  Icons.format_list_bulleted,
                                  size: 23,
                                  color: widget.color,
                                )),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
