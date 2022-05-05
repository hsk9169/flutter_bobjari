import './metadata.dart';
import 'package:bobjari_proj/models/user_model.dart';

class MenteeModel {
  String? createdAt;
  String? id;
  List<String>? interests;
  MenteeMetaModel? metadata;
  UserModel? userDetail;

  MenteeModel(
      {this.createdAt,
      this.id,
      this.interests,
      this.metadata,
      this.userDetail});

  factory MenteeModel.fromJsonBobjari(Map<String, dynamic> json) {
    return MenteeModel(
      createdAt: json['createdAt'],
      id: json['_id'],
      interests: json['interests']
          ?.map<String>((interest) => interest as String)
          .toList(),
      metadata: json['metadata'] != null
          ? MenteeMetaModel.fromJson(json['metadata'])
          : null,
      userDetail: json['userDetail'] != null
          ? UserModel.fromJson(json['userDetail'])
          : null,
    );
  }

  factory MenteeModel.fromJsonUser(Map<String, dynamic> json) {
    return MenteeModel(
      createdAt: json['createdAt'],
      id: json['_id'],
      interests: json['interests']
          ?.map<String>((interest) => interest as String)
          .toList(),
      metadata: MenteeMetaModel.fromJson(json['metadata']),
    );
  }

  Map<String, dynamic> toJson() => {
        'createdAt': createdAt ?? '',
        'id': id ?? '',
        'interests': interests ?? [],
        'metadata': metadata?.toJson(),
        'userDetail': userDetail?.toJson(),
      };
}
