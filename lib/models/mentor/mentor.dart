import './details.dart';
import './metadata.dart';
import '../user_model.dart';

class MentorModel {
  String? id;
  CareerModel? career;
  String? title;
  List<String>? hashtags;
  bool? searchAllow;
  MentorDetailsModel? details;
  MentorMetaModel? metadata;
  UserModel? userDetail;

// user

  MentorModel(
      {this.id,
      this.career,
      this.title,
      this.hashtags,
      this.searchAllow,
      this.details,
      this.metadata,
      this.userDetail});

  factory MentorModel.fromJsonBobjari(Map<String, dynamic> json) {
    return MentorModel(
      id: json['_id'],
      career: CareerModel.fromJson(json['career']),
      title: json['title'],
      hashtags: json['hashtags']?.map<String>((tag) => tag as String).toList(),
      searchAllow: json['searchAllow'],
      userDetail: UserModel.fromJsonBobjari(json['userDetail']),
      details: json['details'] != null
          ? MentorDetailsModel.fromJson(json['details'])
          : null,
      metadata: json['metadata'] != null
          ? MentorMetaModel.fromJson(json['metadata'])
          : null,
    );
  }

  factory MentorModel.fromJsonUser(Map<String, dynamic> json) {
    return MentorModel(
      id: json['_id'],
      career: CareerModel.fromJson(json['career']),
      title: json['title'],
      hashtags: json['hashtags']?.map<String>((tag) => tag as String).toList(),
      searchAllow: json['searchAllow'],
      details: MentorDetailsModel.fromJson(json['details']),
      metadata: MentorMetaModel.fromJson(json['metadata']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id ?? '',
        'career': career?.toJson(),
        'title': title ?? '',
        'hashtags': hashtags ?? '',
        'searchAllow': searchAllow ?? '',
        'details': details?.toJson(),
        'metadata': metadata?.toJson(),
        'userDetail': userDetail?.toJson(),
      };
}

class CareerModel {
  String? job;
  String? company;
  int? years;
  List<int>? topics;
  AuthModel? authModel;

  CareerModel(
      {this.job, this.company, this.years, this.topics, this.authModel});

  factory CareerModel.fromJson(Map<String, dynamic> json) {
    return CareerModel(
      job: json['job'],
      company: json['company'],
      years: json['years'],
      topics: json['topics']?.map<int>((topic) => topic as int).toList(),
      authModel: AuthModel.fromJson(json['auth']),
    );
  }

  Map<String, dynamic> toJson() => {
        'job': job ?? '',
        'company': company ?? '',
        'years': years ?? '',
        'topics': topics ?? '',
        'auth': authModel?.toJson(),
      };
}

class AuthModel {
  String? method;
  bool? isAuth;

  AuthModel({this.isAuth, this.method});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(isAuth: json['isAuth'], method: json['method']);
  }

  Map<String, dynamic> toJson() => {
        'isAuth': isAuth ?? '',
        'method': method ?? '',
      };
}
