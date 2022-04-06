import 'package:flutter/material.dart';

class BaseScroller extends StatelessWidget {
  final Widget child;
  final Widget? bottomSheet;
  final Widget? bottomNavigationBar;
  const BaseScroller({
    required this.child,
    this.bottomSheet,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: true,
          bottom: false,
          child: SingleChildScrollView(
              child: Column(children: [
            child,
            const Padding(padding: EdgeInsets.only(bottom: 100)),
          ]))),
      bottomSheet: bottomSheet,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
