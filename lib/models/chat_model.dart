class ChatModel {
  late String? message;
  late String? chatId;
  late String? authorId;

  ChatModel({this.message, this.chatId, this.authorId});

  ChatModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    chatId = json['id'];
    authorId = json['authorId'];
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'chatId': chatId,
        'authorId': authorId,
      };
}
