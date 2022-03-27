import '../preference/preference.dart';

class MentorDetailsModel {
  String? mentorId;
  String? introduce;
  PreferenceModel? preference;

  MentorDetailsModel({this.mentorId, this.introduce, this.preference});

  factory MentorDetailsModel.fromJson(Map<String, dynamic> json) {
    return MentorDetailsModel(
      mentorId: json['mentor'],
      introduce: json['introduce'],
      preference: PreferenceModel.fromJson(json['preference']),
    );
  }

  Map<String, dynamic> toJson() => {
        'mentor': mentorId ?? '',
        'introduce': introduce ?? '',
        'preference': preference?.toJson(),
      };
}
