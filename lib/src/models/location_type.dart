class LocationTypeData {
  bool status;
  List<LocationType> locationTypes;

  LocationTypeData({this.status, this.locationTypes});

  LocationTypeData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['location_types'] != null) {
      locationTypes = new List<LocationType>();
      json['location_types'].forEach((v) {
        locationTypes.add(new LocationType.fromJson(v));
      });
    }
  }
}

class LocationType {
  int id;
  String name;
  String createdAt;
  String updatedAt;
  String icon;
  int isActive;
  String iconUrl;
  bool isSelected = true;

  LocationType(
      {this.id,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.icon,
      this.isActive,
      this.iconUrl,
      this.isSelected});

  LocationType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    icon = json['icon'];
    isActive = json['is_active'];
    iconUrl = json['icon_url'];
  }
}

class Pivot {
  int restaurantId;
  int locationTypeId;

  Pivot({this.restaurantId, this.locationTypeId});

  Pivot.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurant_id'];
    locationTypeId = json['location_type_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant_id'] = this.restaurantId;
    data['location_type_id'] = this.locationTypeId;
    return data;
  }
}
