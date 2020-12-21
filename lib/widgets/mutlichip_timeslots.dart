import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:loca_bird/src/models/timeslots.dart';

class MultiSelectChip extends StatefulWidget {
  final List<SlotInfo> timeList;
  final Function onSelectionChanged;
  final Function onSelectedIndex;

  MultiSelectChip(this.timeList,
      {this.onSelectionChanged, this.onSelectedIndex});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  String selectedChoices;

  _buildChoiceList() {
    List<Widget> choices = List();
    widget.timeList.asMap().forEach((index, item) {
      choices.add(Container(
        padding:
            const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
        child: ChoiceChip(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.2),
          selectedColor: Theme.of(context).accentColor.withOpacity(0.9),

          label: Container(
            alignment: Alignment.center,
            height: 30,
            width: 70,
            child: selectedChoices==item.slot? Text(item.slot,style: TextStyle(fontSize: 14.0, color:  Theme.of(context).scaffoldBackgroundColor,fontFamily: 'Poppins')):Text(item.slot,style: TextStyle(fontSize: 14.0, color:  Theme.of(context).accentColor,fontFamily: 'Poppins')),
          ),
          selected: item.available
              ? selectedChoices == item.slot
              : selectedChoices == "",
          shape: item.available
              ? ContinuousRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: Theme.of(context).accentColor.withOpacity(0.9),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                )
              : ContinuousRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.9),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
          onSelected: (selected) {
            item.available
                ? setState(() {
                    selectedChoices = item.slot;
                    widget.onSelectionChanged(selectedChoices);
                    widget.onSelectedIndex(index);
                  })
                : BotToast.showText(
                    text: "Not Available",
                    textStyle: TextStyle(fontSize: 14.00),
                    duration: Duration(milliseconds: 1000));
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: Wrap(
            children: _buildChoiceList(),
            spacing: 6.0,
            runSpacing: 6.0,
          ),
        ),
      ],
    );
  }
}
