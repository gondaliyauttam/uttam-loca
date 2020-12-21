class ResCounter {
  int id;
  int restaurantId;
  int counter;
  String createdAt;
  String updatedAt;

  ResCounter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurant_id'];
    counter = json['counter'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

}