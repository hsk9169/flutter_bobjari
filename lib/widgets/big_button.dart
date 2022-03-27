import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  final Color btnColor;
  final String title;
  final Color txtColor;
  final Color? borderColor;
  final Function? press;
  final Widget? childWidget;

  const BigButton({
    Key? key,
    required this.btnColor,
    required this.title,
    required this.txtColor,
    this.borderColor,
    this.press,
    this.childWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = const Size.fromWidth(double.infinity);
    return ElevatedButton(
        onPressed: () => {
              if (press != null) {press!()}
            },
        style: ElevatedButton.styleFrom(
            primary: btnColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            side: BorderSide(color: borderColor ?? btnColor, width: 2.0),
            fixedSize: size),
        child: Text(title,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: txtColor)));
  }
}
