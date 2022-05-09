class ChatModel {
  late String? message;
  late String? date;
  late String? authorId;

  ChatModel({this.message, this.date, this.authorId});

  ChatModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    date = json['createdAt'];
    authorId = json['authorId'];
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'date': date,
        'authorId': authorId,
      };
}
