import 'package:bobjari_proj/widgets/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:bobjari_proj/const/colors.dart';
import 'package:bobjari_proj/providers/signup_provider.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/session_provider.dart';
import 'package:bobjari_proj/routes/routes.dart';
import 'package:bobjari_proj/screens/signup/mentor/authEmailCheck.dart';
import 'package:bobjari_proj/const/etc.dart';
import './schedule.dart';

class SignupMentorAuthEmailInputView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupMentorAuthEmailInputView();
}

class _SignupMentorAuthEmailInputView
    extends State<SignupMentorAuthEmailInputView> {
  final _textController = TextEditingController(text: 'test@naver.com');
  String _email = '';

  @override
  void initState() {
    _textController.addListener(_onChange);
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onChange() {
    setState(() => _email = _textController.text);
  }

  void _pressBack() {
    Navigator.pop(context, false);
  }

  void _pressNext() {
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
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.cancel,
                    size: MediaQuery.of(context).size.width * 0.05,
                    color: Colors.grey),
                onPressed: () => _textController.text = '',
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: BobColors.mainColor),
                  borderRadius: BorderRadius.circular(10)),
              hintText: '이메일 주소 입력',
              //helperText: !_duplicate ? '사용 가능한 닉네임입니다.' : null,
              //errorText: !_validate
              //    ? '닉네임은 5글자 이상이어야 합니다.'
              //    : _duplicate
              //        ? '중복되는 닉네임이 존재합니다.'
              //        : null,
            ),
            autofocus: true,
          ),
        ),
        topTitle: const ['인증을 위해', '회사 메일을 입력해주세요.'],
        pressBack: _pressBack,
        btn2Title: '인증번호 보내기',
        btn2Color: BobColors.mainColor,
        pressBtn2: _email == '' ? null : () => _pressNext());
  }
}
