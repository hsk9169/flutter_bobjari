import 'package:bobjari_proj/widgets/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:bobjari_proj/const/colors.dart';
import 'package:bobjari_proj/providers/signup_provider.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/session_provider.dart';
import 'package:bobjari_proj/routes/routes.dart';
import 'package:bobjari_proj/const/etc.dart';
import './schedule.dart';

class SignupMentorAuthEmailCheckView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupMentorAuthEmailCheckView();
}

class _SignupMentorAuthEmailCheckView
    extends State<SignupMentorAuthEmailCheckView> {
  int _curFocus = 0;
  List<String> _authNum = [];
  List<FocusNode> _textFocusList = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode()
  ];
  List<TextEditingController> _textControllerList = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void initState() {
    for (var i = 0; i < _textControllerList.length; i++) {
      _textControllerList[i].addListener(_onChange);
    }
    super.initState();
  }

  @override
  void dispose() {
    for (var i = 0; i < _textControllerList.length; i++) {
      try {
        _textControllerList[i].dispose();
      } catch (e) {
        print(e);
      }
      _textFocusList[i].dispose();
    }
    super.dispose();
  }

  void _onChange() {
    if (_textControllerList[_curFocus].text != '') {
      setState(() => _curFocus++);
      _textFocusList[_curFocus].requestFocus();
    } else if (_curFocus > 0) {
      setState(() => _curFocus--);
      _textFocusList[_curFocus].requestFocus();
    }
  }

  void _pressBack() {
    Navigator.pop(context, false);
  }

  void _pressNext(bool isValue) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SignupMentorAuthEmailCheckView()));
  }

  @override
  Widget build(BuildContext context) {
    return SignupForm(
        isbasePadding: true,
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
                children: List.generate(
                    _textFocusList.length,
                    (idx) => SizedBox(
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: TextField(
                            controller: _textControllerList[idx],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: BobColors.mainColor),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            autofocus: idx == 0 ? true : false,
                            focusNode: _textFocusList[_curFocus]))))),
        topTitle: const ['회사 메일로 받은', '인증번호를 입력해주세요.'],
        pressBack: _pressBack,
        btn2Title: '인증하기',
        btn2Color: BobColors.mainColor,
        pressBtn2: () => _pressNext(false));
  }
}
