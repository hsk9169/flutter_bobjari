import 'dart:convert';
import 'dart:io';
import 'package:bobjari_proj/models/signup_model.dart';
import 'package:bobjari_proj/models/sms_auth_model.dart';
import 'package:bobjari_proj/models/token_model.dart';
import 'package:http/http.dart' as http;
import 'package:bobjari_proj/const/api_calls.dart';
import 'package:bobjari_proj/services/api.dart';
import 'package:bobjari_proj/models/user_model.dart';
import 'package:bobjari_proj/models/bobjari_model.dart';
import 'package:bobjari_proj/models/mentor/mentor.dart';

class RealApiService implements Api {
  @override
  Future<String> authEmail(String email) async {
    final res = await http.post(
        Uri(
            scheme: 'http',
            //host: '172.20.10.12',
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
            //host: '172.20.10.12',
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
  Future<UserModel> signInKakao(String email) async {
    final res = await http.post(
        Uri(
            scheme: 'http',
            host: 'localhost',
            //host: '172.20.10.12',
            port: 8000,
            path: ApiCalls.signinKakao),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
        }));
    if (res.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(res.body));
    } else if (res.statusCode == 204) {
      return UserModel();
    } else {
      throw Exception('Failed to Sign In witn Kakao');
    }
  }

  @override
  Future<TokenModel> getJWT(String email) async {
    final res = await http.get(
        Uri(
            scheme: 'http',
            host: 'localhost',
            //host: '172.20.10.12',
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
          //host: '172.20.10.12',
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
    var req = http.MultipartRequest(
        'POST', Uri.parse('http://localhost:8000' + ApiCalls.userJoin));
    //var req = http.MultipartRequest(
    //    'POST', Uri.parse('http://172.20.10.12:8000' + ApiCalls.userJoin));
    var image = http.MultipartFile.fromBytes('img', model.image,
        filename: 'profileImage.jpg');
    req.files.add(image);

    if (model.email != null) {
      req.fields['email'] = json.encode(model.email!.toString());
    }
    if (model.phone != null) {
      req.fields['phone'] = json.encode(model.phone!.toString());
    }
    req.fields['age'] = json.encode(model.age);
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

  @override
  Future<List<BobjariModel>> bobjariList(String userId, String role) async {
    final res = await http.get(
      Uri(
        scheme: 'http',
        host: 'localhost',
        //host: '172.20.10.12',
        port: 8000,
        path: role == 'mentee'
            ? ApiCalls.getMenteeBobjari
            : ApiCalls.getMentorBobjari,
        queryParameters:
            role == 'mentee' ? {'menteeId': userId} : {'mentorId': userId},
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    print(res.body);
    if (res.statusCode == 200) {
      return jsonDecode(res.body)
          .map<BobjariModel>((dynamic bobjari) => role == 'mentee'
              ? BobjariModel.fromJsonMentee(bobjari)
              : BobjariModel.fromJsonMentor(bobjari))
          .toList();
    } else {
      throw Exception('Failed to Get Bobjari List');
    }
  }

  @override
  Future<List<MentorModel>> searchMentor(
      String keyword, String startIdx, String num) async {
    final res = await http.get(
      Uri(
          scheme: 'http',
          host: 'localhost',
          //host: '172.20.10.12',
          port: 8000,
          path: ApiCalls.searchMentor,
          queryParameters: {
            'keyword': keyword,
            'startIdx': startIdx,
            'num': num,
          }),
      headers: {
        HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body)
          .map<MentorModel>(
              (dynamic mentor) => MentorModel.fromJsonBobjari(mentor))
          .toList();
    } else {
      throw Exception('Failed to Get Mentor Search List');
    }
  }
}
