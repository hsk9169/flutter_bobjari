import 'package:bobjari_proj/models/mentee/mentee.dart';

class ReviewModel {
  late String? createdAt;
  late MenteeModel? mentee;
  late String? mentor;
  late int? score;
  late String? body;

  ReviewModel(
      {this.createdAt, this.mentee, this.mentor, this.score, this.body});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'] != null ? json['createdAt'] : null;
    mentee = json['mentee'] != null
        ? MenteeModel.fromJsonBobjari(json['mentee'])
        : null;
    mentor = json['mentor'] != null ? json['mentor'] : null;
    score = json['score'] != null ? json['score'] : null;
    body = json['body'] != null ? json['body'] : null;
  }

  Map<String, dynamic> toJson() => {
        'createdAt': createdAt,
        'mentee': mentee?.toJson(),
        'mentor': mentor,
        'score': score,
        'body': body,
      };
}
