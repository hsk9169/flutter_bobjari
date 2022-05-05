import 'package:bobjari_proj/models/bobjari_model.dart';
import 'package:bobjari_proj/widgets/base_padding.dart';
import 'package:bobjari_proj/const/spaces.dart';
import 'package:flutter/material.dart';
import './like_bob.dart';
import './my_bob.dart';

class BobView extends StatefulWidget {
  const BobView({Key? key, required this.session}) : super(key: key);
  final session;

  @override
  State<StatefulWidget> createState() => _BobView();
}

class _BobView extends State<BobView> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(padding: EdgeInsets.all(BobSpaces.firstEgg)),
          const BasePadding(
              child: Text('밥자리',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ))),
          const Padding(padding: EdgeInsets.all(10)),
          Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Colors.black12))),
              child: TabBar(
                tabs: const [
                  Tab(
                      child: Text('나의 밥자리',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black))),
                  Tab(
                      child: Text('찜한 밥자리',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black))),
                ],
                controller: _tabController,
              )),
          SizedBox(
              height: 550,
              child: TabBarView(controller: _tabController, children: [
                BasePadding(child: MyBob(session: widget.session)),
                BasePadding(child: LikeBob(session: widget.session)),
              ])),
        ]));
  }
}
