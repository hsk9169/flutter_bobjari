import 'package:flutter/material.dart';
import 'package:bobjari_proj/const/etc.dart';
import 'package:bobjari_proj/models/mentor/mentor.dart';
import 'package:flutter/scheduler.dart';

class IntroduceView extends StatefulWidget {
  final String? title;
  final String? introduce;
  const IntroduceView({this.title, this.introduce});

  @override
  State<StatefulWidget> createState() => _IntroduceView();
}

class _IntroduceView extends State<IntroduceView> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * 0.08,
          bottom: MediaQuery.of(context).size.width * 0.08,
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Column(children: [
          AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: _isExpanded ? 300 : 80,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title!,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.06,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.003)),
                    Text(widget.introduce!,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.normal,
                            color: Colors.black)),
                  ],
                ),
              )),
          Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.01)),
          GestureDetector(
              onTap: () {
                setState(() => _isExpanded = !_isExpanded);
              },
              child: Row(children: [
                Text(
                  _isExpanded ? '접기' : '더 보기',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Icon(Icons.arrow_forward_ios,
                    size: MediaQuery.of(context).size.width * 0.035)
              ])),
        ]));
  }
}
