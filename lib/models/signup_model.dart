import 'package:bobjari_proj/models/preference/schedule.dart';
import 'package:bobjari_proj/models/preference/location.dart';
import 'dart:typed_data';

class SignupModel {
  String? email;
  String? phone;
  int age;
  String gender;
  String nickname;
  Uint8List image;
  String role;
  String? interests;
  String? job;
  String? company;
  int? years;
  List<int>? topics;
  int? authSelect;
  bool? isAuth;
  String? title;
  String? introduce;
  SchedulePreferenceModel? schedule;
  LocationModel? location;
  int? feeSelect;
  String? fee;

  SignupModel(
      {this.email,
      this.phone,
      required this.age,
      required this.gender,
      required this.nickname,
      required this.image,
      required this.role,
      this.interests,
      this.job,
      this.company,
      this.years,
      this.topics,
      this.authSelect,
      this.isAuth,
      this.title,
      this.introduce,
      this.schedule,
      this.location,
      this.feeSelect,
      this.fee});

  Map<String, dynamic> toJson() => {
        'email': email,
        'phone': phone,
        'nickname': nickname,
        'age': age,
        'gender': gender,
        'image': image,
        'role': role,
      };
}
