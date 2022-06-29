import 'package:bobjari_proj/widgets/signup_form.dart';
import 'package:bobjari_proj/widgets/topbar_back_contents.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bobjari_proj/const/colors.dart';
import 'package:bobjari_proj/providers/signup_provider.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/session_provider.dart';
import 'package:bobjari_proj/routes/routes.dart';
import 'package:bobjari_proj/const/etc.dart';
import 'package:bobjari_proj/models/preference/schedule.dart';
import './location.dart';

class SignupMentorScheduleView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupMentorScheduleView();
}

class _SignupMentorScheduleView extends State<SignupMentorScheduleView> {
  final List<String> _dayName = ['월', '화', '수', '목', '금', '토', '일'];
  List<String> min = [
    '00',
    '05',
    '10',
    '15',
    '20',
    '25',
    '30',
    '35',
    '40',
    '45',
    '50',
    '55'
  ];
  List<int> hour = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  late ScrollController _scrollController;
  List<SchedulePreferenceModel> _schedule = [];
  List<int> _selDay = [];

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _pressBack() {
    Navigator.pop(context);
  }

  void _pressNext(bool isValue) {
    if (isValue) {
      Provider.of<Signup>(context, listen: false).schedule = _schedule;
    }
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SignupMentorLocationView()));
  }

  @override
  Widget build(BuildContext context) {
    return SignupForm(
        isbasePadding: false,
        subtitle: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.04),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset:
                        Offset(0, MediaQuery.of(context).size.height * 0.015))
              ],
            ),
            child: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: renderDayButtons()))),
        child: Stack(children: [
          Container(color: Colors.grey[200]),
          SingleChildScrollView(
              controller: _scrollController,
              child: Container(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                      top: MediaQuery.of(context).size.height * 0.03,
                      bottom: MediaQuery.of(context).size.height * 0.18),
                  child: Column(
                    children: List.generate(
                        _schedule.length, (idx) => renderChip(idx)),
                  )))
          //])
        ]),
        topTitle: const ['밥자리 희망 스케쥴을', '등록해주세요.'],
        btn1Title: '다 음',
        btn1Color: BobColors.mainColor,
        pressBack: _pressBack,
        pressBtn1: _schedule.isEmpty ? null : () => _pressNext(true),
        btn2Title: '나중에 하기',
        btn2Color: Colors.black,
        pressBtn2: () => _pressNext(false));
  }

  List<Widget> renderDayButtons() {
    return List.generate(
        _dayName.length,
        (idx) => GestureDetector(
            onTap: () async {
              if (!_selDay.contains(idx)) {
                var _ret = await renderDialog();
                final SchedulePreferenceModel _model = SchedulePreferenceModel(
                    day: _dayName[idx], startTime: _ret[0], endTime: _ret[1]);
                setState(() {
                  _selDay.add(idx);
                  _schedule.add(_model);
                });
              } else {}
              _schedule.forEach((el) => print(el.toJson()));
            },
            child: Container(
                decoration: BoxDecoration(
                    color: _selDay.contains(idx)
                        ? BobColors.mainColor
                        : Colors.white,
                    border: Border.all(
                        color: _selDay.contains(idx)
                            ? Colors.transparent
                            : Colors.grey,
                        width: MediaQuery.of(context).size.width * 0.0015),
                    borderRadius: BorderRadius.circular(10)),
                alignment: Alignment.center,
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                child: Text(_dayName[idx],
                    style: TextStyle(
                        color:
                            _selDay.contains(idx) ? Colors.white : Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontWeight: FontWeight.bold)))));
  }

  Future<List<String>> renderDialog() async {
    ValueNotifier<String> _ampmStart = ValueNotifier<String>('오전');
    ValueNotifier<String> _ampmEnd = ValueNotifier<String>('오전');
    List<int> _startTime12 = [1, 0];
    List<int> _endTime12 = [1, 0];
    List<String> _ret;

    List<String>? ret = await showDialog<List<String>>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: BobColors.mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Column(children: [
                    Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            )),
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.06,
                          right: MediaQuery.of(context).size.width * 0.06,
                          top: MediaQuery.of(context).size.height * 0.03,
                          bottom: MediaQuery.of(context).size.height * 0.03,
                        ),
                        child: Column(children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              child: Text('스케쥴 시작 시간',
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                      fontWeight: FontWeight.bold))),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ValueListenableBuilder(
                                  builder: (BuildContext context, String value,
                                      Widget? child) {
                                    return GestureDetector(
                                        onTap: () {
                                          _ampmStart.value =
                                              value == '오전' ? '오후' : '오전';
                                        },
                                        child: Container(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01,
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Stack(
                                                alignment:
                                                    AlignmentDirectional.center,
                                                children: [
                                                  AnimatedAlign(
                                                    alignment: value == '오전'
                                                        ? Alignment.centerLeft
                                                        : Alignment.centerRight,
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.fastOutSlowIn,
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.145,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.04,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.6),
                                                            spreadRadius: 2,
                                                            blurRadius: 4,
                                                            offset: const Offset(
                                                                0,
                                                                0), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Text('오전',
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.04,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text('오후',
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.04,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ])
                                                ])));
                                  },
                                  valueListenable: _ampmStart,
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.02,
                                      right: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    width: MediaQuery.of(context).size.width *
                                        0.24,
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.07,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08,
                                              child: CupertinoPicker(
                                                  children: _getHourList(),
                                                  onSelectedItemChanged:
                                                      (value) =>
                                                          _startTime12[0] =
                                                              hour[value],
                                                  itemExtent: 25,
                                                  useMagnifier: true,
                                                  scrollController:
                                                      FixedExtentScrollController(
                                                          initialItem: 0))),
                                          Text(':',
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.06,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.07,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08,
                                              child: CupertinoPicker(
                                                children: _getMinList(),
                                                onSelectedItemChanged:
                                                    (value) => _startTime12[1] =
                                                        int.parse(min[value]),
                                                itemExtent: 25,
                                                useMagnifier: true,
                                              )),
                                        ]))
                              ]),
                          Padding(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.02)),
                          Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              child: Text('스케쥴 종료 시간',
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                      fontWeight: FontWeight.bold))),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ValueListenableBuilder(
                                  builder: (BuildContext context, String value,
                                      Widget? child) {
                                    return GestureDetector(
                                        onTap: () {
                                          _ampmEnd.value =
                                              value == '오전' ? '오후' : '오전';
                                        },
                                        child: Container(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01,
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Stack(
                                                alignment:
                                                    AlignmentDirectional.center,
                                                children: [
                                                  AnimatedAlign(
                                                    alignment: value == '오전'
                                                        ? Alignment.centerLeft
                                                        : Alignment.centerRight,
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.fastOutSlowIn,
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.145,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.04,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.6),
                                                            spreadRadius: 2,
                                                            blurRadius: 4,
                                                            offset: const Offset(
                                                                0,
                                                                0), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Text('오전',
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.04,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text('오후',
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.04,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ])
                                                ])));
                                  },
                                  valueListenable: _ampmEnd,
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.02,
                                      right: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    width: MediaQuery.of(context).size.width *
                                        0.24,
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.07,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08,
                                              child: CupertinoPicker(
                                                  children: _getHourList(),
                                                  onSelectedItemChanged:
                                                      (value) => _endTime12[0] =
                                                          hour[value],
                                                  itemExtent: 25,
                                                  useMagnifier: true,
                                                  scrollController:
                                                      FixedExtentScrollController(
                                                          initialItem: 0))),
                                          Text(':',
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.06,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.07,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08,
                                              child: CupertinoPicker(
                                                children: _getMinList(),
                                                onSelectedItemChanged:
                                                    (value) => _endTime12[1] =
                                                        int.parse(min[value]),
                                                itemExtent: 25,
                                                useMagnifier: true,
                                              )),
                                        ]))
                              ])
                        ])),
                    GestureDetector(
                        onTap: () {
                          String _start = '${_ampmStart.value} ';
                          _start += _timeIntToString24(_startTime12);
                          String _end = '${_ampmEnd.value} ';
                          _end += _timeIntToString24(_endTime12);
                          Navigator.pop(context, [_start, _end]);
                        },
                        child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            color: Colors.transparent,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: Text('확인',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))))
                  ])));
        });
    return ret!;
  }

  Widget renderChip(int idx) {
    double radius = 10;
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
        child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(radius),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 4,
                      blurRadius: 6,
                      offset:
                          Offset(0, MediaQuery.of(context).size.height * 0.003))
                  //Offset(0, 0))
                ]),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: BobColors.mainColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(radius),
                              bottomLeft: Radius.circular(radius))),
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.04),
                          child: Text(_schedule[idx].day,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)))),
                  Spacer(),
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                          '${_schedule[idx].startTime} - ${_schedule[idx].endTime}',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.bold))),
                  Spacer(),
                  Container(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.05),
                      alignment: Alignment.center,
                      child: GestureDetector(
                          onTap: () => setState(() {
                                _selDay.removeAt(idx);
                                _schedule.removeAt(idx);
                              }),
                          child: Icon(Icons.clear,
                              size: MediaQuery.of(context).size.width * 0.06)))
                ])));
  }

  List<Widget> _getHourList() {
    return List.generate(
        hour.length,
        (index) => Center(
            child: Text(hour[index].toString(),
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    fontWeight: FontWeight.bold))));
  }

  List<Widget> _getMinList() {
    return List.generate(
        min.length,
        (index) => Center(
            child: Text(min[index],
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    fontWeight: FontWeight.bold))));
  }

  String _timeIntToString12(List<int> intTime) {
    String _hour = intTime[0] > 21
        ? '오후 ' + (intTime[0] - 12).toString()
        : intTime[0] > 12
            ? '오후 0' + (intTime[0] - 12).toString()
            : intTime[0] > 9
                ? '오전 ' + intTime[0].toString()
                : '오전 0' + intTime[0].toString();
    String _min =
        intTime[1] > 9 ? intTime[1].toString() : '0' + intTime[1].toString();
    return _hour + ':' + _min;
  }

  String _timeIntToString24(List<int> intTime) {
    String _hour =
        intTime[0] > 9 ? intTime[0].toString() : '0' + intTime[0].toString();
    String _min =
        intTime[1] > 9 ? intTime[1].toString() : '0' + intTime[1].toString();
    return _hour + ':' + _min;
  }

  List<int> _timeStringToInt(String strTime) {
    List<String> split = strTime.split(' ');
    List<int> ret;
    if (strTime.length > 5) {
      if (split[0] == '오전') {
        ret = split[1].split(':').map((el) => int.parse(el)).toList();
      } else {
        var temp = split[1].split(':');
        ret = [int.parse(temp[0]) + 12, int.parse(temp[1])];
      }
    } else {
      ret = strTime.split(':').map((el) => int.parse(el)).toList();
    }
    return ret;
  }
}
