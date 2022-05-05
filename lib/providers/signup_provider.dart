import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'package:bobjari_proj/models/preference/schedule.dart';
import 'package:bobjari_proj/models/preference/location.dart';
import 'package:bobjari_proj/models/preference/fee.dart';

class Signup with ChangeNotifier {
  String _email = '';
  String _phone = '';
  String _nickname = '';
  int _age = 0;
  String _gender = '';
  late Uint8List _image;
  String _role = '';
  String? _job;
  String? _company;
  int? _years;
  List<int>? _topics;
  List<SchedulePreferenceModel>? _schedules;
  List<LocationModel>? _locations;
  int? _careerAuth;
  FeeModel? _fee;
  String? _title;
  String? _introduce;

  String get email => _email;
  String get phone => _phone;
  String get nickname => _nickname;
  int get age => _age;
  String get gender => _gender;
  Uint8List get image => _image;
  String get role => _role;
  String get job => _job ?? '';
  String get company => _company ?? '';
  int get years => _years ?? -1;
  List<int> get topics => _topics ?? [];
  List<SchedulePreferenceModel> get schedules => _schedules ?? [];
  List<LocationModel> get locations => _locations ?? [];
  int get careerAuth => _careerAuth ?? -1;
  FeeModel get fee => _fee ?? FeeModel(select: -1, value: '');
  String get title => _title ?? '';
  String get introduce => _introduce ?? '';

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

  set job(String value) {
    _job = value;
    notifyListeners();
  }

  void show() {
    print(
        'email: $_email, phone: $_phone, nickname: $_nickname, age: $_age, gender: $_gender, image: $_image, role: $_role');
  }
}
