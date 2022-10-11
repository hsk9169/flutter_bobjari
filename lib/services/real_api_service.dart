import 'dart:convert';
import 'dart:io';
import 'package:bobjari_proj/models/mentor/details.dart';
import 'package:bobjari_proj/models/signup_model.dart';
import 'package:bobjari_proj/models/sms_auth_model.dart';
import 'package:bobjari_proj/models/token_model.dart';
import 'package:http/http.dart' as http;
import 'package:bobjari_proj/const/api_calls.dart';
import 'package:bobjari_proj/services/api.dart';
import 'package:bobjari_proj/models/user_model.dart';
import 'package:bobjari_proj/models/bobjari_model.dart';
import 'package:bobjari_proj/models/mentor/mentor.dart';
import 'package:bobjari_proj/models/chat_model.dart';
import 'package:bobjari_proj/models/like_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RealApiService implements Api {
  //var _hostAddress = '18.191.220.124';
  var _hostAddress = '172.20.10.12';
  //var _hostAddress = 'localhost';
  //var _hostAddress = '172.30.1.24';

  @override
  Future<String> authEmail(String email) async {
    final res = await http.post(
        Uri(
            scheme: 'http',
            host: _hostAddress,
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
            host: _hostAddress,
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
            host: _hostAddress,
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
            host: _hostAddress,
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
          host: _hostAddress,
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
            host: _hostAddress,
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
        'POST', Uri.parse('http://${_hostAddress}:8000' + ApiCalls.userJoin));
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
    req.fields['deviceToken'] = json.encode(model.deviceToken);
    if (model.interests != null) {
      req.fields['interests'] = json.encode(model.interests);
    }
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
        host: _hostAddress,
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
          host: _hostAddress,
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

  @override
  Future<List<ChatModel>> chatList(
      String bobjariId, String startIdx, String num) async {
    final res = await http.get(
        Uri(
            scheme: 'http',
            host: _hostAddress,
            port: 8000,
            path: ApiCalls.getMessage,
            queryParameters: {
              'bobjariId': bobjariId,
              'startIdx': startIdx,
              'num': num,
            }),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
          'Content-Type': 'application/json; charset=utf-8',
        });
    if (res.statusCode == 200) {
      return jsonDecode(res.body)
          .map<ChatModel>((dynamic chat) => ChatModel.fromJson(chat))
          .toList();
    } else {
      throw Exception('Failed to Get Chat List');
    }
  }

  @override
  Future<List<dynamic>> getMentorDetails(
      String menteeId, String mentorId) async {
    final res = await http.get(
        Uri(
            scheme: 'http',
            host: _hostAddress,
            port: 8000,
            path: ApiCalls.mentor,
            queryParameters: menteeId == 'none'
                ? {
                    'mentorId': mentorId,
                  }
                : {
                    'menteeId': menteeId,
                    'mentorId': mentorId,
                  }),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
          'Content-Type': 'application/json; charset=utf-8',
        });
    if (res.statusCode == 200) {
      List<dynamic> _ret = [];
      _ret.add(MentorModel.fromJsonBobjari(jsonDecode(res.body)[0]));
      _ret.add(jsonDecode(res.body)[1]);
      return _ret;
    } else {
      throw Exception('Failed to Get Mentor Details');
    }
  }

  @override
  Future<String> createLike(String menteeId, String mentorId) async {
    final res = await http.post(
        Uri(
            scheme: 'http',
            host: _hostAddress,
            port: 8000,
            path: ApiCalls.like),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(<String, String>{
          'menteeId': menteeId,
          'mentorId': mentorId,
        }));
    if (res.statusCode == 200) {
      return res.body;
    } else {
      throw Exception('Failed to Auth Email');
    }
  }

  @override
  Future<int> deleteLike(String menteeId, String mentorId) async {
    final res = await http.delete(
        Uri(
            scheme: 'http',
            host: _hostAddress,
            port: 8000,
            path: ApiCalls.like),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(<String, String>{
          'menteeId': menteeId,
          'mentorId': mentorId,
        }));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Failed to Auth Email');
    }
  }

  @override
  Future<List<LikeModel>> likeList(String menteeId) async {
    final res = await http.get(
        Uri(
            scheme: 'http',
            host: _hostAddress,
            port: 8000,
            path: ApiCalls.like,
            queryParameters: {
              'menteeId': menteeId,
            }),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
          'Content-Type': 'application/json; charset=utf-8',
        });
    if (res.statusCode == 200) {
      return jsonDecode(res.body)
          .map<LikeModel>((dynamic chat) => LikeModel.fromJson(chat))
          .toList();
    } else {
      throw Exception('Failed to Get Like Mentors');
    }
  }

  @override
  Future<String> createBobjari(
      String menteeId, String mentorId, String proposal) async {
    final res = await http.post(
        Uri(
          scheme: 'http',
          host: _hostAddress,
          port: 8000,
          path: ApiCalls.bobjari,
        ),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(<String, String>{
          'menteeId': menteeId,
          'mentorId': mentorId,
          'proposal': proposal,
        }));
    if (res.statusCode == 200) {
      return res.body;
    } else {
      throw Exception('Failed to Create Bobjari');
    }
  }

  @override
  Future<List<String>> autocompleteJob(String keyword, String num) async {
    final res = await http.get(
        Uri(
            scheme: 'http',
            host: _hostAddress,
            port: 8000,
            path: ApiCalls.autocompleteJob,
            queryParameters: {
              'keyword': keyword,
              'num': num,
            }),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
          'Content-Type': 'application/json; charset=utf-8',
        });
    if (res.statusCode == 200) {
      return jsonDecode(res.body)
          .map<String>((dynamic el) => el['job'] as String)
          .toList();
    } else {
      throw Exception('Failed to Get Job List');
    }
  }

  @override
  Future<List<String>> autocompleteCorp(String keyword, String num) async {
    final res = await http.get(
        Uri(
            scheme: 'http',
            host: _hostAddress,
            port: 8000,
            path: ApiCalls.autocompleteCorp,
            queryParameters: {
              'keyword': keyword,
              'num': num,
            }),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
          'Content-Type': 'application/json; charset=utf-8',
        });
    if (res.statusCode == 200) {
      return jsonDecode(res.body)
          .map<String>((dynamic el) => el['corp'] as String)
          .toList();
    } else {
      throw Exception('Failed to Get Corp List');
    }
  }
}
