import 'package:loca_bird/src/models/media.dart';

class User {
  String id;
  String name;
  String firstName;
  String lastName;
  String email;
  String mobile;
  String birthDate;
  String livingPlace;
  String password;
  String apiToken;
  String deviceToken;
  String phone;
  String address;
  String bio;
  Media image;

//  String role;

  User();

  User.fromJSON(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'].toString();
    name = jsonMap['name'];
    email = jsonMap['email'];
    apiToken = jsonMap['api_token'];
    deviceToken = jsonMap['device_token'];
    try {
      phone = jsonMap['custom_fields']['phone']['view'];
    } catch (e) {
      phone = "";
    }
    try {
      address = jsonMap['custom_fields']['address']['view'];
    } catch (e) {
      address = "";
    }
    try {
      bio = jsonMap['custom_fields']['bio']['view'];
    } catch (e) {
      bio = "";
    }
    image = jsonMap['media'] != null ? Media.fromJSON(jsonMap['media'][0]) : null;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["firstname"] = firstName;
    map["lastname"] = lastName;
    map["birthday"] = birthDate;
    map["mobile"] = mobile;
    map["password"] = password;
    map["api_token"] = apiToken;
    map["device_token"] = deviceToken;
    map["phone"] = phone;
    map["address"] = address;
    map["bio"] = bio;
    return map;
  }
}
