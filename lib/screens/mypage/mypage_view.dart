import 'package:flutter/material.dart';
import 'package:bobjari_proj/const/spaces.dart';

class MypageView extends StatefulWidget {
  const MypageView({Key? key, required this.session}) : super(key: key);
  final session;

  @override
  State<StatefulWidget> createState() => _MypageView();
}

class _MypageView extends State<MypageView> {
  @override
  Widget build(BuildContext context) {
    var _session = widget.session;
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(padding: EdgeInsets.all(BobSpaces.firstEgg)),
          //Text(_session.user.profile.nickname,
          //    textAlign: TextAlign.left,
          //    style: const TextStyle(
          //      fontSize: 35,
          //      fontWeight: FontWeight.bold,
          //      color: Colors.black,
          //    )),
        ]));
  }
}
