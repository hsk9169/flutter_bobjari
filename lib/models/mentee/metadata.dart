import 'package:bobjari_proj/models/mentee/mentee.dart';

class MenteeMetaModel {
  String? menteeId;
  int? numNews;
  List<String>? searchKeyword;

  MenteeMetaModel({this.menteeId, this.numNews, this.searchKeyword});

  factory MenteeMetaModel.fromJson(Map<String, dynamic> json) {
    return MenteeMetaModel(
      menteeId: json['mentee'],
      numNews: json['numNews'],
      searchKeyword: json['searchKeyword']
          .map<String>((keyword) => keyword as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'mentee': menteeId ?? '',
        'numNews': numNews ?? '',
        'searchKeyword': searchKeyword ?? '',
      };
}
