import 'package:flutter/foundation.dart';
import 'package:bobjari_proj/models/user_model.dart';
import 'package:bobjari_proj/models/token_model.dart';

class Session with ChangeNotifier {
  late UserModel _user;
  late TokenModel _token;

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
}
