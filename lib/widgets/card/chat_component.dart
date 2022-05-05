import 'package:flutter/material.dart';

class ChatComponentCard extends StatelessWidget {
  final String? bobjariId;
  final String? profileImage;
  final String? nickname;
  final String? job;
  final String? message;
  final int? status;
  final String? updatedAt;

  const ChatComponentCard(
      {Key? key,
      this.bobjariId,
      this.profileImage,
      this.nickname,
      this.job,
      this.message,
      this.status,
      this.updatedAt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.1,
        child: Row(children: [
          Expanded(
              flex: 1,
              child: Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: Image.memory(Uri.parse(profileImage!)
                                  .data!
                                  .contentAsBytes())
                              .image,
                          fit: BoxFit.cover,
                        ),
                      )))),
          Expanded(
              flex: 3,
              child: Row(children: [
                Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.01)),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Row(children: [
                        Text(nickname!,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.037,
                                fontWeight: FontWeight.bold)),
                        Text(' ' + String.fromCharCode(0x00B7) + ' '),
                        Text(job!,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false)
                      ]),
                      Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.003)),
                      Text(message != null ? message! : '[ 대화를 시작해보세요! ]',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.034,
                              fontWeight: FontWeight.normal),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false),
                      Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.003)),
                      Text(statusString(status!),
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.031,
                              fontWeight: FontWeight.normal),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false),
                      Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.003)),
                      Text('socket_token: ' + bobjariId!,
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.028,
                              fontWeight: FontWeight.normal),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false),
                    ]))
              ])),
          Expanded(
            flex: 1,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(dateTimeString(updatedAt!),
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: MediaQuery.of(context).size.width * 0.028,
                      ))
                ]),
          )
        ]));
  }

  String statusString(int _status) {
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

  String dateTimeString(String _dt) {
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
      }
    } else if (_lastDayOfMonth.year == _last.year &&
        _lastDayOfMonth.month == _last.month &&
        _lastDayOfMonth.day == _last.day) {
      _ret = '어제';
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
