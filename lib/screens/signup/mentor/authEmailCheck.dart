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
  final String authNum;
  SignupMentorAuthEmailCheckView({Key? key, required this.authNum});
  @override
  State<StatefulWidget> createState() => _SignupMentorAuthEmailCheckView();
}

class _SignupMentorAuthEmailCheckView
    extends State<SignupMentorAuthEmailCheckView> {
  int _curFocus = 0;
  late FocusNode _textFocus;
  ValueNotifier<List<String>> _authNum =
      ValueNotifier<List<String>>(['', '', '', '', '', '']);

  TextEditingController _textController = TextEditingController();

  bool _validate = false;

  @override
  void initState() {
    _textController.addListener(_onChange);
    _textFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocus.dispose();
    super.dispose();
  }

  void _onChange() {
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

  void _pressBack() {
    Navigator.pop(context, false);
  }

  void _pressNext() {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SignupForm(
        isbasePadding: true,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                              6,
                              (idx) => value[idx] == ''
                                  ? Container(
                                      width: MediaQuery.of(context).size.width *
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
          ]),
        ),
        topTitle: const ['회사 메일로 받은', '인증번호를 입력해주세요.'],
        pressBack: _pressBack,
        btn2Title: '인증하기',
        btn2Color: BobColors.mainColor,
        pressBtn2: _validate ? _pressNext : null);
  }
}
