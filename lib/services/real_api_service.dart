import 'dart:convert';
import 'package:bobjari_proj/models/signup_model.dart';
import 'package:bobjari_proj/models/sms_auth_model.dart';
import 'package:bobjari_proj/models/token_model.dart';
import 'package:http/http.dart' as http;
import 'package:bobjari_proj/const/api_calls.dart';
import 'package:bobjari_proj/services/api.dart';
import 'package:bobjari_proj/models/user_model.dart';

class RealApiService implements Api {
  @override
  Future<String> authEmail(String email) async {
    final res = await http.post(
        Uri(
            scheme: 'http',
            //iphone
            //host: '172.20.10.12',
            //vm
            host: 'localhost',
            port: 8000,
            path: ApiCalls.emailAuth),
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
  Future<UserModel> signInBob(String phone) async {
    final res = await http.post(
        Uri(
            scheme: 'http',
            host: 'localhost',
            port: 8000,
            path: ApiCalls.signinBob),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(<String, String>{
          'phone': phone,
        }));
    if (res.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(res.body));
    } else if (res.statusCode == 204) {
      return UserModel();
    } else {
      throw Exception('Failed to Sign In with Bob');
    }
  }

  @override
  Future<TokenModel> getJWT(String email) async {
    final res = await http.get(
        Uri(
            scheme: 'http',
            //host: 'localhost',
            host: '172.20.10.12',
            port: 8000,
            path: ApiCalls.getToken,
            queryParameters: {'email': email}),
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
      Uri(
          scheme: 'http',
          host: 'localhost',
          port: 8000,
          path: ApiCalls.checkNickname,
          queryParameters: {'nickname': nickname}),
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

  @override
  Future<SmsAuthModel> authSms(String phone) async {
    final res = await http.post(
        Uri(
            scheme: 'http',
            host: 'localhost',
            port: 8000,
            path: ApiCalls.smsAuth,
            queryParameters: {'phone': phone}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(<String, String>{
          'phone': phone,
        }));
    if (res.statusCode == 200) {
      return SmsAuthModel.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to Auth SMS');
    }
  }

  @override
  Future<UserModel> signUpBob(SignupModel model) async {
    //iphone
    //host: '172.20.10.12',
    //var req = http.MultipartRequest(
    //    'POST', Uri.parse('http://localhost:8000' + ApiCalls.userJoin));
    var req = http.MultipartRequest(
        'POST', Uri.parse('http://172.20.10.12:8000' + ApiCalls.userJoin));
    var image = http.MultipartFile.fromBytes('img', model.image,
        filename: 'profileImage.jpg');
    req.files.add(image);
    if (model.email != null) req.fields['email'] = model.email!;
    if (model.phone != null) req.fields['phone'] = model.phone!;
    req.fields['age'] = model.age.toString();
    req.fields['gender'] = json.encode(model.gender);
    req.fields['nickname'] = json.encode(model.nickname);
    req.fields['role'] = json.encode(model.role);
    final res = await req.send();
    var streamRes = await http.Response.fromStream(res);
    if (res.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(streamRes.body));
    } else {
      throw Exception('Failed to Sign In with Bob');
    }
  }
}
