import 'package:flutter/foundation.dart';
import 'dart:typed_data';

class Signup with ChangeNotifier {
  String _email = '';
  String _phone = '';
  String _nickname = '';
  int _age = 0;
  String _gender = '';
  late Uint8List _image;
  String _role = '';

  String get email => _email;
  String get phone => _phone;
  String get nickname => _nickname;
  int get age => _age;
  String get gender => _gender;
  Uint8List get image => _image;
  String get role => _role;

  set email(String value) {
    _email = value;
    notifyListeners();
  }

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

  set image(Uint8List value) {
    _image = value;
    notifyListeners();
  }

  set role(String value) {
    _role = value;
    notifyListeners();
  }

  void show() {
    print(
        'email: $_email, phone: $_phone, nickname: $_nickname, age: $_age, gender: $_gender, image: $_image, role: $_role');
  }
}
