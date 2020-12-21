import 'package:loca_bird/src/models/affirmation.dart';
import 'package:loca_bird/src/models/booking.dart';
import 'package:loca_bird/src/models/restaurantdata.dart';

class PaginationData {
  int currentPage;
  List<dynamic> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  int perPage;
  String prevPageUrl;
  int to;
  int total;

  PaginationData(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  PaginationData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];

    if (json['data'] != null) {
      data = json['data'] as List;
    }
//    if (json['data'] != null || json['data'].isNotEmpty()) {
//      data = new List<BData>();
//      json['data'].forEach((v) {
//        data.add(new BData.fromJson(v));
//      });
//    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'] != null ? json['next_page_url'] : "";
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'] != null ? json['prev_page_url'] : "";
    to = json['to'];
    total = json['total'];
  }
}

