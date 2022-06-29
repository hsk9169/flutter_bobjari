import 'package:bobjari_proj/widgets/topbar_back.dart';
import 'package:flutter/material.dart';
import 'package:bobjari_proj/widgets/big_button.dart';
import 'package:bobjari_proj/widgets/top_title.dart';

class SignupForm extends StatelessWidget {
  final Widget child;
  final Widget? subtitle;
  final bool isbasePadding;
  final List<String> topTitle;
  final String? btn1Title;
  final Color? btn1Color;
  final Function? pressBtn1;
  final String? btn2Title;
  final Color? btn2Color;
  final Function? pressBtn2;
  final Function pressBack;
  SignupForm(
      {required this.child,
      required this.topTitle,
      required this.isbasePadding,
      this.subtitle,
      this.btn1Title,
      this.btn1Color,
      this.pressBtn1,
      this.btn2Title,
      this.btn2Color,
      this.pressBtn2,
      required this.pressBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: TopBarBack(press: pressBack)),
        body: Column(children: [
          Container(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
              ),
              alignment: Alignment.centerLeft,
              child: TopTitle(titleText: topTitle)),
          subtitle ?? SizedBox(),
          Expanded(
              child: SingleChildScrollView(
                  child: Container(
                      alignment: Alignment.topCenter,
                      padding: isbasePadding
                          ? EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.05,
                              right: MediaQuery.of(context).size.width * 0.05,
                            )
                          : null,
                      //height: MediaQuery.of(context).size.height * 0.75,
                      child: child)))
        ]),
        bottomSheet: Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
                bottom: MediaQuery.of(context).size.height * 0.04),
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              btn1Color != null
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: BigButton(
                          btnColor: btn1Color!,
                          title: btn1Title!,
                          txtColor: Colors.white,
                          disable: false,
                          press: pressBtn1 == null ? null : () => pressBtn1!()))
                  : SizedBox(),
              Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.02)),
              btn2Color != null
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: BigButton(
                          btnColor: btn2Color!,
                          title: btn2Title!,
                          txtColor: Colors.white,
                          disable: false,
                          press: pressBtn2 == null ? null : () => pressBtn2!()))
                  : SizedBox(),
            ])));
  }
}
