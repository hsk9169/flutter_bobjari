import 'package:flutter/material.dart';

class TopBarBack extends StatelessWidget {
  final Function press;

  const TopBarBack({
    Key? key,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Colors.white),
        alignment: Alignment.centerLeft,
        child: SafeArea(
            child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.black,
          onPressed: () {
            press();
          },
        )));
  }
}
