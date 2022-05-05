import 'package:flutter/foundation.dart';
import 'package:bobjari_proj/models/user_model.dart';
import 'package:bobjari_proj/models/token_model.dart';

class Session with ChangeNotifier {
  UserModel _user = UserModel();
  TokenModel _token = TokenModel();

  UserModel get user => _user;
  TokenModel get token => _token;

  set user(UserModel value) {
    _user = value;
    notifyListeners();
  }

  set token(TokenModel token) {
    _token = token;
    notifyListeners();
  }

  void show() {
    _user.toJson();
    _token.toJson();
  }
}
