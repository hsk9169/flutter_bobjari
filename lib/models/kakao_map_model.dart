import 'package:bobjari_proj/models/preference/location.dart';

class PlaceModel {
  late String? id;
  late String? name;
  late String? address;
  late String? phone;
  late String? url;
  late GeoModel? geolocation;

  PlaceModel(
      {this.id,
      this.name,
      this.address,
      this.phone,
      this.url,
      this.geolocation});

  PlaceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['place_name'] ?? '';
    address = json['road_address_name'] ?? '';
    url = json['place_url'] ?? '';
    geolocation = GeoModel.fromJson(json);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'url': url,
        'geolocation': geolocation!.toJson(),
      };
}
