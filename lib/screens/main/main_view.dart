import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bobjari_proj/widgets/card/main_notifications.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainView();
}

class _MainView extends State<MainView> {
  Timer? _timer;
  final PageController _pController = PageController(initialPage: 0);
  int _curCardIdx = 0;

  @override
  void initState() {
    _initTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pController.dispose();
    super.dispose();
  }

  void _initTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _pageIdx();
    });
  }

  void _pageIdx() {
    if (_curCardIdx < _cardList.length - 1) {
      setState(() {
        _curCardIdx++;
      });
    } else {
      setState(() {
        _curCardIdx = 0;
      });
    }
    _pController.animateToPage(_curCardIdx,
        duration: const Duration(milliseconds: 500), curve: Curves.easeOutCirc);
  }

  final List<Widget> _cardList = [
    BobGuidesCard(),
    BobRulesCard(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          alignment: Alignment.centerLeft,
          child: Container(
            width: (MediaQuery.of(context).size.width) * 0.5,
            height: (MediaQuery.of(context).size.height * 0.2),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/slogan.png'),
                fit: BoxFit.contain,
              ),
            ),
          )),
      Stack(alignment: const Alignment(0.9, 0.7), children: [
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: PageView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _pController,
                onPageChanged: (_idx) {
                  setState(() {
                    _curCardIdx = _idx;
                  });
                  _timer?.cancel();
                  _initTimer();
                },
                itemCount: _cardList.length,
                itemBuilder: (BuildContext context, int index) {
                  return _cardList[index];
                })),
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            (_curCardIdx + 1).toString() +
                ' / ' +
                (_cardList.length).toString(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ])
    ]);
  }
}
