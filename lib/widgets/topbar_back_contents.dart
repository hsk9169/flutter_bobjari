import 'package:flutter/material.dart';

class TopBarBackContents extends StatelessWidget {
  final Function pressBack;
  final String title;
  final Widget? icon1;
  final Function? pressIcon1;
  final Widget? icon2;
  final Function? pressIcon2;
  final Color? backgroundColor;
  final bool? bottomLine;

  const TopBarBackContents({
    Key? key,
    required this.pressBack,
    required this.title,
    this.icon1,
    this.pressIcon1,
    this.icon2,
    this.pressIcon2,
    this.backgroundColor,
    this.bottomLine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: backgroundColor == null ? Colors.white : backgroundColor,
            border: bottomLine == true
                ? Border(bottom: BorderSide(color: Colors.grey, width: 0.3))
                : null),
        alignment: Alignment.centerLeft,
        child: SafeArea(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded),
                color: backgroundColor == null ? Colors.black : Colors.white,
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
                  icon: icon1 ?? Icon(null),
                  color: Colors.black,
                  iconSize: MediaQuery.of(context).size.width * 0.08,
                  onPressed: () {
                    pressIcon1!();
                  }),
              icon2 != null
                  ? IconButton(
                      icon: icon2 ?? Icon(null),
                      color: Colors.black,
                      iconSize: MediaQuery.of(context).size.width * 0.08,
                      onPressed: () {
                        pressIcon2!();
                      })
                  : SizedBox(),
              Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01))
            ])));
  }
}
