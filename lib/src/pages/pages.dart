import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loca_bird/config/app_images.dart';
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/models/route_argument.dart';
import 'package:loca_bird/src/pages/bookingPage.dart';
import 'package:loca_bird/src/pages/home.dart';
import 'package:loca_bird/src/pages/main_page.dart';
import 'package:loca_bird/src/repository/user_repository.dart';

import 'package:loca_bird/widgets/customswitch.dart';

// ignore: must_be_immutable
class PagesTestWidget extends StatefulWidget {
  int currentTab;

  Widget currentPage;

  PagesTestWidget({
    Key key,
    this.currentTab,
  });

  /* {
    currentTab = currentTab != null ? currentTab : 2;
  }*/

  @override
  _PagesTestWidgetState createState() {
    return _PagesTestWidgetState();
  }
}

class _PagesTestWidgetState extends State<PagesTestWidget> {
  bool isSwitched;

  Color c = Color(0xFF9999aa);

  initState() {
    super.initState();
    isSwitched = false;
    _selectTab(widget.currentTab);
  }

  @override
  void didUpdateWidget(PagesTestWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentPage = HomeWidget();
          break;
        case 1:
          widget.currentPage = MainPage(isSwitched: isSwitched);
          break;
        case 2:
          widget.currentPage = BookingPage();
          break;
      }
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(S.of(context).are_you_sure),
            content: new Text(S.of(context).do_you_want_to_exit_an_app),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(S.of(context).no),
              ),
              new FlatButton(
                onPressed: () => SystemNavigator.pop(),
                child: new Text(S.of(context).yes),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: widget.currentPage,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).accentColor,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          iconSize: 20,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedIconTheme: IconThemeData(size: 28),
          unselectedItemColor: Colors.grey,
          currentIndex: widget.currentTab,
          onTap: (int i) {
            this._selectTab(i);
          },
          // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                homegrayimg,
                height: 20,
                width: 20,
              ),
              title: new Container(height: 0.0),
              activeIcon: SvgPicture.asset(
                homegrayimg,
                height: 20,
                width: 20,
                color: Theme.of(context).accentColor,
              ),
            ),
            BottomNavigationBarItem(
              title: new Container(height: 5.0),
              activeIcon: Center(
                child: CustomSwitch(
                  color: Theme.of(context).accentColor,
                  value: isSwitched,
                  onChanged: (bool val) {
                    setState(() {
                      isSwitched = val;
                      widget.currentTab = 1;
                      _selectTab(widget.currentTab);
                      print(isSwitched);
                    });
                  },
                ),
              ),
              icon: Center(
                child: CustomSwitch(
                  color: Colors.grey,
                  value: isSwitched,
                  onChanged: (bool val) {
                    setState(() {
                      isSwitched = val;
                      widget.currentTab = 1;
                      _selectTab(widget.currentTab);
                      print(isSwitched);
                    });
                  },
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                myordergrayimg,
                height: 20,
                width: 20,
              ),
              title: new Container(height: 0.0),
              activeIcon: SvgPicture.asset(
                myorderimg,
                height: 20,
                width: 20,
                color: Theme.of(context).accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
