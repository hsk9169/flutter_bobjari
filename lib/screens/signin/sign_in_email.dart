import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/widgets/big_button.dart';
import 'package:bobjari_proj/widgets/base_padding.dart';
import 'package:bobjari_proj/widgets/topbar_back.dart';
import 'package:bobjari_proj/widgets/top_title.dart';
import 'package:bobjari_proj/services/real_api_service.dart';
import 'package:bobjari_proj/routes/routes.dart';
import 'package:bobjari_proj/providers/session_provider.dart';

class SignInBobView extends StatefulWidget {
  const SignInBobView({Key? key, required this.email, required this.authNum})
      : super(key: key);
  final String email;
  final String authNum;

  @override
  State<StatefulWidget> createState() => _SignInBobView();
}

class _SignInBobView extends State<SignInBobView> {
  final RealApiService _realApiService = RealApiService();

  late TextEditingController _textController;

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

  void _signInBob() async {
    final _jwt;
    final _user;
    if (widget.authNum == _textController.text) {
      final _user = await _realApiService.signInBob(widget.email);
      if (_user.profile?.email == widget.email) {
        _jwt = await _realApiService.getJWT(_user.profile?.email as String);
        Provider.of<Session>(context, listen: false).user = _user;
        Provider.of<Session>(context, listen: false).token = _jwt;
      } else {
        throw Exception('email not matched');
      }
    } else {
      throw Exception('authNum not matched');
    }
    Navigator.pushNamed(context, Routes.SERVICE);
    Navigator.pushNamedAndRemoveUntil(
        context, Routes.SERVICE, (Route<dynamic> route) => false);
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height),
                    child: Column(children: [
                      TopBarBack(press: _goBack),
                      BasePadding(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const TopTitle(
                                titleText: ['이메일로 받은', '인증번호를 입력해주세요.']),
                            TextField(
                              decoration:
                                  const InputDecoration(hintText: '인증번호 입력'),
                              controller: _textController,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      )
                    ])))),
        bottomSheet: BasePadding(
            child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: BigButton(
                        btnColor: Colors.black,
                        title: '인증번호 확인',
                        txtColor: Colors.white,
                        press: () {
                          _signInBob();
                        })))));
  }
}
