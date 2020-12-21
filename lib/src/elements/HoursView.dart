import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/models/timeslots.dart';

class HoursView extends StatefulWidget {
  TimeSlots timeslotslist;

  HoursView(this.timeslotslist);

  @override
  _HoursViewState createState() => _HoursViewState();
}

class _HoursViewState extends State<HoursView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 1.5),
      child: widget.timeslotslist.data != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  toBeginningOfSentenceCase(widget.timeslotslist.dayname),
                  style: Theme.of(context).textTheme.body1,
                ),
                widget.timeslotslist.data.dayOff?
                Container(
                  width: 90,
                  alignment: Alignment.centerLeft,
                  child: Text(S.of(context).closed,style: Theme.of(context).textTheme.body1,
                  ),
                ):Container(
                  width: 90,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat("HH:mm").format(DateFormat("hh:mm")
                        .parse(widget.timeslotslist.data.startTime)) +
                        " - " +
                        DateFormat("HH:mm").format(DateFormat("hh:mm")
                            .parse(widget.timeslotslist.data.endTime)),
                    style: Theme.of(context).textTheme.body1,
                  ),
                ),
                // Text(widget.timeslotslist.data.startTime+" to "+widget.timeslotslist.data.endTime)
              ],
            )
          : SizedBox(
              height: 0,
            ),
    );
  }
}
