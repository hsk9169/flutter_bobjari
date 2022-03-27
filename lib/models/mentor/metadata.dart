class MentorMetaModel {
  String? mentorId;
  int? numNews;
  int? numBobjari;
  RateModel? rate;

  MentorMetaModel({this.mentorId, this.numNews, this.numBobjari, this.rate});

  factory MentorMetaModel.fromJson(Map<String, dynamic> json) {
    return MentorMetaModel(
      mentorId: json['mentorId'],
      numNews: json['numNews'],
      numBobjari: json['numBobjari'],
      rate: RateModel.fromJson(json['rate']),
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
      score: json['score'],
      num: json['num'],
    );
  }

  Map<String, dynamic> toJson() => {
        'score': score ?? '',
        'num': num ?? '',
      };
}
