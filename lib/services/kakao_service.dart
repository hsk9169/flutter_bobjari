import 'package:bobjari_proj/models/preference/location.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bobjari_proj/models/kakao_map_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KakaoService {
  static String _restApiKey = dotenv.env['KAKAO_RESTAPI_KEY']!;
  Future<bool> checkToken() async {
    return await AuthApi.instance.hasToken();
  }

  Future<AccessTokenInfo> getExistingToken() async {
    late AccessTokenInfo res;
    try {
      res = await UserApi.instance.accessTokenInfo();
    } catch (err) {
      if (err is KakaoException && err.isInvalidTokenError()) {
        res = AccessTokenInfo(0, 0, 0);
      }
    }
    return res;
  }

  Future<User> getUserInfo() async {
    return await UserApi.instance.me();
  }

  Future<OAuthToken> getTokenWithAccount() async {
    return await UserApi.instance.loginWithKakaoAccount();
  }

  Future<OAuthToken> getTokenWithKakaoTalk() async {
    return await UserApi.instance.loginWithKakaoTalk();
  }

  Future<List<PlaceModel>> searchPlaceByKeyword(
      String keyword, GeoModel curPos) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'KakaoAK $_restApiKey'
    };
    final res = await http.get(
        Uri.parse(
            'https://dapi.kakao.com/v2/local/search/keyword.json?query=$keyword&y=${curPos.y}&x=${curPos.x}&radius=10000'),
        headers: headers);
    if (res.statusCode == 200) {
      final document = json.decode(res.body);
      return document['documents']
          .map<PlaceModel>((dynamic place) => PlaceModel.fromJson(place))
          .toList();
    } else {
      throw Exception('Failed to get kakao place list');
    }
  }
}
