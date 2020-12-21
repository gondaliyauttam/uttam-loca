class CountryData {
  List<Countries> countries;

  CountryData({this.countries});

  CountryData.fromJson(Map<String, dynamic> json) {
    if (json['Countries'] != null) {
      countries = new List<Countries>();
      json['Countries'].forEach((v) {
        countries.add(new Countries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.countries != null) {
      data['Countries'] = this.countries.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Countries {
  List<States> states;
  String countryName;

  Countries({this.states, this.countryName});

  Countries.fromJson(Map<String, dynamic> json) {
    if (json['States'] != null) {
      states = new List<States>();
      json['States'].forEach((v) {
        states.add(new States.fromJson(v));
      });
    }
    countryName = json['CountryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.states != null) {
      data['States'] = this.states.map((v) => v.toJson()).toList();
    }
    data['CountryName'] = this.countryName;
    return data;
  }
}

class States {
  List<String> cities;
  String stateName;

  States({this.cities, this.stateName});

  States.fromJson(Map<String, dynamic> json) {
    cities = json['Cities'].cast<String>();
    stateName = json['StateName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Cities'] = this.cities;
    data['StateName'] = this.stateName;
    return data;
  }
}
