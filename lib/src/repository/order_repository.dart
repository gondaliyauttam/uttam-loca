import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:loca_bird/src/helpers/helper.dart';
import 'package:loca_bird/src/models/affirmation.dart';
import 'package:loca_bird/src/models/booking.dart';
import 'package:loca_bird/src/models/pagination.dart';
import 'package:loca_bird/src/models/credit_card.dart';
import 'package:loca_bird/src/models/order.dart';
import 'package:loca_bird/src/models/order_status.dart';
import 'package:loca_bird/src/models/payment.dart';
import 'package:loca_bird/src/models/user.dart';
import 'package:loca_bird/src/repository/user_repository.dart';

Future<Stream<Order>> getOrders() async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}orders?${_apiToken}with=user;foodOrders;foodOrders.food;orderStatus&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=id&sortedBy=desc';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Order.fromJSON(data);
  });
}

Future<Stream<Order>> getOrder(orderId) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}orders/$orderId?${_apiToken}with=user;foodOrders;foodOrders.food;orderStatus';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .map((data) {
    return Order.fromJSON(data);
  });
}

Future<Stream<Order>> getRecentOrders() async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}orders?${_apiToken}with=user;foodOrders;foodOrders.food;orderStatus&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=updated_at&sortedBy=desc&limit=3';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Order.fromJSON(data);
  });
}

Future<Stream<OrderStatus>> getOrderStatus() async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}order_statuses?$_apiToken';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return OrderStatus.fromJSON(data);
  });
}

Future<Order> addOrder(Order order, Payment payment) async {
  User _user = await getCurrentUser();
  CreditCard _creditCard = await getCreditCard();
  order.user = _user;
  order.payment = payment;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}orders?$_apiToken';
  final client = new http.Client();
  Map params = order.toMap();
  params.addAll(_creditCard.toMap());
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(params),
  );
  return Order.fromJSON(json.decode(response.body)['data']);
}

Future<PaginationData> getBookings({pagenumber}) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}booking/all?${_apiToken}page=$pagenumber';


  final http.Response  response= await http.get(url);
  print(jsonDecode(response.body)['data']);

  /*final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
*/

  if (response.statusCode==200) {
    var paginator = PaginationData.fromJson(jsonDecode(response.body)['data']);
    List<Booking> jobs = bookingList(paginator.data);
    paginator.data = jobs;
    return paginator;
  }

 /* return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) {
    print(data is Map);

    var x = Helper.getData(data);

    print(x);
    return x;
  }).map((data) {
    return PaginationData.fromJson(data);
  });*/
}

Future<PaginationData> getAffirmationlist({pagenumber}) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}affirmation/all?${_apiToken}page=$pagenumber';

  final http.Response  response= await http.get(url);
  print(jsonDecode(response.body)['data']);

  if (response.statusCode==200) {
    var paginator = PaginationData.fromJson(jsonDecode(response.body)['data']);
    List<Affirmation> jobs = affirmationList(paginator.data);
    paginator.data = jobs;
    return paginator;
  }

  /*final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .map((data) {
    return AffirmationData.fromJson(data);
  });*/
}
