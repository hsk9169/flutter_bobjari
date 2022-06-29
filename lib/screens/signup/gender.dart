import 'package:bobjari_proj/const/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/signup_provider.dart';
import 'package:bobjari_proj/widgets/signup_form.dart';
import 'package:bobjari_proj/screens/signup/image.dart';

class SignupProfileGenderView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupProfileGenderView();
}

class _SignupProfileGenderView extends State<SignupProfileGenderView> {
  var _gender = 'female';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _setGender(int index) {
    if (index == 0) {
      setState(() {
        _gender = 'female';
      });
    } else if (index == 1) {
      setState(() {
        _gender = 'male';
      });
    }
  }

  void _pressBack() {
    Navigator.pop(context);
  }

  void _pressNext() {
    Provider.of<Signup>(context, listen: false).gender = _gender;
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SignupProfileImageView();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return SignupForm(
        isbasePadding: true,
        topTitle: const ['성별을 선택해주세요.', ''],
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: CupertinoPicker(
              children: const [
                Center(
                    child: Text('여성',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20))),
                Center(
                    child: Text('남성',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20))),
              ],
              onSelectedItemChanged: (index) => _setGender(index),
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
