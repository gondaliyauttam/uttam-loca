
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:loca_bird/src/models/booking.dart';
import 'package:loca_bird/src/models/question.dart';
import 'package:loca_bird/src/models/user.dart';
import 'package:loca_bird/src/repository/restaurant_repository.dart';
import 'package:loca_bird/src/repository/user_repository.dart';
import 'package:http/http.dart' as http;

Future<http.Response> getaffirmation(id,person) async {
  User _user = await getCurrentUser();
  final String _apiToken = _user.apiToken;
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}affirmation/submit';

  Map<String, String> headers = new HashMap();
  headers['Accept'] = 'application/json';
  headers['Content-type'] = 'application/json';
  headers['Authorization'] = 'Bearer $_apiToken';

  final http.Response response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(<String, dynamic>{
      'restaurant_id': int.parse(id),
      'person_count': person,
    }),
  );

  print(response.body);

  /*if (response.statusCode == 200) {
    return Affirmation.fromJson(json.decode(response.body));
  } else if(response.statusCode==401){
    BotToast.showText(text: json.decode(response.body)['message'] );
    throw Exception('Failed to create album.');
  }*/
  return response;
}

Future<http.Response> bookingcreate(ReqQuestion reqQuestion) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}';

  final String url = '${GlobalConfiguration().getString('api_base_url')}booking/create?$_apiToken';

  Map<String, String> headers = new HashMap();
  headers['Accept'] = 'application/json';
  headers['Content-type'] = 'application/json';

  print(json.encode(reqQuestion.toMap()));

  final http.Response response = await http.post(
    url,
    headers: headers,
    body:json.encode(reqQuestion.toMap()),
  );
 /* Map data = json.decode(response.body);
  List serverData = data['booking'];
  print(serverData);*/


 //  return Booking.fromJson(json.decode(response.body));

  return response;


}

Future<Transaction> bookingdetails(id) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}';

  final String url = '${GlobalConfiguration().getString('api_base_url')}booking/pay-details?$_apiToken';

  Map<String, String> headers = new HashMap();
  headers['Accept'] = 'application/json';
  headers['Content-type'] = 'application/json';

  Map<String,dynamic> body = {"booking_id": id, "success_url": "https://locabird/booking/success"};

  final http.Response response = await http.post(
    url,
    headers: headers,
    body:jsonEncode(body),
  );

  print(response.body);

  if (response.statusCode == 200) {

  return  Transaction.fromJson(json.decode(response.body)['transaction']);
  } else {
    throw Exception('Failed to fetch book details.');
  }
}

Future<PaymentCheck> bookingcheck(id) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}';

  final String url = '${GlobalConfiguration().getString('api_base_url')}booking/transaction/$id?$_apiToken';

  final http.Response response = await http.get(url);

  print(response.body);

  if (response.statusCode == 200) {
    return  PaymentCheck.fromJson(json.decode(response.body)['data']);
  } else {
    throw Exception('Failed to checking.');
  }
}