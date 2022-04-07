import 'package:flutter/material.dart';

class ImageUploader extends StatelessWidget {
  final Function press;
  final AssetImage anonymous;

  ImageUploader({required this.press, required this.anonymous});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0),
    );
  }
}
