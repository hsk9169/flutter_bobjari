import 'package:bobjari_proj/widgets/topbar_back.dart';
import 'package:flutter/material.dart';
import 'package:bobjari_proj/widgets/base_scroller_with_back.dart';
import 'package:bobjari_proj/widgets/base_padding.dart';
import 'package:bobjari_proj/widgets/big_button.dart';
import 'package:bobjari_proj/widgets/top_title.dart';

class SignupForm extends StatelessWidget {
  final Widget child;
  final List<String> topTitle;
  final String btnTitle;
  final Function pressBack;
  final VoidCallback? pressNext;
  SignupForm(
      {required this.child,
      required this.topTitle,
      required this.btnTitle,
      required this.pressBack,
      this.pressNext});

  @override
  Widget build(BuildContext context) {
    return BaseScrollerWithBack(
        appBar: TopBarBack(press: pressBack),
        child: BasePadding(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              TopTitle(titleText: topTitle),
              child,
            ])),
        bottomSheet: BasePadding(
            child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: BigButton(
                        btnColor: Colors.black,
                        title: btnTitle,
                        txtColor: Colors.white,
                        disable: false,
                        press: pressNext)))));
  }
}
