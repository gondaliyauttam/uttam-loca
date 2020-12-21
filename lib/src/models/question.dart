
class Questions{
  int id;
  String statement;
  bool ans;


  Questions();

  Questions.fromJSON(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'],
        statement = jsonMap['statement'];

}

class ReqQuestion {
  String slot='';
  String date='';
  String amount='';
  int restaurantid;
  int affirmationid;
  int personcount;
  int slotlength;
  String priceamount='';
  String pricetype='';


  ReqQuestion();

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["restaurant_id"] = restaurantid;
    map["slot"] = slot;
    map["affirmation_id"] = affirmationid;
    map["person_count"] = personcount;
    map["reservation_slot_id"] = null;
    map["date"] = date;
    map["amount"] = amount;
    map["slot_length"] = slotlength;
    map["price_amount"] = priceamount;
    map["price_type"] = pricetype;
    return map;
  }
}
