import 'dart:async';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:loca_bird/src/repository/user_repository.dart' as userRepo;
import 'package:webview_flutter/webview_flutter.dart';

class PayPalController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  WebView webView;
  final Completer<WebViewController> controller =
  Completer<WebViewController>();
  String url = "";
  double progress = 0;

  PayPalController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
  @override
  void initState() {
    final String _apiToken = 'api_token=${userRepo.currentUser.apiToken}';
    final String _userId = 'user_id=${userRepo.currentUser.id}';
    url = '${GlobalConfiguration().getString('base_url')}payments/paypal/express-checkout?$_apiToken&$_userId';
    setState(() {});
    super.initState();
  }
}