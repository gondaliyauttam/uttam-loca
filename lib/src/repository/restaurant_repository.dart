import 'dart:collection';
import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:loca_bird/src/helpers/helper.dart';
import 'package:loca_bird/src/models/availableColor.dart';
import 'package:loca_bird/src/models/location_type.dart';
import 'package:loca_bird/src/models/restaurantdata.dart';
import 'package:loca_bird/src/models/review.dart';
import 'package:loca_bird/src/models/timeslots.dart';
import 'package:loca_bird/src/models/user.dart';
import 'package:loca_bird/src/repository/user_repository.dart';

Future<Stream<Restaurant>> getTopRestaurants() async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}restaurants?$_apiToken';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Restaurant.fromJSON(data);
  });
}

Future<Stream<Restaurant>> getNearRestaurants(
    LocationData myLocation, LocationData areaLocation) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}';
  String _nearParams = '';
  String _orderLimitParam = '';
  if (myLocation != null && areaLocation != null) {
    _orderLimitParam = 'orderBy=area&limit=5';
    _nearParams =
        '&myLon=${myLocation.longitude}&myLat=${myLocation.latitude}&areaLon=${areaLocation.longitude}&areaLat=${areaLocation.latitude}';
  }
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}restaurants?$_apiToken$_nearParams&$_orderLimitParam';
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Restaurant.fromJSON(data);
  });
}

Future<Stream<Restaurant>> getMapRestaurants(
    LocationData myLocation, List<int> selecteditem) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}';
  String _nearParams = '';
  String locationtype = '';
  if (myLocation != null) {
    _nearParams =
        '&myLon=${myLocation.longitude.roundToDouble()}&myLat=${myLocation.latitude.roundToDouble()}&radius=200';
  }
  if (selecteditem.length != 0) {
    final string = selecteditem.join(",");
    print(string);
    locationtype = '&location_types=$string';
  }
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}restaurants/nearby?$_apiToken$_nearParams$locationtype';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {

    return Restaurant.fromJSON(data);
  });
}

Future<Stream<Restaurant>> searchRestaurants(
    String search, LocationData location) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String _searchParam =
      'search=name:$search;description:$search&searchFields=name:like;description:like';
  final String _locationParam =
      'myLon=${location.longitude}&myLat=${location.latitude}&areaLon=${location.longitude}&areaLat=${location.latitude}';
  final String _orderLimitParam = 'orderBy=area&limit=5';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}restaurants?$_apiToken&$_searchParam&$_locationParam&$_orderLimitParam';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Restaurant.fromJSON(data);
  });
}

Future<Stream<Restaurant>> getRestaurant(String id) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}restaurants/$id?$_apiToken';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .map((data) => Restaurant.fromJSON(data));
}

Future<Stream<Review>> getRestaurantReviews(String id) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}restaurant_reviews?${_apiToken}with=user&search=restaurant_id:$id';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Review.fromJSON(data);
  });
}

Future<Stream<Review>> getRecentReviews() async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}restaurant_reviews?${_apiToken}orderBy=updated_at&sortedBy=desc&limit=3&with=user';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Review.fromJSON(data);
  });
}

Future<List<TimeSlots>> getTimeSlots(String id) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}restaurants/$id/slots?$_apiToken';

  var data = await http.get(url);
  var res = jsonDecode(data.body);

  List serverData = res['data'];

  List<TimeSlots> types = serverData.map((e) => TimeSlots.fromJson(e)).toList();

  return types;
}

Future<Stream<LocationType>> getLocationType() async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}location-types';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getLocation(data))
      .expand((data) => (data as List))
      .map((data) {
    return LocationType.fromJson(data);
  });
}

Future<List<AvailableColor>> getstatusupdates({pagenumber}) async {
  User _user = await getCurrentUser();
  final String _apiToken = _user.apiToken;

  final String url =
      '${GlobalConfiguration().getString('api_base_url')}restaurants/status-updates';
  Map<String, String> headers = new HashMap();
  headers['Accept'] = 'application/json';
  headers['Content-type'] = 'application/json';
  headers['Authorization'] = 'Bearer $_apiToken';

  final http.Response response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(<String, dynamic>{
      'restaurant_ids': pagenumber,
    }),
  );

  if (response.statusCode == 200) {
    var res = jsonDecode(response.body);
    List serverData = res;

    List<AvailableColor> types =
        serverData.map((e) => AvailableColor.fromJson(e)).toList();

    return types;
  }
}
