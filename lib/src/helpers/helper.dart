import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';

import 'package:loca_bird/src/models/food_order.dart';
import 'package:loca_bird/src/models/setting.dart';
import 'package:loca_bird/src/repository/settings_repository.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Helper {
  // for mapping data retrieved form json array
  static getData(Map<String, dynamic> data) {
    return data['data'] ?? [];
  }

  static getLocation(Map<String, dynamic> data) {
    return data['location_types'] ?? [];
  }

  static getStatus(Map<String, dynamic> data) {
    return data['status'] ?? false;
  }

  static int getIntData(Map<String, dynamic> data) {
    return (data['data'] as int) ?? 0;
  }

  static getObjectData(Map<String, dynamic> data) {
    return data['data'] ?? new Map<String, dynamic>();
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  static Future<Marker> getMarker(Map<String, dynamic> res) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/img/marker.png', 100);
    final Marker marker = Marker(
        markerId: MarkerId(res['id']),
        icon: BitmapDescriptor.fromBytes(markerIcon),
//        onTap: () {
//          //print(res.name);
//        },
        anchor: Offset(0.5, 0.5),
        infoWindow: InfoWindow(
            title: res['name'],
            snippet: res['distance'].toStringAsFixed(2) + ' mi',
            onTap: () {
              print('infowi tap');
            }),
        position: LatLng(
            double.parse(res['latitude']), double.parse(res['longitude'])));

    return marker;
  }

  static Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
      BuildContext context, String assetName) async {
    // Read SVG file as String
    String svgString =
        await DefaultAssetBundle.of(context).loadString(assetName);
    // Create DrawableRoot from SVG String

    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, null);

    // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    double width =
        50 * devicePixelRatio; // where 32 is your SVG's original width
    double height = 50 * devicePixelRatio; // same thing
    // Convert to ui.Picture
    ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));
    // Convert to ui.Image. toImage() takes width and height as parameters
    // you need to find the best size to suit your needs and take into account the
    // screen DPI
    ui.Image image = await picture.toImage(width.toInt(), height.toInt());
    ByteData bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> bitmapDescriptorFromNetwork(
      BuildContext context, String assetName) async {
    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    double width =
        45 * devicePixelRatio; // where 32 is your SVG's original width
    double height = 55 * devicePixelRatio;

    File markerImageFile = await DefaultCacheManager().getSingleFile(assetName);

    Uint8List markerImageBytes = await markerImageFile.readAsBytes();
    Codec markerImageCodec = await instantiateImageCodec(markerImageBytes,
        targetWidth: width.toInt(), targetHeight: height.toInt());

    final FrameInfo frameInfo = await markerImageCodec.getNextFrame();
    final ByteData byteData = await frameInfo.image.toByteData(
      format: ImageByteFormat.png,
    );

    final Uint8List resizedMarkerImageBytes = byteData.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(resizedMarkerImageBytes);
  }

  static Future<Marker> getMarkers(BuildContext context,
      Map<String, dynamic> res, String img, Function ontap) async {
    final BitmapDescriptor bitmapDescriptor =
        await bitmapDescriptorFromNetwork(context, img);
    final Marker marker = Marker(
        markerId: MarkerId(res['id']),
        icon: bitmapDescriptor,
        anchor: Offset(0.5, 0.5),
        onTap: ontap,
        position: LatLng(
            double.parse(res['latitude']), double.parse(res['longitude'])));

    return marker;
  }

  static Future<Marker> getMyPositionMarker(
      double latitude, double longitude) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/icon/marker.png', 100);
    final Marker marker = Marker(
        markerId: MarkerId(Random().nextInt(100).toString()),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        anchor: Offset(0.5, 0.5),
        position: LatLng(latitude, longitude));

    return marker;
  }

  static Future<Marker> getMainMapMyPositionMarker(
      double latitude, double longitude) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/icon/marker.png', 100);
    final Marker marker = Marker(
        markerId: MarkerId("marker_2"),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        anchor: Offset(0.5, 0.5),
        position: LatLng(latitude, longitude));

    return marker;
  }

  static List<Icon> getStarsList(double rate, Color color) {
    var list = <Icon>[];
    list = List.generate(rate.floor(), (index) {
      return Icon(Icons.star, size: 18, color: color);
    });
    if (rate - rate.floor() > 0) {
      list.add(Icon(Icons.star_half, size: 18, color: color));
    }
    list.addAll(
        List.generate(5 - rate.floor() - (rate - rate.floor()).ceil(), (index) {
      return Icon(Icons.star_border, size: 18, color: color);
    }));
    return list;
  }

//  static Future<List> getPriceWithCurrency(double myPrice) async {
//    final Setting _settings = await getCurrentSettings();
//    List result = [];
//    if (myPrice != null) {
//      result.add('${myPrice.toStringAsFixed(2)}');
//      if (_settings.currencyRight) {
//        return '${myPrice.toStringAsFixed(2)} ' + _settings.defaultCurrency;
//      } else {
//        return _settings.defaultCurrency + ' ${myPrice.toStringAsFixed(2)}';
//      }
//    }
//    if (_settings.currencyRight) {
//      return '0.00 ' + _settings.defaultCurrency;
//    } else {
//      return _settings.defaultCurrency + ' 0.00';
//    }
//  }

  static FutureBuilder<Setting> getPrice(double myPrice, {TextStyle style}) {
    if (style != null) {
      style = style.merge(TextStyle(fontSize: style.fontSize + 2));
    }
    return FutureBuilder(
      builder: (context, priceSnap) {
        if (priceSnap.connectionState == ConnectionState.none &&
            priceSnap.hasData == false) {
          return Text('');
        }
        return RichText(
          softWrap: false,
          overflow: TextOverflow.fade,
          maxLines: 1,
          text: priceSnap.data?.currencyRight != null &&
                  priceSnap.data?.currencyRight == false
              ? TextSpan(
                  text: priceSnap.data?.defaultCurrency,
                  style: style ?? Theme.of(context).textTheme.subhead,
                  children: <TextSpan>[
                    TextSpan(
                        text: myPrice.toStringAsFixed(2) ?? '',
                        style: style ?? Theme.of(context).textTheme.subhead),
                  ],
                )
              : TextSpan(
                  text: myPrice.toStringAsFixed(2) ?? '',
                  style: style ?? Theme.of(context).textTheme.subhead,
                  children: <TextSpan>[
                    TextSpan(
                        text: priceSnap.data?.defaultCurrency,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: style != null
                                ? style.fontSize - 4
                                : Theme.of(context).textTheme.subhead.fontSize -
                                    4)),
                  ],
                ),
        );
      },
      future: getCurrentSettings(),
    );
  }

  static double getTotalOrderPrice(FoodOrder foodOrder, double tax) {
    double total = foodOrder.price * foodOrder.quantity;
    foodOrder.extras.forEach((extra) {
      total += extra.price != null ? extra.price : 0;
    });
    total += tax * total / 100;
    return total;
  }

  static String getDistance(double distance) {
    // TODO get unit from settings
    return distance != null ? distance.toStringAsFixed(2) + " km" : "";
  }

  static String skipHtml(String htmlString) {
    var document = parse(htmlString);
    String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }

  static Html applyHtml(context, String html, {TextStyle style}) {
    return Html(
      blockSpacing: 0,
      data: html,
      defaultTextStyle: style ??
          Theme.of(context).textTheme.body2.merge(TextStyle(fontSize: 14)),
      useRichText: false,
      customRender: (node, children) {
        if (node is dom.Element) {
          switch (node.localName) {
            case "br":
              return SizedBox(
                height: 0,
              );
            case "p":
              return Padding(
                padding: EdgeInsets.only(top: 0, bottom: 0),
                child: Container(
                  width: double.infinity,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.start,
                    children: children,
                  ),
                ),
              );
          }
        }
        return null;
      },
    );
  }

  static String limitString(String text,
      {int limit = 24, String hiddenText = "..."}) {
    return text.substring(0, min<int>(limit, text.length)) +
        (text.length > limit ? hiddenText : '');
  }

  static String getCreditCardNumber(String number) {
    String result = '';
    if (number != null && number.isNotEmpty && number.length == 16) {
      result = number.substring(0, 4);
      result += ' ' + number.substring(4, 8);
      result += ' ' + number.substring(8, 12);
      result += ' ' + number.substring(12, 16);
    }
    return result;
  }
}
