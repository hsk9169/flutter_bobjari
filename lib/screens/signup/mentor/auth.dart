import 'package:bobjari_proj/screens/signup/mentor/authEmailInput.dart';
import 'package:bobjari_proj/widgets/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:bobjari_proj/const/colors.dart';
import 'package:bobjari_proj/providers/signup_provider.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/session_provider.dart';
import 'package:bobjari_proj/routes/routes.dart';
import 'package:bobjari_proj/screens/signup/mentor/fee.dart';
import 'package:bobjari_proj/const/etc.dart';
import './schedule.dart';

class SignupMentorAuthView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupMentorAuthView();
}

class _SignupMentorAuthView extends State<SignupMentorAuthView> {
  List<int> _authSel = [];

  void _pressBack() {
    Navigator.pop(context);
  }

  void _pressNext(bool isValue) {
    if (isValue) {
      //Provider.of<Signup>(context, listen: false).auth = _authSel;
    }
    //Navigator.push(context,
    //    MaterialPageRoute(builder: (context) => SignupMentorFeeView()));
  }

  void _onSelect(int selIdx) async {
    bool ret;
    if (_authSel.contains(selIdx)) {
      setState(() {
        _authSel.remove(selIdx);
      });
    } else {
      switch (selIdx) {
        case 0:
          ret = await Navigator.push(context,
              MaterialPageRoute(builder: (context) {
            return SignupMentorAuthEmailInputView();
          }));
          break;
        default:
          ret = false;
          break;
      }
      if (ret) {
        setState(() {
          _authSel.add(selIdx);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignupForm(
        isbasePadding: true,
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('직업 인증을 거쳐야\n예비직업인과의 밥자리를 가질 수 있습니다.',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold)),
              Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.02)),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List<Widget>.generate(Etc.authSel.length,
                      (idx) => renderAuthCard(Etc.authSel[idx], idx)))
            ])),
        topTitle: const ['직업을 인증해주세요', ''],
        btn1Title: '다 음',
        btn1Color: BobColors.mainColor,
        pressBack: _pressBack,
        pressBtn1: _authSel.isEmpty ? null : () => _pressNext(true),
        btn2Title: '나중에 하기',
        btn2Color: Colors.black,
        pressBtn2: () => _pressNext(false));
  }

  Widget renderAuthCard(List<String> authText, int index) {
    return Column(children: [
      Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02)),
      GestureDetector(
          onTap: () => _onSelect(index),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
                top: MediaQuery.of(context).size.height * 0.01,
                bottom: MediaQuery.of(context).size.height * 0.01,
              ),
              decoration: BoxDecoration(
                  color: _authSel.contains(index)
                      ? Colors.grey[200]
                      : Colors.white,
                  border: Border.all(
                    color: _authSel.contains(index)
                        ? BobColors.mainColor
                        : Colors.grey,
                    width: MediaQuery.of(context).size.width * 0.006,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(authText[0],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false),
                    Text(authText[1],
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.035),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false),
                  ])))
    ]);
  }
}
