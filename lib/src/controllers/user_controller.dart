import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loca_bird/src/models/otp.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:loca_bird/src/models/user.dart';
import 'package:loca_bird/src/repository/user_repository.dart' as repository;

class UserController extends ControllerMVC {
  User user = new User();
  Otp otp = new Otp();
  bool hidePassword = true;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  FirebaseMessaging _firebaseMessaging;
  bool fromstart;
  bool isLoading = false;
  String selectedDate;
  TextEditingController myController = TextEditingController();
  bool sentotp = false;
  bool verifyotp = false;

  Future<void> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950, 1),
        lastDate: DateTime.now());
    if (picked != null)
      setState(() {
        selectedDate = DateFormat("yyyy-MM-dd").format(picked);
        print(selectedDate);
        myController.text= selectedDate;
        user.birthDate = selectedDate;
      });
  }

  UserController() {
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((String _deviceToken) {
      print('Firebase Toke:$_deviceToken');
      user.deviceToken = _deviceToken;
    });
  }

  void login() async {
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      isLoading = true;
      repository.login(user).then((value) {
        //print(value.apiToken);
        if (value.apiToken != null) {
          setState(() {
            isLoading = false;
          });
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Welcome ${value.name}!'),
          ));
          if (fromstart) {
            Navigator.of(scaffoldKey.currentContext)
                .pushReplacementNamed('/Pages', arguments: 1);
          } else {
            Navigator.of(scaffoldKey.currentContext).pop(true);
          }
        } else {
          setState(() {
            isLoading = false;
          });
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Wrong email or password'),
          ));
        }
      });
    }
  }

  void sendOtp() async {
    repository.sendOtp(otp).then((value) {
        if (value != null && value.hash != null) {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Otp Sent Successfully'),
          ));
          setState((){
            isLoading=false;
            sentotp = true;
          });
        } else {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Wrong mobile number'),
          ));
        }
      });

  }

  void verifyOtp() async {
    repository.verifyOtp(otp).then((value) {
      if (value != null && value.hash != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Verify Successfully'),
        ));
        setState((){
          isLoading=false;
          verifyotp = true;
        });
      } else {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Wrong Otp'),

        ));
      }
    });

  }

  void register() async {
    if (loginFormKey.currentState.validate()) {

      loginFormKey.currentState.save();
      repository.register(user).then((value) {
        if (value != null && value.apiToken != null) {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Welcome ${value.name}!'),
          ));
          if (fromstart) {
            Navigator.of(scaffoldKey.currentContext)
                .pushReplacementNamed('/Pages', arguments: 1);
          } else {
            Navigator.of(scaffoldKey.currentContext).pop();
          }
        } else {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Wrong email or password'),
          ));
        }
      });
    }
  }
}
