import 'package:bobjari_proj/services/fake_api_service.dart';
import 'package:flutter/material.dart';
import 'package:bobjari_proj/widgets/big_button.dart';
import 'package:bobjari_proj/widgets/base_padding.dart';
import 'package:bobjari_proj/widgets/topbar_back.dart';
import 'package:bobjari_proj/widgets/top_title.dart';
import 'package:bobjari_proj/screens/screens.dart';
import 'package:bobjari_proj/widgets/signup_form.dart';

class PhoneSubmitView extends StatefulWidget {
  const PhoneSubmitView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhoneSubmitView();
}

class _PhoneSubmitView extends State<PhoneSubmitView> {
  //final RealApiService _apiService = RealApiService();
  final FakeApiService _apiService = FakeApiService();
  final TextEditingController _textController =
      // mentee
      TextEditingController(text: '01045619502');
  // mentor
  //TextEditingController(text: '01096658506');
  //TextEditingController(text: 'FibNaJXq@gmail.com');
  bool _validate = false;
  String _phone = '';

  @override
  void initState() {
    super.initState();
    _textValidate();
    _textController.addListener(_onChange);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onChange() {
    _textValidate();
  }

  void _textValidate() {
    if (_textController.text.length > 9) {
      setState(() {
        _phone = _textController.text;
        _validate = true;
      });
    } else {
      setState(() {
        _validate = false;
      });
    }
  }

  void _submitPhone() async {
    String _phone = _textController.text;
    final _res = await _apiService.authSms(_textController.text);
    if (_res.authResult == 'authorized') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SignInPhoneView(phone: _phone, authNum: _res.authNum)));
    } else {
      throw Exception('SMS Unauthorized');
    }
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SignupForm(
        isbasePadding: false,
        topTitle: const ['등록된 전화번호로', '인증번호를 요청해주세요.'],
        pressBack: _goBack,
        child: Column(children: [
          BasePadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  decoration: InputDecoration(
                      hintText: '전화번호를 입력해주세요.',
                      suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.cancel),
                          color: Colors.grey,
                          onPressed: () => setState(() {
                                _textController.text = '';
                              }))),
                  controller: _textController,
                  keyboardType: TextInputType.phone,
                  autofocus: true,
                ),
              ],
            ),
          )
        ]),
        btn1Title: '인증번호 요청',
        btn1Color: Colors.black,
        pressBtn1: _validate ? _submitPhone : null);
  }
}
