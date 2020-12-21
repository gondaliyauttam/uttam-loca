import 'package:loca_bird/src/models/affirmation.dart';
import 'package:loca_bird/src/models/restaurantdata.dart';

List<Booking> bookingList(List data) {
  var jobs = data.map((m) {
    return Booking.fromJson(m);
  }).toList();
  print(jobs);
  //jobs.removeWhere((j) => j.user == null);

  return jobs;
}

class Booking {
  int id;
  int restaurantId;
  int affirmationId;
  int userId;
  double amount;
  String currency;
  int reservationSlotId;
  String slot;
  String date;
  String time;
  String status;
  String createdAt;
  String updatedAt;
  String priceType;
  int personCount;
  int priceAmount;
  int slotLength;
  Restaurant restaurant;
  Affirmation affirmation;

  Booking(
      {this.id,
      this.restaurantId,
      this.affirmationId,
      this.userId,
      this.amount,
      this.currency,
      this.reservationSlotId,
      this.slot,
      this.slotLength,
      this.priceAmount,
      this.date,
      this.time,
      this.status,
      this.createdAt,
      this.updatedAt});

  Booking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurant_id'] != null ? json['restaurant_id'] : null;
    affirmationId =
        json['affirmation_id'] != null ? json['affirmation_id'] : null;
    userId = json['user_id'];
    amount = json['amount'].toDouble();
    currency = json['currency'];
    reservationSlotId = json['reservation_slot_id'] != null
        ? json['reservation_slot_id']
        : null;
    slot = json['slot'];
    date = json['date'];
    time = json['time'];
    status = json['status'];
    slotLength = json['slot_length'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    priceType = json['price_type'];
    personCount = json['person_count'];
    priceAmount = json['price_amount'];
    restaurant = json['restaurant'] != null
        ? new Restaurant.fromJSON(json['restaurant'])
        : null;
    affirmation = json['affirmation'] != null
        ? new Affirmation.fromJson(json['affirmation'])
        : null;
  }
}

class Transaction {
  String paymentId;
  int amount;
  String currency;
  String status;
  int payableId;
  String payableType;
  String id;
  String updatedAt;
  String createdAt;
  String payurl;

  Transaction(
      {this.paymentId,
      this.amount,
      this.currency,
      this.status,
      this.payableId,
      this.payableType,
      this.id,
      this.updatedAt,
      this.payurl,
      this.createdAt});

  Transaction.fromJson(Map<String, dynamic> json) {
    paymentId = json['payment_id'];
    amount = json['amount'];
    currency = json['currency'];
    status = json['status'];
    payableId = json['payable_id'];
    payableType = json['payable_type'];
    id = json['id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    payurl = json['pay_url'];
  }
}

class PaymentCheck {
  String id;
  int payableId;
  String payableType;
  String paymentMethod;
  String paymentId;
  double amount;
  String currency;
  bool dispute;
  String status;
  String createdAt;
  String updatedAt;

  PaymentCheck(
      {this.id,
      this.payableId,
      this.payableType,
      this.paymentMethod,
      this.paymentId,
      this.amount,
      this.currency,
      this.dispute,
      this.status,
      this.createdAt,
      this.updatedAt});

  PaymentCheck.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    payableId = json['payable_id'];
    payableType = json['payable_type'];
    paymentMethod = json['payment_method'];
    paymentId = json['payment_id'];
    amount = json['amount'].toDouble();
    currency = json['currency'];
    dispute = json['dispute'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class BookingUrl {
  String url;

  BookingUrl({this.url});

  BookingUrl.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }
}
