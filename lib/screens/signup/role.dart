import 'package:bobjari_proj/widgets/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/signup_provider.dart';
import 'package:bobjari_proj/providers/session_provider.dart';
import 'package:bobjari_proj/services/real_api_service.dart';
import 'package:bobjari_proj/const/colors.dart';
import 'package:bobjari_proj/models/signup_model.dart';
import 'package:bobjari_proj/routes/routes.dart';

class SignupProfileRoleView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupProfileRoleView();
}

class _SignupProfileRoleView extends State<SignupProfileRoleView> {
  final RealApiService _realApiService = RealApiService();
  var _role = '';
  Color _menteeColor = Colors.white;
  Color _mentorColor = Colors.white;
  late SignupModel _reqModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _pressBack() {
    Navigator.pop(context);
  }

  void _pressNext() async {
    var _jwt;
    var _user;
    _reqModel = SignupModel(
      phone: Provider.of<Signup>(context, listen: false).phone,
      nickname: Provider.of<Signup>(context, listen: false).nickname,
      age: Provider.of<Signup>(context, listen: false).age,
      gender: Provider.of<Signup>(context, listen: false).gender,
      image: Provider.of<Signup>(context, listen: false).image,
      role: _role,
    );
    _user = await _realApiService.signUpBob(_reqModel);
    if (_user.profile?.nickname == _reqModel.nickname) {
      _jwt = await _realApiService.getJWT(_user.profile?.phone as String);
      Provider.of<Session>(context, listen: false).user = _user;
      Provider.of<Session>(context, listen: false).token = _jwt;
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.SERVICE, (Route<dynamic> route) => false);
    } else {
      throw Exception('user profile not found');
    }
  }

  void _press(String role) {
    setState(() {
      _role = role;
      if (role == 'mentee') {
        _menteeColor = BobColors.mainColor;
        _mentorColor = Colors.white;
      } else if (role == 'mentor') {
        _mentorColor = BobColors.mainColor;
        _menteeColor = Colors.white;
      } else {
        _menteeColor = Colors.white;
        _mentorColor = Colors.white;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SignupForm(
        topTitle: const ['회원가입 완료!', '원하는 활동을 선택해주세요.'],
        child: Center(
            child: Column(children: [
          const Padding(padding: EdgeInsets.all(20)),
          Row(children: [
            Expanded(
              flex: 15,
              child: RoleCard(
                  role: 'mentee',
                  press: _press,
                  selected: _role,
                  color: _menteeColor),
            ),
            const Expanded(flex: 1, child: Padding(padding: EdgeInsets.all(0))),
            Expanded(
              flex: 15,
              child: RoleCard(
                  role: 'mentor',
                  press: _press,
                  selected: _role,
                  color: _mentorColor),
            ),
          ])
        ])),
        btnTitle: '가입하기',
        pressBack: _pressBack,
        pressNext: _role == '' ? null : _pressNext);
  }
}

class RoleCard extends StatelessWidget {
  final String role;
  final Function press;
  final String selected;
  final Color color;
  const RoleCard(
      {required this.role,
      required this.press,
      required this.selected,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return (InkWell(
        onTap: () => press(role),
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
                border: Border.all(
                    color:
                        role == selected ? BobColors.mainColor : Colors.grey),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: color),
            width: (MediaQuery.of(context).size.width) * 0.4,
            height: (MediaQuery.of(context).size.height) * 0.3,
            child: Column(children: [
              const Expanded(
                  flex: 1, child: Padding(padding: EdgeInsets.all(0))),
              Expanded(
                  flex: 4,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                            flex: role == 'mentee' ? 2 : 1,
                            child: Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage('assets/images/cat.png'),
                                      fit: BoxFit.fitWidth)),
                            )),
                        Expanded(
                            flex: role == 'mentor' ? 2 : 1,
                            child: Container(
                              width: (MediaQuery.of(context).size.width) * 0.1,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage('assets/images/dog.png'),
                                      fit: BoxFit.fitWidth)),
                            ))
                      ])),
              Expanded(
                  flex: 1,
                  child: Text(role == 'mentee' ? '예비직업인' : '직업인',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: role == selected ? Colors.white : Colors.black,
                      )))
            ]))));
  }
}
