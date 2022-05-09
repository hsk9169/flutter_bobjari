import 'package:flutter/material.dart';

class BaseScrollerWithBack extends StatelessWidget {
  final Widget child;
  final Widget appBar;
  final Widget? bottomSheet;
  final Widget? bottomNav;
  const BaseScrollerWithBack({
    required this.child,
    required this.appBar,
    this.bottomSheet,
    this.bottomNav,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50), child: appBar),
      body: SafeArea(
          top: false,
          bottom: false,
          child: Column(children: [
            SingleChildScrollView(
                child: Column(children: [
              child,
            ]))
          ])),
      bottomSheet: bottomSheet,
      bottomNavigationBar: bottomNav,
    );
  }
}
