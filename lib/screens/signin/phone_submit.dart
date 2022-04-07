//import 'package:bobjari_proj/models/sms_auth_model.dart';
//import 'package:bobjari_proj/services/real_api_service.dart';
import 'package:bobjari_proj/services/fake_api_service.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:bobjari_proj/widgets/big_button.dart';
import 'package:bobjari_proj/widgets/base_padding.dart';
import 'package:bobjari_proj/widgets/topbar_back.dart';
import 'package:bobjari_proj/widgets/top_title.dart';
import 'package:bobjari_proj/screens/screens.dart';
import 'package:bobjari_proj/widgets/base_scroller_with_back.dart';

class PhoneSubmitView extends StatefulWidget {
  const PhoneSubmitView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhoneSubmitView();
}

class _PhoneSubmitView extends State<PhoneSubmitView> {
  //final RealApiService _apiService = RealApiService();
  final FakeApiService _apiService = FakeApiService();
  final TextEditingController _textController =
      TextEditingController(text: '1234567890');
  bool _validate = false;

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
    return BaseScrollerWithBack(
        appBar: TopBarBack(press: _goBack),
        child: Column(children: [
          BasePadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const TopTitle(titleText: ['등록된 전화번호로', '인증번호를 요청해주세요.']),
                TextField(
                  decoration: const InputDecoration(hintText: '전화번호를 입력해주세요.'),
                  controller: _textController,
                  keyboardType: TextInputType.phone,
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
                        title: '인증번호 요청',
                        txtColor: Colors.white,
                        press: _validate ? _submitPhone : null)))));
  }
}
