import 'package:bobjari_proj/widgets/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/signup_provider.dart';
import 'package:bobjari_proj/screens/signup/age.dart';
import 'package:bobjari_proj/services/real_api_service.dart';

class SignupProfileRoleView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupProfileRoleView();
}

class _SignupProfileRoleView extends State<SignupProfileRoleView> {
  final RealApiService _realApiService = RealApiService();
  var _role = '';

  void _pressBack() {
    Navigator.pop(context);
  }

  void _pressNext() {
    Provider.of<Signup>(context, listen: false).role = 'mentee';
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SignupProfileAgeView();
    }));
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Signup>(context).show();
    return SignupForm(
        topTitle: const ['회원가입 완료!', '원하는 활동을 선택해주세요.'],
        child: Center(
            child: Column(children: [
          const Padding(padding: EdgeInsets.all(20)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Container(
                width: (MediaQuery.of(context).size.width) * 0.4,
                height: (MediaQuery.of(context).size.height) * 0.3,
                child: Row(children: [
                  Container(
                    width: (MediaQuery.of(context).size.width) * 0.2,
                    height: (MediaQuery.of(context).size.height) * 0.15,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/image/'))),
                  )
                ]))
          ])
        ])),
        btnTitle: '가입하기',
        pressBack: _pressBack,
        pressNext: _role == '' ? null : _pressNext);
  }
}
