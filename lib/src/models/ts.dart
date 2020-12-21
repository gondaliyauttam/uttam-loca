// To parse this JSON data, do
//
//     final timeSlots = timeSlotsFromJson(jsonString);

import 'dart:convert';

//
//selectdIndex = 5
//
//
//
//
//List<TimeSlots> timeslots;
//
//timeslots.forEach((v){
//
//  date
//  slots
//
//});
//
//var v =timeslots[5]?.data;
//timeslost.where(
//
//if(timeslots[selectedIndex]?.data ==null)
//{
//  no slot found
//}
//
//timeslots[5].data.slot_info.forEach(
//
//)


class TimeSlots {
  TimeSlots({
    this.date,
    this.dayName,
    this.data,
  });

  DateTime date;
  String dayName;
  Data data;

  factory TimeSlots.fromRawJson(String str) => TimeSlots.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TimeSlots.fromJson(Map<String, dynamic> json) => TimeSlots(
    date: DateTime.parse(json["date"]),
    dayName: json["dayName"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "date": date.toIso8601String(),
    "dayName": dayName,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.restaurantId,
    this.day,
    this.dayOff,
    this.startTime,
    this.endTime,
    this.slotLength,
    this.slotCount,
    this.timeSlots,
    this.priceType,
    this.price,
    this.bookingPerSlot,
    this.createdAt,
    this.updatedAt,
    this.slotInfo,
  });

  int id;
  int restaurantId;
  String day;
  bool dayOff;
  String startTime;
  String endTime;
  int slotLength;
  int slotCount;
  List<String> timeSlots;
  String priceType;
  int price;
  int bookingPerSlot;
  DateTime createdAt;
  DateTime updatedAt;
  List<SlotInfo> slotInfo;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    restaurantId: json["restaurant_id"],
    day: json["day"],
    dayOff: json["day_off"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    slotLength: json["slot_length"],
    slotCount: json["slot_count"],
    timeSlots: List<String>.from(json["time_slots"].map((x) => x)),
    priceType: json["price_type"],
    price: json["price"],
    bookingPerSlot: json["booking_per_slot"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    slotInfo: List<SlotInfo>.from(json["slot_info"].map((x) => SlotInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "restaurant_id": restaurantId,
    "day": day,
    "day_off": dayOff,
    "start_time": startTime,
    "end_time": endTime,
    "slot_length": slotLength,
    "slot_count": slotCount,
    "time_slots": List<dynamic>.from(timeSlots.map((x) => x)),
    "price_type": priceType,
    "price": price,
    "booking_per_slot": bookingPerSlot,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "slot_info": List<dynamic>.from(slotInfo.map((x) => x.toJson())),
  };
}

class SlotInfo {
  SlotInfo({
    this.slot,
    this.available,
  });

  String slot;
  bool available;

  factory SlotInfo.fromRawJson(String str) => SlotInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SlotInfo.fromJson(Map<String, dynamic> json) => SlotInfo(
    slot: json["slot"],
    available: json["available"],
  );

  Map<String, dynamic> toJson() => {
    "slot": slot,
    "available": available,
  };
}
