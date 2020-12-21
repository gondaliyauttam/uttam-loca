class Otp {
  String hash;
  String mobile;
  String updatedAt;
  String createdAt;
  String mobileCode;
  String otp;
  int id;

  Otp({this.hash, this.mobile, this.updatedAt, this.createdAt, this.id});

  Otp.fromJson(Map<String, dynamic> json) {
    hash = json['hash'];
    mobile = json['mobile'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["mobile"] = mobile;
    map["mobile_code"] = mobileCode;
    return map;
  }

  Map verifytoMap() {
    var map = new Map<String, dynamic>();
    map["mobile"] = mobile;
    map["mobile_code"] = mobileCode;
    map["otp"] = otp;
    map["hash"] = hash;
    return map;
  }
}
