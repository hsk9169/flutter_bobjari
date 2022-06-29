import 'package:flutter/material.dart';
import 'package:bobjari_proj/const/etc.dart';

class TopicsView extends StatefulWidget {
  final List<int>? topics;
  const TopicsView({this.topics});
  @override
  State<StatefulWidget> createState() => _TopicsView();
}

class _TopicsView extends State<TopicsView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * 0.08,
          bottom: MediaQuery.of(context).size.width * 0.08,
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('토픽',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                  fontWeight: FontWeight.bold)),
          Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.02)),
          Wrap(
              alignment: WrapAlignment.start,
              spacing: 4,
              runSpacing: 4,
              children: List<Widget>.generate(
                  widget.topics!.length, (idx) => _chip(idx)))
        ]));
  }

  Widget _chip(int _idx) {
    return SizedBox(
        child: Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      width: null,
      height: MediaQuery.of(context).size.height * 0.04,
      decoration: BoxDecoration(
        color: Colors.amber[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        Etc.topics[_idx],
        textAlign: TextAlign.center,
      ),
    ));
  }
}
