import 'dart:io';
import 'dart:typed_data';

import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:loca_bird/config/app_images.dart';
import 'package:loca_bird/generated/i18n.dart';
import 'package:loca_bird/src/elements/BlockButtonWidget.dart';
import 'package:loca_bird/src/elements/BookingTicketWidget.dart';
import 'package:loca_bird/src/models/affirmation.dart';
import 'package:loca_bird/src/repository/user_repository.dart';

class ShareAffirmationImage extends StatefulWidget {
  final Affirmation data;

  const ShareAffirmationImage({Key key, this.data}) : super(key: key);

  @override
  _ShareAffirmationImageState createState() => _ShareAffirmationImageState();
}

class _ShareAffirmationImageState extends State<ShareAffirmationImage> {
  Affirmation affirmation;
  GlobalKey previewContainer = new GlobalKey();
  int originalSize = 800;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    affirmation = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: size,
        padding: EdgeInsets.only(top: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              RepaintBoundary(
                  key: previewContainer,
                  child: Container(
                    color: Color(0xFF272727),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0,right: 16.0),
                      child: Card(
                        margin: EdgeInsets.all(15),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          children: <Widget>[
                            Card(
                              color: Color(0xFF272727),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      markerimg,
                                      height: 40,
                                      width: 40,
                                    ),
                                    Text(
                                      "locabird.com",
                                      style: Theme.of(context).textTheme.body2,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: affirmation.entryQr != null
                                  ? CachedNetworkImage(
                                width: 150,
                                imageUrl: affirmation.entryQr,
                                placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                              )
                                  : SizedBox(
                                height: 0,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  height: 50,
                                  width: 50,
                                  child: Stack(
                                    overflow: Overflow.visible,
                                    children: <Widget>[
                                      Positioned(
                                        left: -1.0,
                                        child: SvgPicture.asset(
                                          l_cutsvg,
                                          height: 50,
                                          color: Color(0xFF272727),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: MySeparator(color: Colors.grey),
                                ),
                                Container(
                                  height: 50,
                                  width: 50,
                                  child: Stack(
                                    overflow: Overflow.visible,
                                    children: <Widget>[
                                      Positioned(
                                        right: -1.0,
                                        child: RotatedBox(
                                          quarterTurns: 2,
                                          child: SvgPicture.asset(
                                            l_cutsvg,
                                            height: 50,
                                            color: Color(0xFF272727),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                                  child: new Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            currentUser.name,
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            Icons.home,
                                            size: 15.0,
                                            color: Colors.black,
                                          ),
                                          SizedBox(
                                            width: 10.00,
                                          ),
                                          Expanded(
                                            child: Text(
                                              affirmation.restaurant.name,
                                              overflow: TextOverflow.fade,
                                              softWrap: false,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18.00,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.00,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            Icons.location_on,
                                            size: 15.0,
                                            color: Colors.black,
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(left: 10.00),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.60,
                                              child: Text(
                                                affirmation.restaurant.address,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.00,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            Icons.calendar_today,
                                            size: 15.0,
                                            color: Colors.black,
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(left: 10.00),
                                            child: Text(
                                              getDate(affirmation.createdAt),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.00,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            Icons.access_time,
                                            size: 15.0,
                                            color: Colors.black,
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(left: 10.00),
                                            child: Text(
                                              getTime(affirmation.createdAt),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.00,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(
                                                Icons.person,
                                                size: 15.0,
                                                color: Colors.black,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.00),
                                                child: Text(
                                                  affirmation.personCount.toString() +
                                                      " " +
                                                      S.of(context).member,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.00,
                                      ),
                                      SizedBox(
                                        height: 10.00,
                                      ),
                                    ],
                                  ),
                                )),
                            Text(
                              S.of(context).note__please_show_this_code_while_entering,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  color: Colors.red[900],
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
              BlockButtonWidget(
                text: Text(
                  S.of(context).share,
                  style: TextStyle(color: Colors.black),
                ),
                color: Theme.of(context).accentColor.withOpacity(0.9),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  takeScreenShot();
                },
              ),

              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
  String getDate(selectedTime) {
    DateTime tempDate =
    new DateFormat("yyyy-mm-dd hh:mm:ss").parse(selectedTime);
    String date = DateFormat("yyyy-mm-dd").format(tempDate);
    return (date).toString();
  }

  String getTime(selectedTime) {
    DateTime tempDate =
    new DateFormat("yyyy-mm-dd hh:mm:ss").parse(selectedTime);
    String date = DateFormat("HH:mm").format(tempDate);
    return (date).toString();
  }
  takeScreenShot() async {
    RenderRepaintBoundary boundary =
    previewContainer.currentContext.findRenderObject();
    double pixelRatio = originalSize / MediaQuery.of(context).size.width;
    ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    if (pngBytes != null) {
      Share.file(
        'esys image',
        'esys.png',
        pngBytes.buffer.asUint8List(),
        'image/png',
      );
    }
    final directory = (await getApplicationDocumentsDirectory()).path;
    File imgFile = new File('$directory/screenshot.png');
    imgFile.writeAsBytes(pngBytes);
  }
}
