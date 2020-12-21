import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/controllers/main_map_controller.dart';
import 'package:loca_bird/src/elements/BlockButtonWidget.dart';
import 'package:loca_bird/src/elements/CircularLoadingWidget.dart';
import 'package:loca_bird/src/models/category_data.dart';

class FilterScreen extends StatefulWidget {
  NewMapController con;

  FilterScreen(this.con);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends StateMVC<FilterScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _con.getlocationtype();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Card(
              color: Theme.of(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 16, bottom: 8),
                        child: Text(
                          S.of(context).location,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width > 360
                                  ? 18
                                  : 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      CheckboxListTile(
                        title: Text(S.of(context).all),
                        value: widget.con.isselected,
                        checkColor: Theme.of(context).scaffoldBackgroundColor,
                        activeColor: widget.con.isselected
                            ? Theme.of(context).accentColor
                            : Colors.grey,
                        onChanged: (newValue) {
                          setState(() {
                            widget.con.isselected = newValue;
                            widget.con.selecteditem.clear();
                            if (widget.con.isselected) {
                              widget.con.locationtypelist.forEach((element) {
                                element.isSelected = true;
                                widget.con.selecteditem.add(element.id);
                                print(widget.con.selecteditem);
                              });
                            } else {
                              widget.con.locationtypelist.forEach((element) {
                                element.isSelected = false;
                                widget.con.selecteditem.remove(element.id);
                                print(widget.con.selecteditem);
                              });
                            }
                          });
                        },

                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      ),
                      Expanded(
                        child: widget.con.locationtypelist.isEmpty
                            ? Center(child: CircularLoadingWidget(height: 500))
                            : popularFilter(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  InkWell(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(bottom: 2, right: 5, top: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        height: 40,
                        width: 40,
                        child: Icon(Icons.cancel,
                            color:
                                Theme.of(context).accentColor.withOpacity(1)),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget popularFilter() {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 6, left: 6),
                child: GridView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    itemCount: widget.con.locationtypelist.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 1),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        onTap: () {
                          setState(() {
                            widget.con.locationtypelist[index].isSelected =
                                !widget.con.locationtypelist[index].isSelected;

                            if (widget.con.locationtypelist[index].isSelected) {
                              widget.con.selecteditem
                                  .add(widget.con.locationtypelist[index].id);
                            } else {
                              widget.con.selecteditem.remove(
                                  widget.con.locationtypelist[index].id);
                            }

                            widget.con.isselected = widget.con.locationtypelist
                                .every((user) => user.isSelected == true);

                            print(
                                widget.con.locationtypelist[index].isSelected);
                            print(widget.con.selecteditem);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Theme.of(context).hintColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: <Widget>[
                                  Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SvgPicture.network(
                                          widget.con.locationtypelist[index]
                                              .iconUrl,
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.fill,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          widget
                                              .con.locationtypelist[index].name,
                                          overflow: TextOverflow.fade,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          style:
                                              Theme.of(context).textTheme.body2,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Icon(
                                      widget.con.locationtypelist[index]
                                              .isSelected
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      color: widget.con.locationtypelist[index]
                                              .isSelected
                                          ? Theme.of(context).accentColor
                                          : Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
        donebutton()
      ],
    );
  }

  Widget donebutton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: BlockButtonWidget(
        text: Text(
          S.of(context).done,
          softWrap: true,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        color: Theme.of(context).accentColor,
        onPressed: () {
          setState(() {
            widget.con.getfiltereddata();
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
