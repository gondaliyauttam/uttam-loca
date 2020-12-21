import 'dart:developer';

import 'package:loca_bird/src/models/media.dart';
import 'package:loca_bird/src/models/rescounter.dart';
import 'package:loca_bird/src/models/location_type.dart';

class Restaurant {
  String id;
  String name;
  Media image;
  String rate;
  String address;
  String description;
  String phone;
  String mobile;
  String information;
  String latitude;
  String longitude;
  String starttime;
  String endtime;
  double distance;
  ResCounter resCounter;
  List<LocationType> locationType;
  int adminCommission;
  int deliveryRange;
  int defaultTax;
  bool closed;
  bool availableForDelivery;
  String createdAt;
  String updatedAt;
  int userLimit;
  bool hasMedia;
  String counterColor;
  String counterColorImage;
  Counter counter;

  Restaurant();

  Restaurant.fromJSON(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'].toString();
    name = jsonMap['name'];
    image =
        jsonMap['media'] != null ? Media.fromJSON(jsonMap['media'][0]) : null;
    resCounter = jsonMap['counter'] != null
        ? new ResCounter.fromJson(jsonMap['counter'])
        : null;
    if (jsonMap['location_types'] != null && jsonMap['location_types'] != []) {
      locationType = new List<LocationType>();
      jsonMap['location_types'].forEach((v) {
        locationType.add(new LocationType.fromJson(v));
      });
    } else {
      locationType = new List<LocationType>();
      locationType.add(LocationType.fromJson({
        'id': 1,
        'name': 'restaurant',
        'icon_url':
            'https://dashboard.locabird.com/images/location-images/winebar.svg'
      }));
    }
    rate = jsonMap['rate'] ?? '0';
    address = jsonMap['address'];
    closed = jsonMap['closed'];
    starttime = jsonMap['start_time'] != null ? jsonMap['start_time'] : '';
    endtime = jsonMap['end_time'] != null ? jsonMap['end_time'] : '';
    description = jsonMap['description'] != null ? jsonMap['description'] : '';
    phone = jsonMap['phone'];
    mobile = jsonMap['mobile'];
    information = jsonMap['information'] != null ? jsonMap['information'] : '';
    latitude = jsonMap['latitude'];
    longitude = jsonMap['longitude'];
    counterColor =
        jsonMap['counter_color'] != "" ? jsonMap['counter_color'] : 'green';
    counterColorImage = jsonMap['counter_color_image'] != null
        ? jsonMap['counter_color_image']
        : '';
    distance = jsonMap['distance'] != null
        ? double.parse(jsonMap['distance'].toString())
        : 0.0;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
    };
  }
}
