import 'package:flutter/material.dart';

class MyChip extends StatelessWidget {
  final String? content;
  final Function? pressClear;

  const MyChip({Key? key, this.content, this.pressClear});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.04,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
            child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(children: [
                  Text(content!),
                  const Padding(padding: EdgeInsets.all(3)),
                  IconButton(
                      padding: EdgeInsets.zero, // 패딩 설정
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.clear),
                      onPressed: () => print('aaa'),
                      color: Colors.grey,
                      iconSize: MediaQuery.of(context).size.height * 0.02)
                ]))));
  }
}
