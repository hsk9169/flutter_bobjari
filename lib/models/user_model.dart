import 'package:bobjari_proj/models/user/profile.dart';
import 'package:bobjari_proj/models/mentor/mentor.dart';
import 'package:bobjari_proj/models/mentee/mentee.dart';

class UserModel {
  late ProfileModel? profile;
  late String? role;
  late String? createdAt;
  late String? userId;
  late MentorModel? mentor;
  late MenteeModel? mentee;

  UserModel(
      {this.profile,
      this.role,
      this.createdAt,
      this.userId,
      this.mentor,
      this.mentee});

  UserModel.fromJson(Map<String, dynamic> json) {
    profile = ProfileModel.fromJson(json['profile']);
    role = json['role'];
    createdAt = json['createdAt'];
    userId = json['id'];
    mentor = MentorModel.fromJson(json['mentor']);
    mentee = MenteeModel.fromJson(json['mentee']);
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
