import 'package:flutter/material.dart';

class BaseScrollerWithBack extends StatelessWidget {
  final Widget child;
  final Widget appBar;
  final Widget? bottomSheet;
  const BaseScrollerWithBack({
    required this.child,
    required this.appBar,
    this.bottomSheet,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50), child: appBar),
      body: SafeArea(
          top: false,
          bottom: false,
          child: SingleChildScrollView(
              child: Column(children: [
            child,
            const Padding(padding: EdgeInsets.only(bottom: 100))
          ]))),
      bottomSheet: bottomSheet,
    );
  }
}
