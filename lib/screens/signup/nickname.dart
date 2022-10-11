import 'dart:async';
import 'package:bobjari_proj/const/colors.dart';
import 'package:bobjari_proj/widgets/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/signup_provider.dart';
import 'package:bobjari_proj/screens/signup/age.dart';
import 'package:bobjari_proj/services/real_api_service.dart';
import 'package:bobjari_proj/services/fake_api_service.dart';

class SignupProfileNicknameView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupProfileNicknameView();
}

class _SignupProfileNicknameView extends State<SignupProfileNicknameView> {
  final RealApiService _realApiService = RealApiService();
  //final FakeApiService _fakeApiService = FakeApiService();
  final _textController = TextEditingController(text: '테스트계정2');
  bool _validate = false;
  bool _duplicate = false;
  Timer? _timer;
  String _nickname = '';
  late ScrollController _scrollController;

  @override
  void initState() {
    _textValidate();
    _textController.addListener(_onChange);
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _textController.dispose();
    super.dispose();
  }

  void _initTimer() {
    _timer = Timer(const Duration(milliseconds: 100), _expired);
  }

  void _expired() async {
    final _check = await _realApiService.checkNickname(_nickname);
    //final _check = await _fakeApiService.checkNickname(_nickname);
    if (_check == 'available') {
      setState(() {
        _duplicate = false;
      });
    } else if (_check == 'duplicates') {
      setState(() {
        _duplicate = true;
      });
    }
    _timer?.cancel();
  }

  void _onChange() {
    _textValidate();
  }

  void _textValidate() {
    if (_textController.text.length > 4) {
      _timer?.cancel();
      _initTimer();
      setState(() {
        _nickname = _textController.text;
        _validate = true;
      });
    } else {
      setState(() {
        _validate = false;
      });
    }
  }

  void _pressBack() {
    Navigator.pop(context);
  }

  void _pressNext() {
    Provider.of<Signup>(context, listen: false).nickname = _textController.text;
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SignupProfileAgeView();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return SignupForm(
        isbasePadding: true,
        topTitle: const ['밥자리에서 사용할', '닉네임을 설정해주세요.'],
        child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(children: [
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: '닉네임 입력',
                  helperText: !_duplicate ? '사용 가능한 닉네임입니다.' : null,
                  errorText: !_validate
                      ? '닉네임은 5글자 이상이어야 합니다.'
                      : _duplicate
                          ? '중복되는 닉네임이 존재합니다.'
                          : null,
                ),
                autofocus: true,
              ),
            ])),
        btn2Title: '다 음',
        btn2Color: BobColors.mainColor,
        pressBack: _pressBack,
        pressBtn2: _validate && !_duplicate ? () => _pressNext() : null);
  }
}
