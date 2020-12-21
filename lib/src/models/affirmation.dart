import 'package:loca_bird/src/models/restaurantdata.dart';

List<Affirmation> affirmationList(List data) {
  var jobs = data.map((m) {
    return Affirmation.fromJson(m);
  }).toList();
  print(jobs);
  //jobs.removeWhere((j) => j.user == null);

  return jobs;
}

class Affirmation {

  int id;
  int userId;
  int restaurantId;
  String entryCode;
  String exitCode;
  bool withBooking;
  String createdAt;
  String updatedAt;
  String entryQr;
  String exitQr;
  int personCount;
  Null entryAt;
  Null exitAt;
  Restaurant restaurant;

  Affirmation(
      {this.id,
        this.userId,
        this.restaurantId,
        this.entryCode,
        this.exitCode,
        this.withBooking,
        this.createdAt,
        this.updatedAt,
        this.entryQr,
        this.exitQr});

  Affirmation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    restaurantId = json['restaurant_id'];
    entryCode = json['entry_code'];
    entryAt = json['entry_at'];
    exitCode = json['exit_code'];
    exitAt = json['exit_at'];
    withBooking = json['with_booking'];
    personCount = json['person_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    entryQr = json['entry_qr'];
    exitQr = json['exit_qr'];
    restaurant = json['restaurant'] != null
        ? new Restaurant.fromJSON(json['restaurant'])
        : null;
  }
}
