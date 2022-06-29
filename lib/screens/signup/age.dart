import 'package:bobjari_proj/const/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/signup_provider.dart';
import 'package:bobjari_proj/const/etc.dart';
import 'package:bobjari_proj/widgets/signup_form.dart';
import 'package:bobjari_proj/screens/signup/gender.dart';

class SignupProfileAgeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupProfileAgeView();
}

class _SignupProfileAgeView extends State<SignupProfileAgeView> {
  int _ageIndex = 0;
  final int _thisYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _setAge(int value) {
    setState(() {
      _ageIndex = value;
    });
  }

  void _pressBack() {
    Navigator.pop(context);
  }

  void _pressNext() {
    Provider.of<Signup>(context, listen: false).age =
        _thisYear - Etc.baseAgeYear - _ageIndex + 1;
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SignupProfileGenderView();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return SignupForm(
        isbasePadding: true,
        topTitle: const ['태어난 연도를 선택해주세요.', ''],
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: CupertinoPicker(
              children: _getAgeWidgetList(_thisYear),
              onSelectedItemChanged: (value) => _setAge(value),
              itemExtent: 40,
              diameterRatio: 1,
              useMagnifier: true,
              magnification: 1.5,
            )),
        btn2Title: '다 음',
        btn2Color: BobColors.mainColor,
        pressBack: _pressBack,
        pressBtn2: _pressNext);
  }
}

List<Widget> _getAgeWidgetList(int thisYear) {
  return List.generate(
      thisYear - Etc.baseAgeYear + 1,
      (index) => Center(
              child: Text(
            (index + Etc.baseAgeYear).toString() + '년',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          )));
}
