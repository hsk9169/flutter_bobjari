class ChatModel {
  late String? message;
  late String? date;
  late String? authorId;

  ChatModel({this.message, this.date, this.authorId});

  ChatModel.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? '';
    date = json['createdAt'] ?? '';
    authorId = json['author'] ?? '';
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'date': date,
        'author': authorId,
      };
}
