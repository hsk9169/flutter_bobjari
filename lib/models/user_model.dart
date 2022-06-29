import 'package:bobjari_proj/models/user/profile.dart';
import 'package:bobjari_proj/models/mentor/mentor.dart';
import 'package:bobjari_proj/models/mentee/mentee.dart';

class UserModel {
  late ProfileModel? profile;
  late String? deviceToken;
  late String? role;
  late String? createdAt;
  late String? userId;
  late MentorModel? mentor;
  late MenteeModel? mentee;

  UserModel(
      {this.profile,
      this.deviceToken,
      this.role,
      this.createdAt,
      this.userId,
      this.mentor,
      this.mentee});

  UserModel.fromJson(Map<String, dynamic> json) {
    profile =
        json['profile'] != null ? ProfileModel.fromJson(json['profile']) : null;
    deviceToken = json['deviceToken'] != null ? json['deviceToken'] : null;
    role = json['role'] != null ? json['role'] : null;
    createdAt = json['createdAt'] != null ? json['createdAt'] : null;
    userId = json['id'] != null ? json['id'] : null;
    mentor = json['mentor'] != null
        ? MentorModel.fromJsonUser(json['mentor'])
        : null;
    mentee = json['mentee'] != null
        ? MenteeModel.fromJsonUser(json['mentee'])
        : null;
  }

  UserModel.fromJsonBobjari(Map<String, dynamic> json) {
    profile =
        json['profile'] != null ? ProfileModel.fromJson(json['profile']) : null;
    deviceToken = json['deviceToken'] != null ? json['deviceToken'] : null;
    role = json['role'] != null ? json['role'] : null;
    createdAt = json['createdAt'] != null ? json['createdAt'] : null;
    userId = json['id'] != null ? json['id'] : null;
    mentor = null;
    mentee = null;
  }

  Map<String, dynamic> toJson() => {
        'profile': profile?.toJson(),
        'role': role,
        'createdAt': createdAt,
        'userId': userId,
        'mentor': mentor?.toJson(),
        'mentee': mentee?.toJson(),
      };
}
