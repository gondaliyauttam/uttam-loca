import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:loca_bird/config/app_images.dart';
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/controllers/profile_controller.dart';
import 'package:loca_bird/src/elements/CircularLoadingWidget.dart';
import 'package:loca_bird/src/models/route_argument.dart';
import 'package:loca_bird/src/repository/settings_repository.dart';
import 'package:loca_bird/src/repository/user_repository.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends StateMVC<DrawerWidget> {
  ProfileController _con;

  _DrawerWidgetState() : super(ProfileController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          _con.user.apiToken == null
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/Login',
                        arguments: new RouteArgument(param: true));
                  },
                  child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withOpacity(0.1),
//              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35)),
                    ),
                    accountName: Text(
                      "Guest",
                      style: Theme.of(context).textTheme.title,
                    ),
                    accountEmail: Text(
                      "",
                      style: Theme.of(context).textTheme.caption,
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Theme.of(context).accentColor,
                      backgroundImage: AssetImage("assets/default/person.png"),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/Profile');
                  },
                  child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withOpacity(0.1),
//              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35)),
                    ),
                    accountName: Text(
                      _con.user.name,
                      style: Theme.of(context).textTheme.title,
                    ),
                    accountEmail: Text(
                      _con.user.email,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Theme.of(context).accentColor,
                      backgroundImage: NetworkImage(_con.user.image.thumb),
                    ),
                  ),
                ),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed('/Pages', arguments: 0);
            },
            leading: SvgPicture.asset(
              homeimg,
              height: 20,
              width: 20,
              color: Theme.of(context).accentColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).home,
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/Notifications');
            },
            leading: SvgPicture.asset(
              notificationimg,
              height: 20,
              width: 20,
              color: Theme.of(context).accentColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).notifications,
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed('/Pages', arguments: 2);
            },
            leading: SvgPicture.asset(
              myorderimg,
              height: 20,
              width: 20,
              color: Theme.of(context).accentColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).my_booking,
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          /* ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/Favorites');
                  },
                  leading: Icon(
                    Icons.favorite,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  title: Text(
                    "Favorite Foods",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),*/
          ListTile(
            dense: true,
            title: Text(
              S.of(context).application_preferences,
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Icon(
              Icons.remove,
              color: Theme.of(context).accentColor.withOpacity(0.3),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/Help');
            },
            leading: SvgPicture.asset(
              helpimg,
              height: 20,
              width: 20,
              color: Theme.of(context).accentColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).help_support,
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          _con.user.apiToken == null
              ? SizedBox(
                  height: 0,
                )
              : ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/Settings');
                  },
                  leading: SvgPicture.asset(
                    settingsimg,
                    height: 20,
                    width: 20,
                    color: Theme.of(context).accentColor.withOpacity(1),
                  ),
                  title: Text(
                    S.of(context).settings,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/Languages');
            },
            leading: SvgPicture.asset(
              languageimg,
              height: 20,
              width: 20,
              color: Theme.of(context).accentColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).languages,
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            onTap: () {
              if (Theme.of(context).brightness == Brightness.dark) {
                setBrightness(Brightness.light);
                DynamicTheme.of(context).setBrightness(Brightness.light);
              } else {
                setBrightness(Brightness.dark);
                DynamicTheme.of(context).setBrightness(Brightness.dark);
              }
              Navigator.of(context).pop();
            },
            leading: Icon(
              Icons.brightness_6,
              color: Theme.of(context).accentColor.withOpacity(1),
            ),
            title: Text(
              Theme.of(context).brightness == Brightness.dark
                  ? "Light Mode"
                  : "Dark Mode",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          _con.user.apiToken == null
              ? SizedBox(
                  height: 0,
                )
              : ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    _onWillPop();
                  },
                  leading: SvgPicture.asset(
                    logoutimg,
                    height: 20,
                    width: 20,
                    color: Theme.of(context).accentColor.withOpacity(1),
                  ),
                  title: Text(
                    S.of(context).log_out,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
          ListTile(
            dense: true,
            title: Text(
              S.of(context).version +" 0.0.1",
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Icon(
              Icons.remove,
              color: Theme.of(context).accentColor.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(S.of(context).are_you_sure),
            content: new Text(S.of(context).do_you_want_to_logout),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(S.of(context).no),
              ),
              new FlatButton(
                onPressed: () {
                  logout().then((value) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/Login', (Route<dynamic> route) => false,
                        arguments: new RouteArgument(param: true));
                  });
                },
                child: new Text(S.of(context).yes),
              ),
            ],
          ),
        )) ??
        false;
  }
}
