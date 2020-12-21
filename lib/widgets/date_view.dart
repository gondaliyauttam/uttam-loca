import 'package:flutter/material.dart';
import 'package:loca_bird/src/models/timeslots.dart';

typedef DateSelectionCallback = void Function(DateTime selectedDate);
typedef DateChangeListener = void Function(DateTime selectedDate);

const double dateTextSize = 15;

const Color unselectedDateColor = Colors.grey;
const Color selectedDateColor = Color(0xFFFCC000);

// ignore: must_be_immutable
class DatePickerTimeline extends StatefulWidget {
  final double dateSize;
  final Color dateColor;
  final Color selectedColor;
  DateTime currentDate;
  int selectedIndex;
  final DateChangeListener onDateChange;
  final Function onIndexChange;
  List<TimeSlots> timeslotslist;

  DatePickerTimeline(
    this.timeslotslist,
    this.currentDate,
    this.selectedIndex, {
    Key key,
    this.dateSize = dateTextSize,
    this.dateColor = unselectedDateColor,
    this.selectedColor = selectedDateColor,
    this.onDateChange,
    this.onIndexChange,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _DatePickerState();
}

class _DatePickerState extends State<DatePickerTimeline> {
  @override
  // ignore: must_call_super
  void initState() {
    DateTime _date = DateTime.now();
    widget.currentDate = new DateTime(_date.year, _date.month, _date.day);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            color: Theme.of(context).accentColor,
          ),
          height: 50,
          child: Center(
            child: ListView.builder(
                itemCount: 6,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DateTime _date = DateTime.now().add(Duration(days: index));
                  DateTime date =
                      new DateTime(_date.year, _date.month, _date.day);
                  bool isSelected = compareDate(date, widget.currentDate);
                  return DateWidget(
                      date: date,
                      dateColor: widget.dateColor,
                      dateSize: widget.dateSize,
                      selecteddateColor: isSelected
                          ? Theme.of(context).accentColor
                          : Theme.of(context).scaffoldBackgroundColor,
                      unselecteddateColor: isSelected
                          ? Theme.of(context).scaffoldBackgroundColor
                          : Theme.of(context).accentColor,
                      onDateSelected: (selectedDate) {
                        // A date is selected
                        if (widget.onDateChange != null) {
                          widget.onDateChange(selectedDate);
                        }
                        setState(() {
                          widget.currentDate = selectedDate;
                          widget.onIndexChange(index);
                        });
                      });
                }),
          ),
        ),
      ],
    );
  }

  bool compareDate(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }
}

class DateWidget extends StatelessWidget {
  final DateTime date;
  final double dateSize;
  final Color dateColor;
  final Color selecteddateColor;
  final Color unselecteddateColor;
  final DateSelectionCallback onDateSelected;

  DateWidget(
      {@required this.date,
      @required this.dateSize,
      @required this.dateColor,
      @required this.selecteddateColor,
      @required this.unselecteddateColor,
      this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: DateTime.now().day == date.day
            ? Container(
                margin: EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  color: unselecteddateColor,
                ),
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 13, right: 13),
                    child: Center(
                      child: Text("Today", // Date
                          style: TextStyle(
                            color: selecteddateColor,
                            fontSize: dateSize,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          )),
                    )))
            : Container(
                margin: EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: unselecteddateColor,
                ),
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 13, right: 13),
                    child: Center(
                      child: Text(date.day.toString(), // Date
                          style: TextStyle(
                            color: selecteddateColor,
                            fontSize: dateSize,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          )),
                    ))),
        onTap: () {
          // Check if onDateSelected is not null
          if (onDateSelected != null) {
            // Call the onDateSelected Function
            onDateSelected(this.date);
          }
        });
  }
}
