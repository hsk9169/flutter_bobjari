import 'package:bobjari_proj/models/preference/location.dart';

class SuggestionModel {
  late String? placeId;
  late String? placeName;
  late String? address;

  SuggestionModel(
      {required this.placeId, required this.placeName, required this.address});

  SuggestionModel.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'] ?? '';
    placeName = json['structured_formatting']['main_text'] ?? '';
    address = json['structured_formatting']['secondary_text'] ?? '';
  }

  Map<String, dynamic> toJson() => {
        'placeId': placeId,
        'placeName': placeName,
        'address': address,
      };
}

class PlaceDetailsModel {
  late String? businessStatus;
  late String? phone;
  late Geometry? geometry;
  late OpeningInfo? openingHours;
  late List<Photo>? photos;
  late String? rating;
  late String? ratingNum;
  late List<Review>? reviews;
  late String? url;

  PlaceDetailsModel({
    this.businessStatus,
    this.phone,
    this.geometry,
    this.openingHours,
    this.photos,
    this.rating,
    this.ratingNum,
    this.reviews,
    this.url,
  });

  PlaceDetailsModel.fromJson(Map<String, dynamic> json) {
    businessStatus = json['business_status'];
    phone = json['formatted_phone_number'];
    geometry = Geometry.fromJson(json['geometry']['location']);
    openingHours = OpeningInfo.fromJson(json['opening_hours']);
    photos =
        json['photos']?.map<Photo>((dynamic el) => Photo.fromJson(el)).toList();
    rating = json['rating'].toString();
    ratingNum = json['user_ratings_total'].toString();
    reviews = json['reviews']
        ?.map<Review>((dynamic el) => Review.fromJson(el))
        .toList();
    url = json['url'];
  }

  Map<String, dynamic> toJson() => {
        'businessStatus': businessStatus,
        'phone': phone,
        'geometry': geometry?.toJson(),
        'openingHours': openingHours?.toJson(),
        'photos': photos?.map((dynamic el) => el.toJson()).toList(),
        'rating': rating.toString(),
        'ratingNum': ratingNum,
        'reviews': reviews?.map((dynamic el) => el.toJson()).toList(),
        'url': url,
      };
}

class Geometry {
  late String lat;
  late String lng;

  Geometry({required this.lat, required this.lng});

  Geometry.fromJson(Map<String, dynamic> json) {
    lat = json['lat'].toString();
    lng = json['lng'].toString();
  }

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };
}

class OpeningInfo {
  late String isOpen;
  late List<String> dayHours;

  OpeningInfo({required this.isOpen, required this.dayHours});

  OpeningInfo.fromJson(Map<String, dynamic> json) {
    isOpen = json['open_now'].toString();
    dayHours = json['weekday_text']
        ?.map<String>((dynamic el) => el as String)
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'isOpen': isOpen,
        'dayHours': dayHours.map((dynamic el) => el as String).toList(),
      };
}

class Photo {
  late String height;
  late String width;
  late String photoRef;

  Photo({required this.height, required this.width, required this.photoRef});

  Photo.fromJson(Map<String, dynamic> json) {
    height = json['height'].toString();
    width = json['width'].toString();
    photoRef = json['photo_reference'];
  }

  Map<String, dynamic> toJson() => {
        'height': height,
        'width': width,
        'photoRef': photoRef,
      };
}

class Review {
  late String rating;
  late String time;
  late String body;

  Review({required this.rating, required this.time, required this.body});

  Review.fromJson(Map<String, dynamic> json) {
    rating = json['rating'].toString();
    time = json['relative_time_description'];
    body = json['text'];
  }

  Map<String, dynamic> toJson() => {
        'rating': rating,
        'time': time,
        'body': body,
      };
}
