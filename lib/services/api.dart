import 'package:bobjari_proj/models/user_model.dart';

abstract class Api {
  // Node Server API list
  Future<UserModel> signInBob(String email);
  Future<String> checkNickname(String nickname);
}
