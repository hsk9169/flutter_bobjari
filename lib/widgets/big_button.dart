import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  final Color btnColor;
  final String title;
  final Color txtColor;
  final Color? borderColor;
  final VoidCallback? press;
  final bool? disable;

  const BigButton({
    Key? key,
    required this.btnColor,
    required this.title,
    required this.txtColor,
    this.borderColor,
    this.press,
    this.disable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: press,
        style: ElevatedButton.styleFrom(
          primary: btnColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          side: BorderSide(
              color: press == null || borderColor == null
                  ? Colors.transparent
                  : borderColor != null
                      ? borderColor!
                      : btnColor,
              width: 2.0),
        ),
        child: Text(title,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: txtColor)));
  }
}
