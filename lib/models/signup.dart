import 'package:flutter/material.dart';
import 'package:bobjari_proj/models/preference/schedule.dart';
import 'package:bobjari_proj/models/preference/location.dart';

class SignupModel {
  // required
  late String email;
  late int age;
  late String gender;
  late String nickname;
  late FileImage imgData;
  late String imgType;
  String role = 'mentor';
  // optional
  late String? interests;
  late String? job;
  late String? company;
  late int? years;
  late List<int>? topics;
  late int? authSelect;
  late bool? isAuth;
  late String? title;
  late String? introduce;
  late SchedulePreferenceModel? schedule;
  late LocationModel? location;
  late int? feeSelect;
  late String? fee;

  SignupModel(
      {required this.email,
      required this.age,
      required this.gender,
      required this.nickname,
      required this.imgData,
      required this.imgType,
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
}
