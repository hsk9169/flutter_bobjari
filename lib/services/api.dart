import 'package:bobjari_proj/models/sms_auth_model.dart';
import 'package:bobjari_proj/models/user_model.dart';
import 'package:bobjari_proj/models/token_model.dart';
import 'package:bobjari_proj/models/signup_model.dart';

abstract class Api {
  // Node Server API list
  Future<String> authEmail(String email);
  Future<UserModel> signInBob(String email);
  Future<TokenModel> getJWT(String email);
  Future<String> checkNickname(String nickname);
  Future<SmsAuthModel> authSms(String phone);
  Future<UserModel> signUpBob(SignupModel signupModel);
}
