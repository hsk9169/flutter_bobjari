import 'package:flutter/material.dart';
import 'package:bobjari_proj/models/review_model.dart';

class ReviewView extends StatefulWidget {
  final List<ReviewModel>? reviews;
  final String? rate;
  const ReviewView({this.reviews, this.rate});
  @override
  State<StatefulWidget> createState() => _ReviewView();
}

class _ReviewView extends State<ReviewView> {
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
          Row(children: [
            SizedBox(
                child: Row(children: [
              Icon(Icons.star,
                  size: MediaQuery.of(context).size.width * 0.05,
                  color: Colors.deepOrange),
              Text(
                  widget.rate! +
                      ' ' +
                      String.fromCharCode(0x00B7) +
                      ' 후기 ' +
                      widget.reviews!.length.toString() +
                      '개',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      fontWeight: FontWeight.bold))
            ])),
            Spacer(),
            GestureDetector(
                onTap: () {
                  print('more reviews');
                },
                child: Text('더 보기',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.bold)))
          ]),
          Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.02)),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: List<Widget>.generate(
                      widget.reviews!.length, (idx) => _card(idx))))
        ]));
  }

  Widget _card(int _idx) {
    return Row(children: [
      SizedBox(
          width: MediaQuery.of(context).size.width * 0.65,
          height: MediaQuery.of(context).size.height * 0.26,
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.width * 0.1,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: DecorationImage(
                              image: Uri.parse(widget
                                              .reviews![_idx]
                                              .mentee!
                                              .userDetail!
                                              .profile!
                                              .profileImage!
                                              .data!)
                                          .data !=
                                      null
                                  ? Image.memory(
                                          Uri.parse(widget
                                                  .reviews![_idx]
                                                  .mentee!
                                                  .userDetail!
                                                  .profile!
                                                  .profileImage!
                                                  .data!)
                                              .data!
                                              .contentAsBytes(),
                                          gaplessPlayback: true)
                                      .image
                                  : const AssetImage('assets/images/dog.png'),
                              fit: BoxFit.cover,
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.01)),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                widget.reviews![_idx].mentee!.userDetail!
                                    .profile!.nickname!,
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                _dateTimeString(
                                    widget.reviews![_idx].createdAt!),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03,
                                    fontWeight: FontWeight.normal)),
                          ])
                    ]),
                    Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.02)),
                    Text(widget.reviews![_idx].body!,
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.018,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            height: MediaQuery.of(context).size.width * 0.004),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                        softWrap: true)
                  ]))),
      Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01)),
    ]);
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
