import 'dart:convert';
import 'package:bobjari_proj/models/bobjari_model.dart';
import 'package:bobjari_proj/models/sms_auth_model.dart';
import 'package:bobjari_proj/models/token_model.dart';
import 'package:bobjari_proj/services/api.dart';
import 'package:flutter/services.dart';
import 'package:bobjari_proj/models/user_model.dart';
import 'package:bobjari_proj/models/signup_model.dart';
import 'package:bobjari_proj/models/mentor/mentor.dart';
import 'package:bobjari_proj/models/chat_model.dart';
import 'package:bobjari_proj/models/like_model.dart';

class FakeApiService implements Api {
  static const _jsonDir = 'assets/json/';
  static const _jsonExtension = '.json';

  @override
  Future<String> authEmail(String email) async {
    return '012345';
  }

  @override
  Future<UserModel> signInBob(String option) async {
    final _resourcePath = _jsonDir + option + _jsonExtension;
    final _data = await rootBundle.load(_resourcePath);
    final _map = json.decode(
      utf8.decode(
        _data.buffer.asUint8List(_data.offsetInBytes, _data.lengthInBytes),
      ),
    );
    return UserModel.fromJson(_map);
  }

  @override
  Future<UserModel> signInKakao(String option) async {
    final _resourcePath = _jsonDir + option + _jsonExtension;
    final _data = await rootBundle.load(_resourcePath);
    final _map = json.decode(
      utf8.decode(
        _data.buffer.asUint8List(_data.offsetInBytes, _data.lengthInBytes),
      ),
    );
    return UserModel.fromJson(_map);
  }

  @override
  Future<TokenModel> getJWT(String option) async {
    final _resourcePath = _jsonDir + option + _jsonExtension;
    final _data = await rootBundle.load(_resourcePath);
    final _map = json.decode(
      utf8.decode(
        _data.buffer.asUint8List(_data.offsetInBytes, _data.lengthInBytes),
      ),
    );
    return TokenModel.fromJson(_map);
  }

  @override
  Future<String> checkNickname(String nickname) async {
    return 'available';
  }

  @override
  Future<SmsAuthModel> authSms(String phone) async {
    return SmsAuthModel(authNum: '111111', authResult: 'authorized');
  }

  @override
  Future<UserModel> signUpBob(SignupModel signupModel) async {
    final _resourcePath = _jsonDir + 'mentee_login' + _jsonExtension;
    final _data = await rootBundle.load(_resourcePath);
    final _map = json.decode(
      utf8.decode(
        _data.buffer.asUint8List(_data.offsetInBytes, _data.lengthInBytes),
      ),
    );
    return UserModel.fromJson(_map);
  }

  @override
  Future<List<BobjariModel>> bobjariList(String userId, String role) async {
    final _resourcePath = _jsonDir + 'bobjari_list' + _jsonExtension;
    final _data = await rootBundle.load(_resourcePath);
    final _map = json.decode(
      utf8.decode(
        _data.buffer.asUint8List(_data.offsetInBytes, _data.lengthInBytes),
      ),
    );
    return _map
        .map<BobjariModel>((dynamic bobjari) => role == 'mentee'
            ? BobjariModel.fromJsonMentee(bobjari)
            : BobjariModel.fromJsonMentor(bobjari))
        .toList();
  }

  @override
  Future<List<MentorModel>> searchMentor(
      String keyword, String startIdx, String num) async {
    final _resourcePath = _jsonDir + 'search_mentor' + _jsonExtension;
    final _data = await rootBundle.load(_resourcePath);
    final _map = json.decode(
      utf8.decode(
        _data.buffer.asUint8List(_data.offsetInBytes, _data.lengthInBytes),
      ),
    );
    return _map
        .map<MentorModel>(
            (dynamic mentor) => MentorModel.fromJsonBobjari(mentor))
        .toList();
  }

  @override
  Future<List<ChatModel>> chatList(
      String bobjariId, String startIdx, String num) async {
    final _resourcePath = _jsonDir + 'chat_list' + _jsonExtension;
    final _data = await rootBundle.load(_resourcePath);
    final _map = json.decode(
      utf8.decode(
        _data.buffer.asUint8List(_data.offsetInBytes, _data.lengthInBytes),
      ),
    );
    return _map
        .map<ChatModel>((dynamic chat) => ChatModel.fromJson(chat))
        .toList();
  }

  @override
  Future<List<dynamic>> getMentorDetails(
      String menteeId, String mentorId) async {
    final _resourcePath = _jsonDir + 'mentor_details' + _jsonExtension;
    final _data = await rootBundle.load(_resourcePath);
    final _map = json.decode(utf8.decode(
        _data.buffer.asUint8List(_data.offsetInBytes, _data.lengthInBytes)));
    List<dynamic> _ret = [];
    _ret.add(_map[0]);
    _ret.add(_map[1]);
    return _ret;
  }

  @override
  Future<String> createLike(String menteeId, String mentorId) async {
    return 'success';
  }

  @override
  Future<int> deleteLike(String menteeId, String mentorId) async {
    return 1;
  }

  @override
  Future<List<dynamic>> likeList(String menteeId) async {
    final _resourcePath = _jsonDir + 'like_list' + _jsonExtension;
    final _data = await rootBundle.load(_resourcePath);
    final _map = json.decode(
      utf8.decode(
        _data.buffer.asUint8List(_data.offsetInBytes, _data.lengthInBytes),
      ),
    );
    return _map
        .map<LikeModel>((dynamic like) => LikeModel.fromJson(like))
        .toList();
  }

  @override
  Future<String> createBobjari(
      String menteeId, String mentorId, String proposal) async {
    return 'success';
  }

  @override
  Future<List<String>> autocompleteJob(String keyword, String num) async {
    return [];
  }

  @override
  Future<List<String>> autocompleteCorp(String keyword, String num) async {
    return [];
  }
}
