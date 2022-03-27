import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bobjari_proj/const/api_calls.dart';
import 'package:bobjari_proj/services/api.dart';
import 'package:bobjari_proj/models/user_model.dart';

class RealApiService implements Api {
  String serverUri = 'http://localhost:8000';

  @override
  Future<UserModel> signInBob(String email) async {
    final res = await http.post(Uri.parse(serverUri + ApiCalls.signinBob),
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
  Future<String> checkNickname(String nickname) async {
    final res = await http.get(
      Uri(path: serverUri + ApiCalls.checkNickname, queryParameters: {
        'nickname': nickname,
      }),
      headers: <String, String>{
        'Content-Type': 'text/html; charset=utf-8',
      },
    );
    if (res.statusCode == 200) {
      return res.body;
    } else {
      throw Exception('Failed to Check Nickname');
    }
  }
}
