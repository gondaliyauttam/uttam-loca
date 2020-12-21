

class AvailableColor {
  int id;
  String counterColor;

  AvailableColor({this.id, this.counterColor});

  AvailableColor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    counterColor = json['counter_color'];
  }
}
