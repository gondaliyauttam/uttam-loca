
/*day : {}
//
//List<SlotDetail> days;

days.where((d)=>d.day==monday).first;

//
//days.day days.slot.

class SlotDetail {

  final String day;
  final Slot slot;


}

class Slot {

}*/


class TimeSlots {
  String date;
  String dayname;
  Data data;

  TimeSlots({this.dayname, this.data});

  TimeSlots.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    dayname = json['dayName'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

}

class Data {
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
  String createdAt;
  String updatedAt;
  List<SlotInfo> slotInfo;

  Data(
      {this.id,
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
        this.slotInfo});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurant_id'];
    day = json['day']!=null?json['day']:'';
    dayOff = json['day_off'];
    startTime = json['start_time']!=null?json['start_time']:'';
    endTime = json['end_time']!=null?json['end_time']:'';
    slotLength = json['slot_length'];
    slotCount = json['slot_count'];
    timeSlots = json['time_slots'].cast<String>();
    priceType = json['price_type'];
    price = json['price'];
    bookingPerSlot = json['booking_per_slot'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['slot_info'] != null) {
      slotInfo = new List<SlotInfo>();
      json['slot_info'].forEach((v) {
        slotInfo.add(new SlotInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['restaurant_id'] = this.restaurantId;
    data['day'] = this.day;
    data['day_off'] = this.dayOff;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['slot_length'] = this.slotLength;
    data['slot_count'] = this.slotCount;
    data['time_slots'] = this.timeSlots;
    data['price_type'] = this.priceType;
    data['price'] = this.price;
    data['booking_per_slot'] = this.bookingPerSlot;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.slotInfo != null) {
      data['slot_info'] = this.slotInfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SlotInfo {
  String slot;
  bool available;

  SlotInfo({this.slot, this.available});

  SlotInfo.fromJson(Map<String, dynamic> json) {
    slot = json['slot'];
    available = json['available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slot'] = this.slot;
    data['available'] = this.available;
    return data;
  }
}


