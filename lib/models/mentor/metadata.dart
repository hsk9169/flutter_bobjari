class MentorMetaModel {
  String? mentorId;
  int? numNews;
  int? numBobjari;
  RateModel? rate;

  MentorMetaModel({this.mentorId, this.numNews, this.numBobjari, this.rate});

  factory MentorMetaModel.fromJson(Map<String, dynamic> json) {
    return MentorMetaModel(
      mentorId: json['mentorId'] != null ? json['mentorId'] : null,
      numNews: json['numNews'] != null ? json['numNews'] : null,
      numBobjari: json['numBobjari'] != null ? json['numBobjari'] : null,
      rate: json['rate'] != null ? RateModel.fromJson(json['rate']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'mentorId': mentorId ?? '',
        'numNews': numNews ?? '',
        'numBobjari': numBobjari ?? '',
        'rate': rate?.toJson(),
      };
}

class RateModel {
  int? score;
  int? num;

  RateModel({this.score, this.num});

  factory RateModel.fromJson(Map<String, dynamic> json) {
    return RateModel(
      score: json['score'] != null ? json['score'] : null,
      num: json['num'] != null ? json['num'] : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'score': score ?? '',
        'num': num ?? '',
      };
}
