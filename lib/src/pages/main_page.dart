import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:loca_bird/config/app_constant.dart';
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/controllers/main_map_controller.dart';
import 'package:loca_bird/src/elements/DrawerWidget.dart';
import 'package:loca_bird/src/elements/ShoppingCartButtonWidget.dart';
import 'package:loca_bird/src/models/route_argument.dart';
import 'package:loca_bird/src/pages/restaurant.dart';
import 'package:loca_bird/src/pages/home.dart';
import 'package:loca_bird/src/pages/map_page.dart';
import 'package:loca_bird/src/pages/pages.dart';
import 'package:loca_bird/widgets/customswitch.dart';
import 'package:loca_bird/src/repository/settings_repository.dart'
    as settingsRepo;

class MainPage extends StatefulWidget {
  bool isSwitched;
  MainPage({
    Key key,
    this.isSwitched = false,

  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends StateMVC<MainPage> {
  NewMapController _con;

  _MainPageState() : super(NewMapController()) {
    _con = controller;
  }

  PageController pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (locationpermission) {
      _con.getCurrentLocation();
    } else {
     _con.requestPermission(Permission.location);
    }

    pageController.addListener(() {
      print("page" + pageController.position.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: PageView(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                widget.isSwitched
                    ? RestaurantWidget(con: _con)
                    : MapPage(con: _con),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void movePage(int pageNumber) {
    pageController.animateToPage(
      pageNumber,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
