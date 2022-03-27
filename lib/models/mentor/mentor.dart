import './details.dart';
import './metadata.dart';

class MentorModel {
  String? userId;
  CareerModel? career;
  String? title;
  List<String>? hashtags;
  bool? searchAllow;
  MentorDetailsModel? details;
  MentorMetaModel? metadata;

  MentorModel(
      {this.userId,
      this.career,
      this.title,
      this.hashtags,
      this.searchAllow,
      this.details,
      this.metadata});

  factory MentorModel.fromJson(Map<String, dynamic> json) {
    return MentorModel(
      userId: json['user'],
      career: CareerModel.fromJson(json['career']),
      title: json['title'],
      hashtags: json['hashtags'].map<String>((tag) => tag as String).toList(),
      searchAllow: json['searchAllow'],
      details: MentorDetailsModel.fromJson(json['details']),
      metadata: MentorMetaModel.fromJson(json['metadata']),
    );
  }

  Map<String, dynamic> toJson() => {
        'user': userId ?? '',
        'career': career?.toJson(),
        'title': title ?? '',
        'hashtags': hashtags ?? '',
        'searchAllow': searchAllow ?? '',
        'details': details?.toJson(),
        'metadata': metadata?.toJson(),
      };
}

class CareerModel {
  String? job;
  String? compnay;
  int? years;
  List<int>? topics;
  AuthModel? authModel;

  CareerModel(
      {this.job, this.compnay, this.years, this.topics, this.authModel});

  factory CareerModel.fromJson(Map<String, dynamic> json) {
    return CareerModel(
      job: json['job'],
      compnay: json['compnay'],
      years: json['years'],
      topics: json['topics'].map<int>((topic) => topic as int).toList(),
      authModel: AuthModel.fromJson(json['auth']),
    );
  }

  Map<String, dynamic> toJson() => {
        'job': job ?? '',
        'compnay': compnay ?? '',
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
