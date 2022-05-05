import 'package:bobjari_proj/models/mentor/mentor.dart';
import 'package:bobjari_proj/models/sms_auth_model.dart';
import 'package:bobjari_proj/models/user_model.dart';
import 'package:bobjari_proj/models/token_model.dart';
import 'package:bobjari_proj/models/signup_model.dart';
import 'package:bobjari_proj/models/bobjari_model.dart';

abstract class Api {
  // Node Server API list
  Future<String> authEmail(String email);
  Future<UserModel> signInBob(String phone);
  Future<UserModel> signInKakao(String email);
  Future<TokenModel> getJWT(String email);
  Future<String> checkNickname(String nickname);
  Future<SmsAuthModel> authSms(String phone);
  Future<UserModel> signUpBob(SignupModel signupModel);
  Future<List<BobjariModel>> bobjariList(String userId, String role);
  Future<List<MentorModel>> searchMentor(
      String keyword, String startIdx, String num);
}
