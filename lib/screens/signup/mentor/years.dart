import 'package:bobjari_proj/widgets/signup_form.dart';
import 'package:bobjari_proj/widgets/topbar_back_contents.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bobjari_proj/const/colors.dart';
import 'package:bobjari_proj/providers/signup_provider.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/session_provider.dart';
import 'package:bobjari_proj/routes/routes.dart';
import 'package:bobjari_proj/screens/signup/mentor/topic.dart';
import 'package:bobjari_proj/const/etc.dart';

class SignupMentorYearsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupMentorYearsView();
}

class _SignupMentorYearsView extends State<SignupMentorYearsView> {
  int _years = 0;

  void _pressBack() {
    Navigator.pop(context);
  }

  void _pressNext(bool isValue) {
    if (isValue) {
      Provider.of<Signup>(context, listen: false).years = _years;
    }
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SignupMentorTopicView()));
  }

  @override
  Widget build(BuildContext context) {
    return SignupForm(
        isbasePadding: true,
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: CupertinoPicker(
              children: _getAgeWidgetList(),
              onSelectedItemChanged: (value) => setState(() {
                _years = value;
              }),
              itemExtent: 40,
              diameterRatio: 1,
              useMagnifier: true,
              magnification: 1.5,
            )),
        topTitle: const ['연차를 선택해주세요.', ''],
        btn1Title: '다 음',
        btn1Color: BobColors.mainColor,
        pressBack: _pressBack,
        pressBtn1: () => _pressNext(true),
        btn2Title: '나중에 하기',
        btn2Color: Colors.black,
        pressBtn2: () => _pressNext(false));
  }

  List<Widget> _getAgeWidgetList() {
    return List.generate(
        Etc.careerYear.length,
        (idx) => Center(
                child: Text(
              Etc.careerYear[idx],
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            )));
  }
}
