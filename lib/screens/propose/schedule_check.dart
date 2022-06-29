import 'package:bobjari_proj/const/colors.dart';
import 'package:bobjari_proj/models/mentor/mentor.dart';
import 'package:bobjari_proj/models/preference/schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/propose_provider.dart';
import 'package:bobjari_proj/services/real_api_service.dart';
import 'package:bobjari_proj/services/fake_api_service.dart';
import 'package:bobjari_proj/widgets/topbar_back_contents.dart';
import 'package:bobjari_proj/widgets/big_button.dart';
import 'location_check.dart';
import 'package:bobjari_proj/routes/routes.dart';

class ScheduleCheckView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScheduleCheckView();
}

class _ScheduleCheckView extends State<ScheduleCheckView> {
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

  var _curDate = DateTime.now();
  List<ScheduleProposalModel> _checkList = [];
  ScheduleProposalModel _selected = ScheduleProposalModel();
  var _count = 0;
  final List<String> _dayName = ['월', '화', '수', '목', '금', '토', '일'];
  List<int> _availableDays = [];
  List<List<int>> _startTime = [];
  List<List<int>> _endTime = [];
  ValueNotifier<String> _startTimeStr = ValueNotifier<String>('');
  ValueNotifier<String> _endTimeStr = ValueNotifier<String>('');

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  void _initializeData() {
    var mentor = Provider.of<Propose>(context, listen: false).mentorDetails;
    setState(() {
      Provider.of<Propose>(context, listen: false)
          .mentorDetails
          .details!
          .preference!
          .schedule!
          .forEach((el) {
        var _temp = _dayName.indexOf(el.day);
        if (_temp >= 0) {
          _availableDays.add(_temp);
          var _st = el.startTime.split(':');
          var _et = el.endTime.split(':');
          _startTime.add(_st.map((el) => int.parse(el)).toList());
          _endTime.add(_et.map((el) => int.parse(el)).toList());
        }
      });
    });
  }

  void _nextMonth() {
    bool _found = false;
    setState(() {
      _curDate = DateTime(_curDate.year, _curDate.month + 1);
      _checkList.forEach((dynamic el) {
        if (el.month == _curDate.month && el.year == _curDate.year) {
          _found = true;
          _selected = el;
        }
      });
      if (!_found) {
        _selected = ScheduleProposalModel();
      }
    });
  }

  void _prevMonth() {
    bool _found = false;
    setState(() {
      _curDate = DateTime(_curDate.year, _curDate.month - 1);
      _checkList.forEach((dynamic el) {
        if (el.month == _curDate.month && el.year == _curDate.year) {
          _found = true;
          _selected = el;
        }
      });
      if (!_found) {
        _selected = ScheduleProposalModel();
      }
    });
  }

  void _selectDay(int day, int dateDay) {
    var __idx;
    var __cnt = 0;
    _checkList.forEach((dynamic el) {
      if (el.year == _selected.year && el.month == _selected.month) {
        __idx = __cnt;
      } else {
        __cnt++;
      }
    });

    if (__idx != null) {
      if (_checkList[__idx].day?.contains(day) == true) {
        setState(() {
          var _delIdx = _checkList[__idx].day?.indexOf(day);
          _checkList[__idx].day?.removeAt(_delIdx!);
          _checkList[__idx].dateDay?.removeAt(_delIdx!);
          _checkList[__idx].time?.removeAt(_delIdx!);
          if (_checkList[__idx].day?.length == 0) {
            _checkList.removeAt(__idx);
            _selected = ScheduleProposalModel();
          }
          _count--;
        });
      } else {
        if (_count < 3) {
          var _st = _startTime[_availableDays.indexOf(day % 7)];
          var _et = _endTime[_availableDays.indexOf(day % 7)];
          var _stStr = _timeIntToString24(_st);
          var _etStr = _timeIntToString24(_et);
          setState(() {
            _checkList[__idx].day?.add(day);
            _checkList[__idx].dateDay?.add(dateDay);
            _checkList[__idx]
                .time
                ?.add(TimeModel(startTime: _stStr, endTime: _etStr));
            _selected = _checkList[__idx];
            _count++;
          });
          _openTimeCheck(dateDay, day);
        }
      }
    } else {
      if (_count < 3) {
        var _st = _startTime[_availableDays.indexOf(day % 7)];
        var _et = _endTime[_availableDays.indexOf(day % 7)];
        var _stStr = _timeIntToString24(_st);
        var _etStr = _timeIntToString24(_et);
        TimeModel _time = TimeModel(startTime: _stStr, endTime: _etStr);
        setState(() {
          _checkList.add(ScheduleProposalModel(
              dateDay: [dateDay],
              day: [day],
              time: [_time],
              month: _curDate.month,
              year: _curDate.year));
          _selected = _checkList.last;
          _count++;
        });
        _openTimeCheck(dateDay, day);
      }
    }
  }

  void _openTimeCheck(int selDateDay, int selDay) {
    var _selIdx = _availableDays.indexOf(selDay % 7);
    var _timeIdx = _selected.day!.indexOf(selDay);
    List<int> __startTime = [];
    List<int> __endTime = [];
    if (_selected.time != null) {
      __startTime = _timeStringToInt(_selected.time![_timeIdx].startTime);
      __endTime = _timeStringToInt(_selected.time![_timeIdx].endTime);
    } else {
      __startTime = _startTime[_selIdx];
      __endTime = _endTime[_selIdx];
    }
    showModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.35,
              child: Column(children: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey))),
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                      _curDate.month.toString() +
                          '월 ' +
                          selDateDay.toString() +
                          '일',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                ),
                Container(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                      top: MediaQuery.of(context).size.height * 0.02,
                      bottom: MediaQuery.of(context).size.height * 0.03,
                    ),
                    height: MediaQuery.of(context).size.height * 0.27,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RenderTimeRange(__startTime, __endTime),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: BigButton(
                                  btnColor: Colors.black,
                                  title: '확인',
                                  txtColor: Colors.white,
                                  press: () {
                                    var _st =
                                        _timeStringToInt(_startTimeStr.value);
                                    var _et =
                                        _timeStringToInt(_endTimeStr.value);
                                    setState(() {
                                      _selected.time![_timeIdx].startTime =
                                          _timeIntToString24(_st);
                                      _selected.time![_timeIdx].endTime =
                                          _timeIntToString24(_et);
                                    });
                                    Navigator.pop(context);
                                  }))
                        ]))
              ]));
        });
  }

  void _goBack() {
    Provider.of<Propose>(context, listen: false).flush();
    Navigator.pop(context);
  }

  void _goNext() {
    Provider.of<Propose>(context, listen: false).schedule = _checkList;
    Navigator.pushNamed(context, Routes.BOB_PROPOSE_LOCATION);
  }

  void _onPressCancel() {
    Provider.of<Propose>(context, listen: false).flush();
    Navigator.popUntil(context, ModalRoute.withName(Routes.MENTOR_DETAILS));
  }

  @override
  Widget build(context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: TopBarBackContents(
              pressBack: _goBack,
              title: '',
              icon1: Icon(Icons.cancel,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.width * 0.08),
              pressIcon1: _onPressCancel,
              bottomLine: false,
              backgroundColor: Colors.black,
            )),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              child: Text('직업인에게 제안할\n날짜와 시간을 선택해주세요.',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: MediaQuery.of(context).size.height * 0.0018))),
          Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.08,
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RenderYearMonth(),
                    Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.02)),
                    RenderDay(),
                    Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.02)),
                    RenderDateDays(_curDate),
                  ]))
        ]),
        bottomSheet: Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.08,
              top: MediaQuery.of(context).size.height * 0.03,
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05,
            ),
            child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.06,
                child: BigButton(
                    btnColor: Colors.black,
                    title: '다 음',
                    txtColor: Colors.white,
                    press: () {
                      _goNext();
                    }))));
  }

  Widget RenderYearMonth() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      GestureDetector(
          onTap: _prevMonth,
          child: Icon(Icons.arrow_back_ios,
              size: MediaQuery.of(context).size.width * 0.05)),
      Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02)),
      Text(_curDate.year.toString() + '년 ' + _curDate.month.toString() + '월',
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.05,
              fontWeight: FontWeight.bold)),
      Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02)),
      GestureDetector(
          onTap: _nextMonth,
          child: Icon(Icons.arrow_forward_ios,
              size: MediaQuery.of(context).size.width * 0.05)),
    ]);
  }

  Widget RenderDay() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
            _dayName.length,
            (index) => Text(_dayName[index],
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))));
  }

  Widget RenderDateDays(DateTime curDate) {
    var _year = curDate.year;
    var _month = curDate.month;
    var _startDate = DateTime(_year, _month, 1);
    var _endDate = DateTime(_year, _month + 1, 0);
    var _cnt = 1;
    List<int> _curMonthDays = [];
    for (var i = 0; i < 5; i++) {
      for (var j = 1; j < 8; j++) {
        if (_startDate.weekday > j && i == 0) {
          _curMonthDays.add(-1);
        } else if (_cnt > _endDate.day) {
          _curMonthDays.add(-1);
        } else {
          _curMonthDays.add(_cnt);
          _cnt++;
        }
      }
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
            5,
            (idx) => Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(7, (_idx) {
                        bool __isSelected = _selected.day != null
                            ? _selected.day!.contains(idx * 7 + _idx)
                            : false;
                        int __selIdx = idx * 7 + _idx;
                        return GestureDetector(
                            onTap: () => _curMonthDays[__selIdx] >= 0 &&
                                    _availableDays.contains(__selIdx % 7)
                                ? _selectDay(__selIdx, _curMonthDays[__selIdx])
                                : null,
                            child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: __isSelected
                                        ? BobColors.mainColor
                                        : null),
                                width: MediaQuery.of(context).size.width * 0.1,
                                height: MediaQuery.of(context).size.width * 0.1,
                                child: Text(
                                    _curMonthDays[__selIdx] >= 0
                                        ? _curMonthDays[__selIdx].toString()
                                        : '',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                        fontWeight: FontWeight.bold,
                                        color: _availableDays
                                                .contains(__selIdx % 7)
                                            ? __isSelected
                                                ? Colors.white
                                                : Colors.black
                                            : Colors.grey))));
                      })),
                  Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.01))
                ])));
  }

  Widget RenderTimeRange(List<int> startTime, List<int> endTime) {
    String __startTimeStr = _timeIntToString12(startTime);
    String __endTimeStr = _timeIntToString12(endTime);
    _startTimeStr.value = __startTimeStr;
    _endTimeStr.value = __endTimeStr;

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(children: [
        Text('시작',
            style: TextStyle(
                color: Colors.grey[600],
                fontSize: MediaQuery.of(context).size.width * 0.04)),
        Padding(
            padding:
                EdgeInsets.all(MediaQuery.of(context).size.height * 0.005)),
        Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * 0.04,
              bottom: MediaQuery.of(context).size.width * 0.04,
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.02,
            ),
            width: MediaQuery.of(context).size.width * 0.42,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(
                    color: Colors.black,
                    width: MediaQuery.of(context).size.width * 0.007),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ValueListenableBuilder(
                    builder:
                        (BuildContext context, String value, Widget? child) {
                      return Text(value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.bold,
                          ));
                    },
                    valueListenable: _startTimeStr,
                  ),
                  GestureDetector(
                      onTap: () async {
                        var _ret = await renderDialog(_startTimeStr.value);
                        _startTimeStr.value = _ret;
                      },
                      child: Icon(Icons.edit_outlined,
                          size: MediaQuery.of(context).size.width * 0.05,
                          color: Colors.grey[600]))
                ]))
      ]),
      Column(children: [
        Text('종료',
            style: TextStyle(
                color: Colors.grey[600],
                fontSize: MediaQuery.of(context).size.width * 0.04)),
        Padding(
            padding:
                EdgeInsets.all(MediaQuery.of(context).size.height * 0.005)),
        Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * 0.04,
              bottom: MediaQuery.of(context).size.width * 0.04,
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.02,
            ),
            width: MediaQuery.of(context).size.width * 0.42,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(
                    color: Colors.black,
                    width: MediaQuery.of(context).size.width * 0.007),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ValueListenableBuilder(
                    builder:
                        (BuildContext context, String value, Widget? child) {
                      return Text(value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.bold,
                          ));
                    },
                    valueListenable: _endTimeStr,
                  ),
                  GestureDetector(
                      onTap: () async {
                        var _ret = await renderDialog(_endTimeStr.value);
                        _endTimeStr.value = _ret;
                      },
                      child: Icon(Icons.edit_outlined,
                          size: MediaQuery.of(context).size.width * 0.05,
                          color: Colors.grey[600]))
                ]))
      ])
    ]);
  }

  Future<String> renderDialog(String intTime) async {
    List<String> _timeStr = intTime.split(' ');
    List<int> _timeInt =
        _timeStr[1].split(':').map((el) => int.parse(el)).toList();
    List<int> _selTimeInt = _timeInt;
    ValueNotifier<String> _ampm = ValueNotifier<String>(_timeStr[0]);

    String? ret = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.16,
                  child: Column(children: [
                    Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.black12))),
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.03,
                          right: MediaQuery.of(context).size.width * 0.03,
                          top: MediaQuery.of(context).size.height * 0.03,
                          bottom: MediaQuery.of(context).size.height * 0.03,
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ValueListenableBuilder(
                                builder: (BuildContext context, String value,
                                    Widget? child) {
                                  return GestureDetector(
                                      onTap: () {
                                        _ampm.value =
                                            _ampm.value == '오전' ? '오후' : '오전';
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
                                                          BorderRadius.circular(
                                                              5),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          spreadRadius: 2,
                                                          blurRadius: 4,
                                                          offset: const Offset(
                                                              0,
                                                              1), // changes position of shadow
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
                                valueListenable: _ampm,
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.02,
                                    right: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.24,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
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
                                                    (value) => _selTimeInt[0] =
                                                        hour[value],
                                                itemExtent: 25,
                                                useMagnifier: true,
                                                scrollController:
                                                    FixedExtentScrollController(
                                                        initialItem:
                                                            _timeInt[0] - 1))),
                                        Text(':',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
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
                                              onSelectedItemChanged: (value) =>
                                                  _selTimeInt[1] =
                                                      int.parse(min[value]),
                                              itemExtent: 25,
                                              useMagnifier: true,
                                            )),
                                      ]))
                            ])),
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.012,
                          bottom: MediaQuery.of(context).size.height * 0.012,
                          left: MediaQuery.of(context).size.width * 0.04,
                          right: MediaQuery.of(context).size.width * 0.04,
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('재설정',
                                  style: TextStyle(
                                      color: BobColors.mainColor,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                      fontWeight: FontWeight.bold)),
                              GestureDetector(
                                  onTap: () {
                                    final String _strTime = _ampm.value +
                                        ' ' +
                                        _timeIntToString24(_selTimeInt);
                                    Navigator.pop(context, _strTime);
                                  },
                                  child: Text('확인',
                                      style: TextStyle(
                                          color: BobColors.mainColor,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          fontWeight: FontWeight.bold))),
                            ]))
                  ])));
        });
    return ret!;
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
