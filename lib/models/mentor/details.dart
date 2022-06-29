import '../preference/preference.dart';

class MentorDetailsModel {
  String? mentorId;
  String? introduce;
  PreferenceModel? preference;

  MentorDetailsModel({this.mentorId, this.introduce, this.preference});

  factory MentorDetailsModel.fromJson(Map<String, dynamic> json) {
    return MentorDetailsModel(
      mentorId: json['mentor'] != null ? json['mentor'] : null,
      introduce: json['introduce'] != null ? json['introduce'] : null,
      preference: json['preference'] != null
          ? PreferenceModel.fromJson(json['preference'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'mentor': mentorId ?? '',
        'introduce': introduce ?? '',
        'preference': preference?.toJson(),
      };
}
