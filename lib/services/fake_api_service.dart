import 'dart:convert';
import 'package:bobjari_proj/models/token_model.dart';
import 'package:bobjari_proj/services/api.dart';
import 'package:flutter/services.dart';
import 'package:bobjari_proj/models/user_model.dart';

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
}
