class ChatModel {
  late String? message;
  late String? chatId;

  ChatModel({this.message, this.chatId});

  ChatModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    chatId = json['id'];
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'chatId': chatId,
      };
}
