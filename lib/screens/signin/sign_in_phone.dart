import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/signup_provider.dart';
import 'package:bobjari_proj/providers/session_provider.dart';
import 'package:bobjari_proj/widgets/big_button.dart';
import 'package:bobjari_proj/widgets/base_scroller_with_back.dart';
import 'package:bobjari_proj/widgets/base_padding.dart';
import 'package:bobjari_proj/widgets/topbar_back.dart';
import 'package:bobjari_proj/widgets/top_title.dart';
import 'package:bobjari_proj/services/real_api_service.dart';
import 'package:bobjari_proj/routes/routes.dart';

class SignInPhoneView extends StatefulWidget {
  const SignInPhoneView({Key? key, required this.phone, required this.authNum})
      : super(key: key);
  final String phone;
  final String authNum;

  @override
  State<StatefulWidget> createState() => _SignInPhonelView();
}

class _SignInPhonelView extends State<SignInPhoneView> {
  final RealApiService _realApiService = RealApiService();
  late TextEditingController _textController;
  bool _validate = true;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.authNum);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _signInPhone() async {
    var _jwt;
    var _user;
    if (widget.authNum == _textController.text) {
      setState(() {
        _validate = true;
      });
      _user = await _realApiService.signInBob(widget.phone);
      if (_user.profile?.phone == widget.phone) {
        _jwt = await _realApiService.getJWT(_user.profile?.phone as String);
        Provider.of<Session>(context, listen: false).user = _user;
        Provider.of<Session>(context, listen: false).token = _jwt;
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.SERVICE, (Route<dynamic> route) => false);
      } else if (_user.userId == null) {
        Provider.of<Signup>(context, listen: false).phone = widget.phone;
        Navigator.pushNamed(context, Routes.SIGNUP);
      } else {
        throw Exception('email not matched');
      }
    } else {
      setState(() {
        _validate = false;
      });
    }
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScrollerWithBack(
        appBar: TopBarBack(press: _goBack),
        child: Column(children: [
          BasePadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const TopTitle(titleText: ['휴대전화로 받은', '인증번호를 입력해주세요.']),
                TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: '인증번호 입력',
                    errorText: !_validate ? '인증번호가 맞지 않습니다.' : null,
                  ),
                  controller: _textController,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          )
        ]),
        bottomSheet: BasePadding(
            child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: BigButton(
                        btnColor: Colors.black,
                        title: '인증번호 확인',
                        txtColor: Colors.white,
                        press: () {
                          _signInPhone();
                        })))));
  }
}