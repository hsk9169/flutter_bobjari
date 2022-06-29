import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/session_provider.dart';
import 'package:bobjari_proj/widgets/card/main_notifications.dart';
import 'package:bobjari_proj/const/spaces.dart';
import 'package:bobjari_proj/routes/routes.dart';
import 'package:bobjari_proj/const/colors.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key, required this.session}) : super(key: key);
  final session;

  @override
  State<StatefulWidget> createState() => _MainView();
}

class _MainView extends State<MainView> {
  Timer? _timer;
  final PageController _pController = PageController(initialPage: 0);
  int _curCardIdx = 0;
  var _isSearchbarTapped = false;

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

  void _moveToSearch() {
    Navigator.pushNamed(context, Routes.SEARCH);
  }

  final List<Widget> _cardList = [
    BobGuidesCard(),
    BobRulesCard(),
  ];

  @override
  Widget build(BuildContext context) {
    var _session = Provider.of<Session>(context, listen: false);
    return Container(
        padding: EdgeInsets.all(BobSpaces.firstEgg),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(children: [
          _session.user.userId != null && _session.user.role == 'mentor'
              ? Container(
                  alignment: Alignment.centerRight,
                  width: MediaQuery.of(context).size.width,
                  child: IconButton(
                      icon: const Icon(Icons.search),
                      iconSize: 30,
                      onPressed: () => _moveToSearch()))
              : const SizedBox(),
          Container(
              decoration: const BoxDecoration(color: Colors.white),
              alignment: Alignment.centerLeft,
              child: Container(
                width: (MediaQuery.of(context).size.width) * 0.5,
                height: (MediaQuery.of(context).size.height * 0.15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('assets/images/slogan.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              )),
          const Padding(padding: EdgeInsets.all(5)),
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
          ]),
          const Padding(padding: EdgeInsets.all(10)),
          GestureDetector(
              onTapDown: (details) {
                setState(() {
                  _isSearchbarTapped = true;
                });
              },
              onTapUp: (details) {
                Future.delayed(const Duration(milliseconds: 100), () {
                  setState(() {
                    _isSearchbarTapped = false;
                  });
                  _moveToSearch();
                });
              },
              onTapCancel: () {
                Future.delayed(const Duration(milliseconds: 100), () {
                  setState(() {
                    _isSearchbarTapped = false;
                  });
                });
              },
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: BobColors.mainColor, width: 3),
                      borderRadius: BorderRadius.circular(10)),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: Row(children: [
                    const Padding(padding: EdgeInsets.all(7)),
                    Icon(Icons.search,
                        size: MediaQuery.of(context).size.height * 0.035,
                        color: BobColors.mainColor),
                    const Padding(padding: EdgeInsets.all(3)),
                    Text('직업인 찾아보기',
                        style: TextStyle(
                            color: _isSearchbarTapped
                                ? Colors.grey[300]
                                : Colors.grey[600],
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            fontWeight: FontWeight.bold))
                  ])))
        ]));
  }
}
