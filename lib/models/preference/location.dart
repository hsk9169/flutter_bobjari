class LocationModel {
  late String placeName;
  late String addressName;
  late GeoModel geolocation;

  LocationModel(
      {required this.placeName,
      required this.addressName,
      required this.geolocation});

  LocationModel.fromJson(Map<String, dynamic> json) {
    placeName = json['place_name'] != null ? json['place_name'] : null;
    addressName = json['address_name'] != null ? json['address_name'] : null;
    geolocation = GeoModel.fromJson(json['geolocation']);
  }

  Map<String, dynamic> toJson() => {
        'place_name': placeName,
        'address_name': addressName,
        'geolocation': geolocation.toJson(),
      };
}

class GeoModel {
  late String x;
  late String y;

  GeoModel({required this.x, required this.y});

  GeoModel.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
      };
}
