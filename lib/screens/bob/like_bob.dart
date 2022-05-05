import 'package:flutter/material.dart';
import 'package:bobjari_proj/models/bobjari_model.dart';
//import 'package:bobjari_proj/services/fake_api_service.dart';

class LikeBob extends StatefulWidget {
  const LikeBob({Key? key, required this.session}) : super(key: key);
  final session;

  @override
  State<StatefulWidget> createState() => _LikeBob();
}

class _LikeBob extends State<LikeBob> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(child: Column(children: _textList(50))),
    );
  }

  List<Widget> _textList(int num) {
    return List.generate(
        num,
        (index) => Center(
              child: Text('$index'),
            ));
  }
}
