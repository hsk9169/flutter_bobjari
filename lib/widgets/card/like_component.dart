import 'package:flutter/material.dart';
import 'package:bobjari_proj/models/mentor/mentor.dart';
import 'package:bobjari_proj/const/etc.dart';

class LikeComponentCard extends StatelessWidget {
  final MentorModel? mentor;

  const LikeComponentCard({
    Key? key,
    this.mentor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _userDetails = mentor!.userDetail;
    var _career = mentor!.career;
    var _feeSel = mentor!.details!.preference!.fee!.select;
    var _fee;
    if (_feeSel == 0) {
      _fee = mentor!.details!.preference!.fee!.value;
    } else if (_feeSel == 1) {
      _fee = '식사 대접';
    } else if (_feeSel == 2) {
      _fee = '커피 대접';
    } else {
      _fee = '고민 중';
    }
    var _metadata = mentor!.metadata;
    var _rate = _metadata!.rate!.num != 0
        ? (_metadata.rate!.score! / _metadata.rate!.num!).toStringAsFixed(1)
        : '0.0';
    var _title = _userDetails!.profile!.nickname! +
        ' ' +
        String.fromCharCode(0x00B7) +
        ' ' +
        _career!.job!;

    return Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              blurStyle: BlurStyle.outer,
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.12,
        child: Row(children: [
          Expanded(
              flex: 1,
              child: Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.13,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: Uri.parse(_userDetails!
                                          .profile!.profileImage!.data!)
                                      .data !=
                                  null
                              ? Image.memory(
                                      Uri.parse(_userDetails
                                              .profile!.profileImage!.data!)
                                          .data!
                                          .contentAsBytes(),
                                      gaplessPlayback: true)
                                  .image
                              : const AssetImage('assets/images/dog.png'),
                          fit: BoxFit.contain,
                        ),
                      )))),
          Expanded(
              flex: 3,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.51),
                        child: Text(_title,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false)),
                    Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.003)),
                    Text(
                        _career.years != null
                            ? Etc.careerYear[_career.years!] +
                                ' ' +
                                String.fromCharCode(0x00B7) +
                                ' ' +
                                _career.company!
                            : '',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.032,
                            fontWeight: FontWeight.normal),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false),
                    Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.006)),
                    Row(children: [
                      Icon(Icons.star,
                          size: MediaQuery.of(context).size.width * 0.03,
                          color: Colors.deepOrange),
                      Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.003)),
                      Text(_rate,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                              color: Colors.grey)),
                      Text('(' + _metadata.rate!.num.toString() + ')',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                              color: Colors.grey))
                    ]),
                  ])),
          Expanded(
            flex: 1,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_feeSel == 0 ? '1시간' : '',
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: MediaQuery.of(context).size.width * 0.031,
                      )),
                  Text(
                      _feeSel == 0
                          ? _fee + '원'
                          : _feeSel == 1
                              ? '식사 대접'
                              : _feeSel == 2
                                  ? '커피 대접'
                                  : '몸값 고민 중',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                      ))
                ]),
          )
        ]));
  }

  String _statusString(int _status) {
    switch (_status) {
      case 1:
        return '밥자리 응답 기다리는 중';
      case 2:
        return '밥자리 수락 및 응답 도착';
      case 3:
        return '밥자리 확정 완료';
      case 4:
        return '밥자리 종료';
      default:
        return '';
    }
  }

  String _dateTimeString(String _dt) {
    var _now = DateTime.now();
    var _last = DateTime.parse(_dt);
    var _lastDayOfMonth = DateTime(_now.year, _now.month, 0);
    String _ret = '';
    if (_now.year == _last.year && _now.month == _last.month) {
      if (_now.day == _last.day) {
        if (_last.hour < 13) {
          _ret += '오전 ';
          _ret += _last.hour.toString();
        } else {
          _ret += '오후 ';
          _ret += (_last.hour - 12).toString();
        }
        _ret += ':';
        _ret +=
            _last.minute < 10 ? '0${_last.minute}' : _last.minute.toString();
      } else if (_now.day - _last.day == 1) {
        _ret = '어제';
      } else {
        _ret = _last.month.toString() + '월 ' + _last.day.toString() + '일';
      }
    } else if (_now.year == _last.year &&
        _now.month - _last.month == 1 &&
        _now.day == 1) {
      if (_lastDayOfMonth.year == _last.year &&
          _lastDayOfMonth.month == _last.month &&
          _lastDayOfMonth.day == _last.day) {
        _ret = '어제';
      } else {
        _ret = _last.month.toString() + '월 ' + _last.day.toString() + '일';
      }
    } else if (_now.year - _last.year > 0) {
      _ret = _last.year.toString() +
          '.' +
          _last.month.toString() +
          '.' +
          _last.day.toString();
    } else {
      _ret = _last.month.toString() + '월 ' + _last.day.toString() + '일';
    }
    return _ret;
  }
}
