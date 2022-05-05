import 'package:flutter/material.dart';

class FilterMenu extends StatelessWidget {
  final _sortList = ['추천순', '정확도순', '최신순', '낮은가격순', '높은가격순', '거리순'];
  final _filterList = ['연차', '토픽', '감사비', '성별', '지역'];
  var _sortSel = 0;
  var _filterSel = [];

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
        decoration: BoxDecoration(color: Colors.white),
        alignment: Alignment.centerLeft,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          GestureDetector(
              onTap: () => print('select sort'),
              child: Row(children: [
                Text(_sortList[_sortSel],
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.06,
                        fontWeight: FontWeight.bold)),
                Icon(Icons.keyboard_arrow_down,
                    size: MediaQuery.of(context).size.width * 0.08)
              ])),
          Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.02)),
          Row(children: _renderFilterLists(context))
        ]));
  }

  List<Widget> _renderFilterLists(BuildContext context) {
    return List.generate(
        _filterList.length,
        (idx) => Row(children: [
              Container(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.03,
                    right: MediaQuery.of(context).size.width * 0.03,
                    top: MediaQuery.of(context).size.width * 0.02,
                    bottom: MediaQuery.of(context).size.width * 0.02,
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey[400]!,
                          width: MediaQuery.of(context).size.width * 0.002)),
                  child: Text(_filterList[idx],
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          fontWeight: FontWeight.normal))),
              Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01))
            ]));
  }
}
