import 'package:flutter/material.dart';
import './user/profile.dart';
import './mentor/mentor.dart';
import './mentee/mentee.dart';

class UserModel {
  late ProfileModel profile;
  late String role;
  late String createdAt;
  late String userId;
  late MentorModel mentor;
  late MenteeModel mentee;

  UserModel(
      {required this.profile,
      required this.role,
      required this.createdAt,
      required userId,
      required this.mentor,
      required this.mentee});

  UserModel.fromJson(Map<String, dynamic> json) {
    profile = ProfileModel.fromJson(json['profile']);
    role = json['role'];
    createdAt = json['createdAt'];
    userId = json['id'];
    mentor = MentorModel.fromJson(json['mentor']);
    mentee = MenteeModel.fromJson(json['mentee']);
  }

  Map<String, dynamic> toJson() => {
        'profile': profile.toJson(),
        'role': role,
        'createdAt': createdAt,
        'userId': userId,
        'mentor': mentor.toJson(),
        'mentee': mentee.toJson(),
      };
}
