import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'package:bobjari_proj/models/preference/schedule.dart';
import 'package:bobjari_proj/models/preference/fee.dart';
import 'package:bobjari_proj/models/kakao_map_model.dart';

class Signup with ChangeNotifier {
  String _email = '';
  String _phone = '';
  String _nickname = '';
  int _age = 0;
  String _gender = '';
  late Uint8List _image;
  String _role = '';
  List<String>? _interests;
  String? _job;
  String? _company;
  int? _years;
  List<int>? _topics;
  List<SchedulePreferenceModel>? _schedules;
  List<PlaceModel>? _locations;
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
  List<String> get interests => _interests ?? [];
  String get job => _job ?? '';
  String get company => _company ?? '';
  int get years => _years ?? -1;
  List<int> get topics => _topics ?? [];
  List<SchedulePreferenceModel> get schedules => _schedules ?? [];
  List<PlaceModel> get locations => _locations ?? [];
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

  set interests(List<String> value) {
    _interests = value;
    notifyListeners();
  }

  set job(String value) {
    _job = value;
    notifyListeners();
  }

  set company(String value) {
    _company = value;
    notifyListeners();
  }

  set years(int value) {
    _years = value;
    notifyListeners();
  }

  set topic(List<int> value) {
    _topics = value;
    notifyListeners();
  }

  set schedule(List<SchedulePreferenceModel> value) {
    _schedules = value;
    notifyListeners();
  }

  set location(List<PlaceModel> value) {
    _locations = value;
    notifyListeners();
  }

  void show() {
    print(
        'email: $_email, phone: $_phone, nickname: $_nickname, age: $_age, gender: $_gender, role: $_role, job: $_job, company: $company');
  }
}
