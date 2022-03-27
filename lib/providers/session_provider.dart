import 'package:flutter/foundation.dart';
import 'package:bobjari_proj/models/user_model.dart';

class Session with ChangeNotifier {
  late UserModel _user;

  UserModel get user => _user;

  set user(UserModel value) {
    _user = value;
    notifyListeners();
  }
}
