import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/signup_provider.dart';
import 'package:bobjari_proj/providers/session_provider.dart';
import 'package:bobjari_proj/widgets/big_button.dart';
import 'package:bobjari_proj/widgets/signup_form.dart';
import 'package:bobjari_proj/widgets/base_padding.dart';
import 'package:bobjari_proj/widgets/topbar_back.dart';
import 'package:bobjari_proj/widgets/top_title.dart';
import 'package:bobjari_proj/services/real_api_service.dart';
import 'package:bobjari_proj/services/fake_api_service.dart';
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
  final FakeApiService _fakeApiService = FakeApiService();
  late TextEditingController _textController;
  bool _validate = false;
  late FocusNode _textFocus;

  ValueNotifier<List<String>> _authNum =
      ValueNotifier<List<String>>(['', '', '', '', '', '']);

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.authNum);
    _textValidate();
    _textController.addListener(_onChange);
    _textFocus = FocusNode();
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocus.dispose();
    super.dispose();
  }

  void _onChange() {
    _textValidate();
  }

  void _textValidate() {
    String num = '';
    int i;
    for (i = 0; i < _authNum.value.length; i++) {
      if (_authNum.value[i] != '') {
        num += _authNum.value[i];
      }
    }
    if (num.length != _textController.text.length) {
      if (num.length < _textController.text.length) {
        for (i = 0; i < _textController.text.length; i++) {
          setState(() {
            _authNum.value[i] = _textController.text.substring(i, i + 1);
          });
        }
      } else {
        for (i = 0; i < _textController.text.length; i++) {
          setState(() {
            _authNum.value[i] = _textController.text.substring(i, i + 1);
          });
        }
        for (i = _textController.text.length; i < num.length; i++) {
          setState(() {
            _authNum.value[i] = '';
          });
        }
      }
    }

    if (widget.authNum == _textController.text) {
      setState(() {
        _validate = true;
      });
    } else {
      setState(() {
        _validate = false;
      });
    }
  }

  void _signInPhone() async {
    var _jwt;
    var _user;

    _user = await _realApiService.signInBob(widget.phone);
    //_user = await _fakeApiService.signInBob('mentee_login');
    Provider.of<Signup>(context, listen: false).phone = widget.phone;
    if (_user.profile?.phone == widget.phone) {
      //_jwt = await _realApiService.getJWT(_user.profile?.phone as String);
      _jwt = await _fakeApiService.getJWT('token');
      Provider.of<Session>(context, listen: false).user = _user;
      Provider.of<Session>(context, listen: false).token = _jwt;
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.SERVICE, (Route<dynamic> route) => false);
    } else if (_user.userId == null) {
      Provider.of<Signup>(context, listen: false).phone = widget.phone;
      Navigator.pushNamed(context, Routes.SIGNUP);
    } else {
      throw Exception('phone not matched');
    }
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SignupForm(
        isbasePadding: false,
        topTitle: const ['휴대전화로 받은', '인증번호를 입력해주세요.'],
        pressBack: _goBack,
        child: BasePadding(
            child: GestureDetector(
                onTap: () => _textFocus.requestFocus(),
                child: Stack(children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * 0.05,
                      child: TextField(
                          controller: _textController,
                          maxLength: 6,
                          keyboardType: TextInputType.number,
                          focusNode: _textFocus,
                          onTap: null,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            counterText: "",
                          ),
                          showCursor: false,
                          autofocus: true)),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.1,
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.04,
                        right: MediaQuery.of(context).size.width * 0.04,
                      ),
                      child: ValueListenableBuilder(
                          builder: (BuildContext context, List<String> value,
                              Widget? child) {
                            return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                    6,
                                    (idx) => value[idx] == ''
                                        ? Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.grey),
                                          )
                                        : Text(value[idx],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.1,
                                                fontWeight: FontWeight.bold))));
                          },
                          valueListenable: _authNum))
                ]))),
        btn1Title: '인증번호 확인',
        btn1Color: Colors.black,
        pressBtn1: _validate ? _signInPhone : null);
  }
}
