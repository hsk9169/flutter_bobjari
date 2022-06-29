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
      createdAt: json['createdAt'] != null ? json['createdAt'] : null,
      id: json['_id'] != null ? json['_id'] : null,
      interests: json['interests'] != null
          ? json['interests']
              ?.map<String>((interest) => interest as String)
              .toList()
          : null,
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
      createdAt: json['createdAt'] != null ? json['createdAt'] : null,
      id: json['_id'] != null ? json['_id'] : null,
      interests: json['interests'] != null
          ? json['interests']
              ?.map<String>((interest) => interest as String)
              .toList()
          : null,
      metadata: json['metadata'] != null
          ? MenteeMetaModel.fromJson(json['metadata'])
          : null,
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
