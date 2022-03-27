import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/widgets/big_button.dart';
import 'package:bobjari_proj/widgets/base_padding.dart';
import 'package:bobjari_proj/widgets/topbar_back.dart';
import 'package:bobjari_proj/widgets/top_title.dart';
import 'package:bobjari_proj/services/real_api_service.dart';
import 'package:bobjari_proj/providers/session_provider.dart';

class SignInBobView extends StatefulWidget {
  const SignInBobView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignInBobView();
}

class _SignInBobView extends State<SignInBobView> {
  final RealApiService _realApiService = RealApiService();
  final _textController = TextEditingController();

  String _email = '';

  @override
  void initState() {
    super.initState();
    _textController.addListener(_saveText);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _saveText() {
    _email = _textController.text;
  }

  void _submitEmail() async {
    final res = await _realApiService.signInBob(_email);
    Provider.of<Session>(context, listen: false).user = res;
    //Navigator.pushNamed(context, Routes.SERVICE);
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      TopBarBack(press: _goBack),
      BasePadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(15)),
            const TopTitle(titleText: ['등록된 이메일로', '인증번호를 요청해주세요.']),
            const Padding(padding: EdgeInsets.all(10)),
            TextField(
              decoration:
                  const InputDecoration(hintText: 'example@bobjari.com'),
              controller: _textController,
            ),
            const Padding(padding: EdgeInsets.all(10)),
            BigButton(
                btnColor: Colors.black,
                title: '인증번호 요청',
                txtColor: Colors.white,
                press: () {
                  _submitEmail();
                })
          ],
        ),
      )
    ])));
  }
}
