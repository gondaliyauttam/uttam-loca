import 'package:flutter/material.dart';

class NoDataView extends StatefulWidget {
  String msg;
  NoDataView(this.msg);
  @override
  _NoDataViewState createState() => _NoDataViewState();
}

class _NoDataViewState extends State<NoDataView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(widget.msg,style: Theme.of(context).textTheme.body2,),
      ),
    );
  }
}
