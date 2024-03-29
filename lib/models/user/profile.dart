class ProfileModel {
  String? email;
  String? phone;
  int? age;
  String? gender;
  String? nickname;
  ProfileImageModel? profileImage;

  ProfileModel(
      {this.email,
      this.phone,
      this.age,
      this.gender,
      this.nickname,
      this.profileImage});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      email: json['email'] != null ? json['email'] : null,
      phone: json['phone'] != null ? json['phone'] : null,
      age: json['age'] != null ? json['age'] : null,
      gender: json['gender'] != null ? json['gender'] : null,
      nickname: json['nickname'] != null ? json['nickname'] : null,
      profileImage: json['image'] != null
          ? ProfileImageModel.fromJson(json['image'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email ?? '',
        'phone': phone ?? '',
        'age': age ?? '',
        'gender': gender ?? '',
        'nickname': nickname ?? '',
        'image': profileImage?.toJson(),
      };
}

// SubClass of Profile
class ProfileImageModel {
  final String? data;
  final String? contentType;

  ProfileImageModel({required this.data, required this.contentType});

  factory ProfileImageModel.fromJson(Map<String, dynamic> json) {
    return ProfileImageModel(
      data: json['data'],
      contentType: json['contentType'],
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data ?? '',
        'contentType': contentType ?? '',
      };
}
