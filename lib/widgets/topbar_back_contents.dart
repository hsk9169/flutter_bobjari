import 'package:flutter/material.dart';

class TopBarBackContents extends StatelessWidget {
  final Function pressBack;
  final String title;
  final Widget icon;
  final Function pressIcon;

  const TopBarBackContents({
    Key? key,
    required this.pressBack,
    required this.title,
    required this.icon,
    required this.pressIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey, width: 0.3))),
        alignment: Alignment.centerLeft,
        child: SafeArea(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: Colors.black,
                onPressed: () {
                  pressBack();
                },
              ),
              Spacer(),
              Text(title,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.05)),
              Spacer(),
              IconButton(
                  icon: icon,
                  color: Colors.black,
                  iconSize: MediaQuery.of(context).size.width * 0.08,
                  onPressed: () {
                    pressIcon();
                  }),
              Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01))
            ])));
  }
}
