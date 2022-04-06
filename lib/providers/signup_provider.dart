import 'package:flutter/foundation.dart';

class Signup with ChangeNotifier {
  String _phone = '';
  String _nickname = '';
  int _age = 0;
  String _gender = '';
  String _image = '';
  String _role = '';

  String get phone => _phone;
  String get nickname => _nickname;
  int get age => _age;
  String get gender => _gender;
  String get image => _image;
  String get role => _role;

  set phone(String value) {
    _phone = value;
    notifyListeners();
  }

  set nickname(String value) {
    _nickname = value;
    notifyListeners();
  }

  set age(int value) {
    _age = value;
    notifyListeners();
  }

  set gender(String value) {
    _gender = value;
    notifyListeners();
  }

  set image(String value) {
    _image = value;
    notifyListeners();
  }

  set role(String value) {
    _role = value;
    notifyListeners();
  }

  void show() {
    print(
        'phone: $_phone, nickname: $_nickname, age: $_age, gender: $_gender, image: $_image, role: $_role');
  }
}
