import './metadata.dart';

class MenteeModel {
  String? createdAt;
  String? userId;
  List<String>? interests;
  MenteeMetaModel? metadata;

  MenteeModel({this.createdAt, this.userId, this.interests, this.metadata});

  factory MenteeModel.fromJson(Map<String, dynamic> json) {
    return MenteeModel(
      createdAt: json['createdAt'],
      userId: json['user'],
      interests: json['interests']
          ?.map<String>((interest) => interest as String)
          .toList(),
      metadata: MenteeMetaModel.fromJson(json['metadata']),
    );
  }

  Map<String, dynamic> toJson() => {
        'createdAt': createdAt ?? '',
        'user': userId ?? '',
        'interests': interests ?? [],
        'metadata': metadata?.toJson(),
      };
}
