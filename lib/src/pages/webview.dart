import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/elements/BlockButtonWidget.dart';
import 'package:loca_bird/src/models/booking.dart';
import 'package:loca_bird/src/models/route_argument.dart';
import 'package:loca_bird/src/repository/booking_repository.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViews extends StatefulWidget {
  RouteArgument routeArgument;

  WebViews({Key key, this.routeArgument}) : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebViews> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  Transaction transaction;
  bool isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    transaction = widget.routeArgument.param as Transaction;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading
        ?Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ):Container(
        child: Column(
          children: <Widget>[
            Expanded(
                child: WebView(
                  initialUrl: transaction.payurl,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                  // TODO(iskakaushik): Remove this when collection literals makes it to stable.
                  // ignore: prefer_collection_literals
                  javascriptChannels: <JavascriptChannel>[
                    _toasterJavascriptChannel(context),
                  ].toSet(),
                  onPageStarted: (String url) {
                    print('Page started loading: $url');
                  },
                  onPageFinished: (String url) {
                    if (url == "https://locabird/booking/success") {
                      setState(() {
                        isloading=true;
                      });
                      checkpayment();

                    }
                    print('Page finished loading: $url');
                  },
                  gestureNavigationEnabled: true,
                )),
          ],
        ),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  void checkpayment() async {
    PaymentCheck paymentCheck = await bookingcheck(transaction.id);
    if (paymentCheck.status == "failed") {

      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) => RedeemConfirmationScreen(false)));
    } else if (paymentCheck.status == "success") {

      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) =>
              RedeemConfirmationScreen(true)));
    }
  }
}

class RedeemConfirmationScreen extends StatelessWidget {
  bool payment=false;
  RedeemConfirmationScreen(this.payment);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        body: payment ? Container(
          padding: EdgeInsets.all(10),
          child: Card(
            color: Theme.of(context).accentColor.withOpacity(1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 150,
                                width: 150,
                                child: FlareActor(
                                    "assets/animations/Success.flr",
                                    alignment: Alignment.center,
                                    fit: BoxFit.contain,
                                    animation: "Untitled"),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                S.of(context).thank_you_details,
                                textAlign: TextAlign.center,
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    BlockButtonWidget(
                      text: Text(
                        S.of(context).oK,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/Pages', (Route<dynamic> route) => false,
                            arguments: 1);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )),
          ),
        )
            : Container(
                padding: EdgeInsets.all(10),
                child: Card(
                  color: Theme.of(context).accentColor.withOpacity(1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 150,
                                      width: 150,
                                      child: FlareActor(
                                          "assets/animations/cancel.flr",
                                          alignment: Alignment.center,
                                          fit: BoxFit.contain,
                                          animation: "cancel"),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      S.of(context).sorry_details,
                                      textAlign: TextAlign.center,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          BlockButtonWidget(
                            text: Text(
                              S.of(context).oK,
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black),
                            ),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/Pages', (Route<dynamic> route) => false,
                                  arguments: 1);
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      )),
                ),
              ),
      ),
    );
  }
}
