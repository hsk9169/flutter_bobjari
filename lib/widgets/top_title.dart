import 'package:flutter/material.dart';

class TopTitle extends StatelessWidget {
  final List<String> titleText;

  const TopTitle({
    Key? key,
    required this.titleText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(titleText[0],
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          Text(titleText[1],
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black))
        ]));
  }
}
