import 'package:bobjari_proj/models/mentor/mentor.dart';

class LikeModel {
  late String? menteeId;
  late MentorModel? mentor;

  LikeModel({this.menteeId, this.mentor});

  LikeModel.fromJson(Map<String, dynamic> json) {
    menteeId = json['mentee'];
    mentor = MentorModel.fromJsonBobjari(json['mentor']);
  }

  Map<String, dynamic> toJson() => {
        'menteeId': menteeId,
        'mentor': mentor?.toJson(),
      };
}
