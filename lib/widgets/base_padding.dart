import 'package:flutter/material.dart';
import 'package:bobjari_proj/const/spaces.dart';

class BasePadding extends StatelessWidget {
  final Widget child;
  const BasePadding({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: BobSpaces.firstEgg, right: BobSpaces.firstEgg),
      child: child,
    );
  }
}
