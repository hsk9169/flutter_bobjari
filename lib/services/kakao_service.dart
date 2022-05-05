import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoService {
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
}
