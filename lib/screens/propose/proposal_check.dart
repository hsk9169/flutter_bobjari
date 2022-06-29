import 'dart:convert';
import 'package:bobjari_proj/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:bobjari_proj/models/mentor/mentor.dart';
import 'package:bobjari_proj/models/user_model.dart';
import 'package:bobjari_proj/models/preference/schedule.dart';
import 'package:bobjari_proj/models/preference/location.dart';
import 'package:bobjari_proj/models/proposal_model.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/session_provider.dart';
import 'package:bobjari_proj/providers/propose_provider.dart';
import 'package:bobjari_proj/widgets/topbar_back_contents.dart';
import 'package:bobjari_proj/const/etc.dart';
import 'package:bobjari_proj/routes/routes.dart';
import 'package:bobjari_proj/widgets/big_button.dart';
import 'package:bobjari_proj/services/real_api_service.dart';

class ProposalCheckView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProposalCheckView();
}

class _ProposalCheckView extends State<ProposalCheckView> {
  RealApiService _apiService = RealApiService();
  late UserModel _user;
  late MentorModel _mentorDetails;
  List<ScheduleProposalModel> _scheduleList = [];
  List<LocationModel> _locationList = [];
  late ProposalModel _proposal;
  late ScrollController _scrollController;

  @override
  void initState() {
    _initializeData();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeData() {
    setState(() {
      _mentorDetails =
          Provider.of<Propose>(context, listen: false).mentorDetails;
      _user = Provider.of<Session>(context, listen: false).user;
      _scheduleList =
          Provider.of<Propose>(context, listen: false).scheduleCheck;
      Provider.of<Propose>(context, listen: false)
          .locationCheck
          .forEach((element) {
        _locationList
            .add(_mentorDetails.details!.preference!.location![element]);
      });
      _proposal = ProposalModel(
          schedule: _scheduleList,
          location: _locationList,
          fee: _mentorDetails.details!.preference!.fee);
    });
    print(_proposal.toJson());
  }

  void _goBack() {
    Navigator.pop(context);
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print('bottom');
    }
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      print('top');
    }
  }

  void _editSchedule() {
    Navigator.popUntil(
        context, ModalRoute.withName(Routes.BOB_PROPOSE_SCHEDULE));
  }

  void _editLocation() {
    Navigator.popUntil(
        context, ModalRoute.withName(Routes.BOB_PROPOSE_LOCATION));
  }

  void _propose() async {
    final String _menteeId = _user.mentee!.id!;
    final String _mentorId = _mentorDetails.id!;
    final String _ret = await _apiService.createBobjari(
        _menteeId, _mentorId, json.encode(_proposal.toJson()));
    if (_ret == 'success') {
      Provider.of<Propose>(context, listen: false).flush();
      renderDialog();
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: TopBarBackContents(
              pressBack: _goBack,
              title: '밥자리 신청 확인',
              bottomLine: true,
            )),
        body: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.05),
                child: Column(children: [
                  renderMentorInfo(),
                  _spacer(),
                  renderProposeInfo(),
                  _spacer(),
                  renderFee(),
                  _spacer(),
                  renderNotice(),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: BigButton(
                          btnColor: BobColors.mainColor,
                          title: '밥자리 신청 보내기',
                          txtColor: Colors.white,
                          press: () => _propose()))
                ]))));
  }

  Widget renderMentorInfo() {
    var _rate = _mentorDetails.metadata!.rate!.num != 0
        ? (_mentorDetails.metadata!.rate!.score! /
                _mentorDetails.metadata!.rate!.num!)
            .toStringAsFixed(1)
        : '0.0';
    return Container(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
          top: MediaQuery.of(context).size.width * 0.08,
          bottom: MediaQuery.of(context).size.width * 0.08,
        ),
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('멘토 정보',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.055,
                  fontWeight: FontWeight.bold)),
          Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.015)),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              child: Row(children: [
                Expanded(
                    flex: 4,
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: Uri.parse(_mentorDetails.userDetail!.profile!
                                            .profileImage!.data!)
                                        .data !=
                                    null
                                ? Image.memory(
                                        Uri.parse(_mentorDetails.userDetail!
                                                .profile!.profileImage!.data!)
                                            .data!
                                            .contentAsBytes(),
                                        gaplessPlayback: true)
                                    .image
                                : const AssetImage('assets/images/dog.png'),
                            fit: BoxFit.cover,
                          ),
                        ))),
                const Expanded(flex: 1, child: SizedBox()),
                Expanded(
                    flex: 20,
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.09,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  _mentorDetails
                                          .userDetail!.profile!.nickname! +
                                      ' ' +
                                      String.fromCharCode(0x00B7) +
                                      ' ' +
                                      _mentorDetails.career!.job!,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.045,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false),
                              Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width *
                                          0.005)),
                              Text(
                                  _mentorDetails.career!.years != null
                                      ? Etc.careerYear[
                                              _mentorDetails.career!.years!] +
                                          ' ' +
                                          String.fromCharCode(0x00B7) +
                                          ' ' +
                                          _mentorDetails.career!.company!
                                      : '',
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false),
                              Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width *
                                          0.005)),
                              Row(children: [
                                Icon(Icons.star,
                                    size: MediaQuery.of(context).size.width *
                                        0.035,
                                    color: Colors.deepOrange),
                                Padding(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            0.003)),
                                Text(
                                    _mentorDetails.metadata!.rate!.num! == 0
                                        ? '0.0'
                                        : _rate,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.035,
                                        color: Colors.grey)),
                                Text(
                                    '(' +
                                        _mentorDetails.metadata!.rate!.num
                                            .toString() +
                                        ')',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.035,
                                        color: Colors.grey))
                              ])
                            ])))
              ]))
        ]));
  }

  Widget renderProposeInfo() {
    return Container(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
          top: MediaQuery.of(context).size.width * 0.08,
          bottom: MediaQuery.of(context).size.width * 0.08,
        ),
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('신청 정보',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.055,
                  fontWeight: FontWeight.bold)),
          Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.04)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('날짜 / 시간',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontWeight: FontWeight.bold)),
            GestureDetector(
                onTap: () => _editSchedule(),
                child: Text('수정',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    )))
          ]),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: renderScheduleList()),
          Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.04)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('장소',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.bold)),
              GestureDetector(
                  onTap: () => _editLocation(),
                  child: Text('수정',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      )))
            ],
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: renderLocationList()),
        ]));
  }

  List<Widget> renderScheduleList() {
    List<String> __schedule = [];
    _scheduleList.forEach((el) {
      el.day!.forEach((_el) {
        var idx = el.day!.indexOf(_el);
        var startTime =
            _timeIntToString12(_timeStringToInt(el.time![idx].startTime));
        var endTime =
            _timeIntToString12(_timeStringToInt(el.time![idx].endTime));
        __schedule.add(
            '${el.year.toString()}.${el.month.toString()}.$_el  $startTime - $endTime');
      });
    });
    return List.generate(
        __schedule.length,
        (index) => Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.007),
            child: Text(__schedule[index],
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: MediaQuery.of(context).size.width * 0.045))));
  }

  List<Widget> renderLocationList() {
    return List.generate(
        _locationList.length,
        (index) => Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.007),
            child: Text(_locationList[index].placeName,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: MediaQuery.of(context).size.width * 0.045))));
  }

  Widget renderFee() {
    var __fee = _mentorDetails.details!.preference!.fee;
    return Container(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
          top: MediaQuery.of(context).size.width * 0.08,
          bottom: MediaQuery.of(context).size.width * 0.08,
        ),
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('감사비',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.055,
                  fontWeight: FontWeight.bold)),
          Text(
              __fee!.select == 0
                  ? '시간 당 ${__fee.value}원'
                  : __fee.select == 1
                      ? '식사 대접으로 충분해요'
                      : __fee.select == 2
                          ? '커피 대접으로 충분해요'
                          : '고민 중이에요',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.055,
                  fontWeight: FontWeight.bold))
        ]));
  }

  Widget renderNotice() {
    return Container(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.04,
          right: MediaQuery.of(context).size.width * 0.04,
          top: MediaQuery.of(context).size.width * 0.08,
          bottom: MediaQuery.of(context).size.width * 0.08,
        ),
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: Icon(Icons.info_outline,
                      size: MediaQuery.of(context).size.width * 0.12)),
              Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01)),
              Expanded(
                  flex: 7,
                  child: Text(
                      '직업인이 수락하기 전까지 밥자리는 확정된 것이 아닙니다. 직업인의 응답 이후 결제가 가능합니다.',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.041,
                          fontWeight: FontWeight.bold)))
            ]));
  }

  void renderDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(const Duration(seconds: 2), () async {
            Navigator.popUntil(
                context, ModalRoute.withName(Routes.MENTOR_DETAILS));
          });
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              backgroundColor: Colors.grey[800],
              child: Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(),
                        Icon(Icons.check,
                            size: MediaQuery.of(context).size.width * 0.4,
                            color: Colors.white),
                        Text(
                          '밥자리 신청 완료',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ])));
        });
  }

  Widget _spacer() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        height: MediaQuery.of(context).size.height * 0.005,
        width: MediaQuery.of(context).size.width);
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
