import 'package:flutter/material.dart';
import 'package:bobjari_proj/models/preference/schedule.dart';

class ScheduleView extends StatefulWidget {
  final List<SchedulePreferenceModel>? schedules;
  const ScheduleView({this.schedules});
  @override
  State<StatefulWidget> createState() => _ScheduleView();
}

class _ScheduleView extends State<ScheduleView> {
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
          Text('일정',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                  fontWeight: FontWeight.bold)),
          Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.02)),
          Column(
              children: List<Widget>.generate(
                  widget.schedules!.length, (idx) => _row(idx)))
        ]));
  }

  Widget _row(int _idx) {
    var _startTime = widget.schedules![_idx].startTime.split(':');
    var _endTime = widget.schedules![_idx].endTime.split(':');
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
        child: Text(
            widget.schedules![_idx].day +
                ' ' +
                _startTime[0] +
                '시 ' +
                _startTime[1] +
                '분 - ' +
                _endTime[0] +
                '시 ' +
                _endTime[1] +
                '분',
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04)));
  }
}
