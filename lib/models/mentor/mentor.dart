import './details.dart';
import './metadata.dart';
import '../user_model.dart';
import '../review_model.dart';

class MentorModel {
  String? id;
  CareerModel? career;
  String? title;
  List<String>? hashtags;
  bool? searchAllow;
  MentorDetailsModel? details;
  MentorMetaModel? metadata;
  UserModel? userDetail;
  List<ReviewModel>? review;

// user

  MentorModel(
      {this.id,
      this.career,
      this.title,
      this.hashtags,
      this.searchAllow,
      this.details,
      this.metadata,
      this.userDetail,
      this.review});

  MentorModel.fromJsonBobjari(Map<String, dynamic> json) {
    id = json['_id'] != null ? json['_id'] : null;
    career =
        json['career'] != null ? CareerModel.fromJson(json['career']) : null;
    title = json['title'] != null ? json['title'] : null;
    hashtags = json['hashtags'] != null
        ? json['hashtags']?.map<String>((tag) => tag as String).toList()
        : null;
    searchAllow = json['searchAllow'] != null ? json['searchAllow'] : null;
    userDetail = json['userDetail'] != null
        ? UserModel.fromJsonBobjari(json['userDetail'])
        : null;
    details = json['details'] != null
        ? MentorDetailsModel.fromJson(json['details'])
        : null;
    metadata = json['metadata'] != null
        ? MentorMetaModel.fromJson(json['metadata'])
        : null;
    review = json['review']
        ?.map<ReviewModel>((dynamic el) => ReviewModel.fromJson(el))
        .toList();
  }

  factory MentorModel.fromJsonUser(Map<String, dynamic> json) {
    return MentorModel(
      id: json['_id'] != null ? json['_id'] : null,
      career:
          json['career'] != null ? CareerModel.fromJson(json['career']) : null,
      title: json['title'] != null ? json['title'] : null,
      hashtags: json['hashtags'] != null
          ? json['hashtags']?.map<String>((tag) => tag as String).toList()
          : null,
      searchAllow: json['searchAllow'] != null ? json['searchAllow'] : null,
      details: json['details'] != null
          ? MentorDetailsModel.fromJson(json['details'])
          : null,
      metadata: json['metadata'] != null
          ? MentorMetaModel.fromJson(json['metadata'])
          : null,
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
        'review': review?.map((el) => el.toJson()).toList(),
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
      job: json['job'] != null ? json['job'] : null,
      company: json['company'] != null ? json['company'] : null,
      years: json['years'] != null ? json['years'] : null,
      topics: json['topics'] != null
          ? json['topics']?.map<int>((topic) => topic as int).toList()
          : null,
      authModel: json['auth'] != null ? AuthModel.fromJson(json['auth']) : null,
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
