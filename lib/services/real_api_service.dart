import 'dart:convert';
import 'package:bobjari_proj/models/signup.dart';
import 'package:bobjari_proj/models/token_model.dart';
import 'package:http/http.dart' as http;
import 'package:bobjari_proj/const/api_calls.dart';
import 'package:bobjari_proj/services/api.dart';
import 'package:bobjari_proj/models/user_model.dart';

class RealApiService implements Api {
  String serverUri = 'localhost:8000';

  @override
  Future<String> authEmail(String email) async {
    final res = await http.post(Uri.http(serverUri, ApiCalls.emailAuth),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
        }));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Failed to Auth Email');
    }
  }

  @override
  Future<UserModel> signInBob(String email) async {
    final res = await http.post(Uri.http(serverUri, ApiCalls.signinBob),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
        }));
    if (res.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to Sign In with Bob');
    }
  }

  @override
  Future<TokenModel> getJWT(String email) async {
    final res = await http.get(
        Uri.http(serverUri, ApiCalls.getToken, {'email': email}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        });
    if (res.statusCode == 200) {
      return TokenModel.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to Get JWT');
    }
  }

  @override
  Future<String> checkNickname(String nickname) async {
    final res = await http.get(
      Uri.http(serverUri, ApiCalls.checkNickname, {
        'nickname': nickname,
      }),
      headers: <String, String>{
        'Content-Type': 'text/html; charset=utf-8',
      },
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Failed to Check Nickname');
    }
  }

  //@override
  //Future<UserModel> signUpBob(SignupModel model) async {
  //  var res = http.MultipartRequest('POST', Uri.parse(serverUri));
  //  res.files.add(await http.MultipartFile('img', ))
//
  //}
}
