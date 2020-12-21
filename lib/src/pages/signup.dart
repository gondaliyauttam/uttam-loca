import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:loca_bird/config/app_config.dart' as config;
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/controllers/user_controller.dart';
import 'package:loca_bird/src/elements/BlockButtonWidget.dart';
import 'package:loca_bird/src/elements/CircularLoadingWidget.dart';
import 'package:loca_bird/src/models/countrydata.dart';
import 'package:loca_bird/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class SignUpWidget extends StatefulWidget {
  RouteArgument routeArgument;

  SignUpWidget({this.routeArgument});

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends StateMVC<SignUpWidget> {
  UserController _con;
  final FocusNode fnOne = FocusNode();
  final FocusNode fnTwo = FocusNode();
  final FocusNode fnThree = FocusNode();
  final FocusNode fnFour = FocusNode();
  final FocusNode fnFive = FocusNode();
  final FocusNode fnSix = FocusNode();
  List<Countries> country;
  List<States> states;
  CountryData countryData;

  _SignUpWidgetState() : super(UserController()) {
    _con = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    _con.fromstart = widget.routeArgument.param as bool;
    super.initState();
    getCountry();
  }

  void getCountry() async{
    String data = await DefaultAssetBundle.of(context).loadString("assets/country.json");
    countryData=CountryData.fromJson(json.decode(data));
    print(countryData.countries.length);
    setState(() {
      country=countryData.countries;
    });


  }

  @override
  Widget build(BuildContext context) {


    Widget reqotp = Row(
      children: <Widget>[
        CountryCodePicker(
          onChanged: (e) {
            print(e.code);
            _con.otp.mobileCode = e.code;
          },
          initialSelection: 'NL',
          showCountryOnly: false,
          showOnlyCountryWhenClosed: false,
          textStyle: Theme.of(context).textTheme.body2,
        ),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            onChanged: (input) => _con.otp.mobile = input,
            validator: (input) => input.length < 10
                ? S.of(context).should_be_more_than_10_letters
                : null,
            decoration: InputDecoration(
              labelText: S.of(context).telephone_number,
              labelStyle: TextStyle(color: Theme.of(context).accentColor),
              contentPadding: EdgeInsets.all(12),
              hintText: '123456789',
              hintStyle: TextStyle(
                  color: Theme.of(context).focusColor.withOpacity(0.7)),
            ),
          ),
        )
      ],
    );

    Widget verifyotp = TextFormField(
      keyboardType: TextInputType.number,
      onChanged: (input) => _con.otp.otp = input,
      validator: (input) =>
          input.length < 4 ? S.of(context).should_be_more_than_4_letters : null,
      decoration: InputDecoration(
        labelText: S.of(context).enter_otp,
        labelStyle: TextStyle(color: Theme.of(context).accentColor),
        contentPadding: EdgeInsets.all(12),
        hintText: '1234',
        hintStyle:
            TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
        prefixIcon:
            Icon(Icons.verified_user, color: Theme.of(context).accentColor),
        border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.2))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.5))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.2))),
      ),
    );

    Widget name = TextFormField(
      focusNode: fnOne,
      onFieldSubmitted: (term) {
        fnOne.unfocus();
        FocusScope.of(context).requestFocus(fnTwo);
      },
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      onSaved: (input) => _con.user.firstName = input,
      validator: (input) => input.length < 3 ? S.of(context).should_be_more_than_3_letters : null,
      decoration: InputDecoration(
        labelText: S.of(context).first_name,
        labelStyle: TextStyle(color: Theme.of(context).accentColor),
        contentPadding: EdgeInsets.all(12),
        hintText: S.of(context).john_doe,
        hintStyle:
            TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
        prefixIcon:
            Icon(Icons.person_outline, color: Theme.of(context).accentColor),
        border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.2))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.5))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.2))),
      ),
    );

    Widget lastname = TextFormField(
      focusNode: fnTwo,
      onFieldSubmitted: (term) {
        fnTwo.unfocus();
        FocusScope.of(context).requestFocus(fnThree);
      },
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      onSaved: (input) => _con.user.lastName = input,
      validator: (input) =>
          input.length < 3 ? S.of(context).should_be_more_than_3_letters : null,
      decoration: InputDecoration(
        labelText: S.of(context).last_name,
        labelStyle: TextStyle(color: Theme.of(context).accentColor),
        contentPadding: EdgeInsets.all(12),
        hintText: S.of(context).john_doe,
        hintStyle:
            TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
        prefixIcon: Icon(Icons.person_outline, color: Theme.of(context).accentColor),
        border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.2))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.5))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.2))),
      ),
    );

    Widget email = TextFormField(
      focusNode: fnThree,
      onFieldSubmitted: (term) {
        fnThree.unfocus();
        FocusScope.of(context).requestFocus(fnFour);
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onSaved: (input) => _con.user.email = input,
      validator: (input) =>
          !input.contains('@') ? S.of(context).should_be_a_valid_email : null,
      decoration: InputDecoration(
        labelText: S.of(context).email,
        labelStyle: TextStyle(color: Theme.of(context).accentColor),
        contentPadding: EdgeInsets.all(12),
        hintText: 'johndoe@gmail.com',
        hintStyle:
            TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
        prefixIcon:
            Icon(Icons.alternate_email, color: Theme.of(context).accentColor),
        border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.2))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.5))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.2))),
      ),
    );

    Widget mobile =TextFormField(
      focusNode: fnFour,
      onFieldSubmitted: (term) {
        fnFour.unfocus();
        FocusScope.of(context).requestFocus(fnFive);
      },
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      onSaved: (input) => _con.user.mobile = input,
      validator: (input) => input.length < 10
          ? S.of(context).should_be_more_than_10_letters
          : null,
      decoration: InputDecoration(
        labelText: S.of(context).telephone_number,
        labelStyle: TextStyle(color: Theme.of(context).accentColor),
        contentPadding: EdgeInsets.all(12),
        hintText: '123456789',
        hintStyle: TextStyle(
            color: Theme.of(context).focusColor.withOpacity(0.7)),
        prefixIcon:
        Icon(Icons.phone, color: Theme.of(context).accentColor),
        border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.2))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.5))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.2))),
      ),
    );

    Widget birthdate = TextFormField(
      onTap: () {
        _con.selectDate(context);
      },
      readOnly: true,
      validator: (input) =>
          input.length < 0 ? S.of(context).select_birth_date : null,
      controller: _con.myController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: S.of(context).birth_date,
        labelStyle: TextStyle(color: Theme.of(context).accentColor),
        contentPadding: EdgeInsets.all(12),
        hintText: '1990-06-30',
        hintStyle:
            TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
        prefixIcon:
            Icon(Icons.calendar_today, color: Theme.of(context).accentColor),
        border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.2))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.5))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.2))),
      ),
    );

    Widget address = TextFormField(
      maxLines: 4,
      minLines: 1,
      focusNode: fnFive,
      keyboardType: TextInputType.emailAddress,
      onSaved: (input) => _con.user.livingPlace = input,
      validator: (input) =>
          input.length < 0 ? S.of(context).should_be_a_valid_email : null,
      decoration: InputDecoration(
        labelText: S.of(context).living_place,
        labelStyle: TextStyle(color: Theme.of(context).accentColor),
        contentPadding: EdgeInsets.all(12),
        hintText: S.of(context).living_place,
        hintStyle:
            TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
        prefixIcon:
            Icon(Icons.location_on, color: Theme.of(context).accentColor),
        border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.2))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.5))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.2))),
      ),
    );

    Widget password = TextFormField(
      focusNode: fnSix,
      obscureText: _con.hidePassword,
      onSaved: (input) => _con.user.password = input,
      validator: (input) =>
          input.length < 6 ? S.of(context).should_be_more_than_6_letters : null,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: S.of(context).password,
        labelStyle: TextStyle(color: Theme.of(context).accentColor),
        contentPadding: EdgeInsets.all(12),
        hintText: '••••••••••••',
        hintStyle:
            TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
        prefixIcon:
            Icon(Icons.lock_outline, color: Theme.of(context).accentColor),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _con.hidePassword = !_con.hidePassword;
            });
          },
          color: Theme.of(context).focusColor,
          icon:
              Icon(_con.hidePassword ? Icons.visibility : Icons.visibility_off),
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.2))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.5))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.2))),
      ),
    );
    String _selectedLocation;


    Widget sendotpwidget=Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius:
          BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              blurRadius: 50,
              color: Theme.of(context)
                  .hintColor
                  .withOpacity(0.2),
            )
          ]),
      margin: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      padding: EdgeInsets.symmetric(
          vertical: 50, horizontal: 27),
      width: config.App(context).appWidth(88),
      height: config.App(context).appHeight(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          reqotp,
          SizedBox(
            height: 15,
          ),
          BlockButtonWidget(
            text: Text(
              "Send OTP",
              style: TextStyle(
                  color:
                  Theme.of(context).primaryColor),
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {
              if (_con.otp.mobile != "" && _con.otp.mobile !=null) {
                setState(() {
                  _con.isLoading = true;
                });
                _con.sendOtp();
              } else {
                _con.scaffoldKey.currentState
                    .showSnackBar(SnackBar(
                  content: Text('Enter Mobile Number'),
                ));
              }
            },
          ),
        ],
      ),
    );

    Widget verifyotpwidget=Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius:
          BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              blurRadius: 50,
              color: Theme.of(context)
                  .hintColor
                  .withOpacity(0.2),
            )
          ]),
      margin: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      padding: EdgeInsets.symmetric(
          vertical: 50, horizontal: 27),
      width: config.App(context).appWidth(88),
      height: config.App(context).appHeight(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          verifyotp,
          SizedBox(
            height: 15,
          ),
          BlockButtonWidget(
            text: Text(
              "Verify OTP",
              style: TextStyle(
                  color: Theme.of(context).primaryColor),
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {
              if (_con.otp.otp != "" && _con.otp.otp != null) {
                setState(() {
                  _con.isLoading = true;
                });
                _con.verifyOtp();
              } else {
                _con.scaffoldKey.currentState
                    .showSnackBar(SnackBar(
                  content: Text('Enter Otp'),
                ));
              }
            },
          ),
        ],
      ),
    );

    Widget registerwidget=Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius:
          BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              blurRadius: 50,
              color: Theme.of(context)
                  .hintColor
                  .withOpacity(0.2),
            )
          ]),
      margin: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      padding: EdgeInsets.symmetric(
          vertical: 50, horizontal: 27),
      width: config.App(context).appWidth(88),
      height: config.App(context).appHeight(80),
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        body: SingleChildScrollView(
          child: Form(
            key: _con.loginFormKey,
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                name,
                SizedBox(height: 30),
                lastname,
                SizedBox(height: 30),
                email,
                SizedBox(height: 30),
                mobile,
                SizedBox(height: 30),
                birthdate,
                /*SizedBox(height: 30),
                address,*/
                SizedBox(height: 30),
                password,
                SizedBox(height: 30),
                BlockButtonWidget(
                  text: Text(
                    S.of(context).register,
                    style: TextStyle(
                        color: Theme.of(context)
                            .primaryColor),
                  ),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    _con.register();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushReplacementNamed('/Login',
            arguments: new RouteArgument(param: _con.fromstart));
      },
      child: Scaffold(
        key: _con.scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Positioned(
              top: 0,
              child: Container(
                width: config.App(context).appWidth(100),
                height: config.App(context).appHeight(20),
                decoration: BoxDecoration(color: Theme.of(context).accentColor),
              ),
            ),
            Positioned(
              top: config.App(context).appHeight(20) - 100,
              child: Container(
                width: config.App(context).appWidth(84),
                height: config.App(context).appHeight(29.5),
                child: Text(
                  S.of(context).lets_start_with_register,
                  style: Theme.of(context)
                      .textTheme
                      .display3
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
            ),
            Positioned(
              top: config.App(context).appHeight(20) - 50,
              child: _con.isLoading
                  ? Container(
                      height: config.App(context).appHeight(80),
                      child: Center(
                        child: CircularLoadingWidget(height: 100),
                      ),
                    )
                  : _con.sentotp
                      ? verifyotpwidget
                      : _con.verifyotp
                          ? registerwidget : sendotpwidget,
            ),
            Positioned(
              bottom: 10,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/Login',
                      arguments: new RouteArgument(param: _con.fromstart));
                },
                textColor: Theme.of(context).accentColor,
                child: Text(S.of(context).i_have_account_back_to_login),
              ),
            )
          ],
        ),
      ),
    );
  }
}
