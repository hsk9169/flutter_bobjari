import 'package:bobjari_proj/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/session_provider.dart';
import 'package:bobjari_proj/providers/propose_provider.dart';
import 'package:bobjari_proj/services/real_api_service.dart';
import 'package:bobjari_proj/services/fake_api_service.dart';
import 'package:bobjari_proj/routes/routes.dart';
import 'package:bobjari_proj/widgets/topbar_back_contents.dart';
import 'package:bobjari_proj/widgets/big_button.dart';
import './main_info.dart';
import './introduce.dart';
import './topics.dart';
import './schedules.dart';
import './places.dart';
import './reviews.dart';

class MentorDetails extends StatefulWidget {
  final String? arg;
  const MentorDetails(this.arg);
  @override
  State<StatefulWidget> createState() => _MentorDetails();
}

class _MentorDetails extends State<MentorDetails> {
  final RealApiService _apiService = RealApiService();
  //FakeApiService _apiService = FakeApiService();
  late var _future;
  late ScrollController _scrollController;
  var _like;
  var _mentorDetails;

  @override
  void initState() {
    _future = _getMentor();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<dynamic>>? _getMentor() async {
    var _menteeId =
        Provider.of<Session>(context, listen: false).user.mentee != null
            ? Provider.of<Session>(context, listen: false).user.mentee!.id!
            : 'none';
    var _mentorId = widget.arg!;
    var res = await _apiService.getMentorDetails(_menteeId, _mentorId);
    setState(() {
      _like = res[1];
      _mentorDetails = res[0];
    });
    return res;
  }

  void _onPressShare() {
    print('share');
  }

  void _onPressLike() async {
    var _menteeId =
        Provider.of<Session>(context, listen: false).user.mentee != null
            ? Provider.of<Session>(context, listen: false).user.mentee!.id!
            : 'none';
    var _mentorId = widget.arg!;
    var _res;
    if (_like) {
      // Delete Like
      _res = await _apiService.deleteLike(_menteeId, _mentorId);
      if (_res == 1) {
        setState(() => _like = !_like);
      }
    } else {
      // Create Like
      _res = await _apiService.createLike(_menteeId, _mentorId);
      if (_res == 'success') {
        setState(() => _like = !_like);
      }
    }
  }

  void _propose() {
    print(Provider.of<Session>(context, listen: false).user.userId);
    if (Provider.of<Session>(context, listen: false).user.userId == null) {
      Navigator.pushNamed(context, Routes.WELCOME);
    } else {
      Provider.of<Propose>(context, listen: false).mentor = _mentorDetails;
      Navigator.pushNamed(context, Routes.BOB_PROPOSE_SCHEDULE);
    }
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

  @override
  Widget build(BuildContext context) {
    var _menteeId =
        Provider.of<Session>(context, listen: false).user.mentee != null
            ? Provider.of<Session>(context, listen: false).user.mentee!.id!
            : null;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: TopBarBackContents(
              pressBack: _goBack,
              title: '',
              icon1: Icon(Icons.ios_share,
                  size: MediaQuery.of(context).size.width * 0.08),
              pressIcon1: _onPressShare,
              icon2: _menteeId != null
                  ? _like != null && _like
                      ? Icon(Icons.favorite,
                          size: MediaQuery.of(context).size.width * 0.08,
                          color: Colors.red)
                      : Icon(
                          Icons.favorite_border,
                          size: MediaQuery.of(context).size.width * 0.08,
                        )
                  : null,
              pressIcon2: _onPressLike,
              bottomLine: true,
            )),
        body: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.12,
                ),
                child: FutureBuilder<List<dynamic>?>(
                    future: _future,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<dynamic>?> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        var _mentor = snapshot.data![0];
                        var _rate = _mentor.metadata.rate.num != 0
                            ? (_mentor.metadata.rate.score /
                                    _mentor.metadata.rate.num)
                                .toStringAsFixed(1)
                            : '0.0';
                        return Column(children: [
                          MainInfoView(mentor: _mentor),
                          _spacer(),
                          IntroduceView(
                            title: _mentor.title ?? '',
                            introduce: _mentor.details.introduce ?? '',
                          ),
                          _spacer(),
                          TopicsView(topics: _mentor.career.topics ?? []),
                          _spacer(),
                          ScheduleView(
                              schedules:
                                  _mentor.details.preference.schedule ?? []),
                          _spacer(),
                          PlacesView(
                              places:
                                  _mentor.details.preference.location ?? []),
                          _spacer(),
                          ReviewView(
                              reviews: _mentor.review.reversed.toList() ?? [],
                              rate: _rate),
                        ]);
                      }
                    }))),
        bottomSheet: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05,
              top: MediaQuery.of(context).size.height * 0.02,
              bottom: MediaQuery.of(context).size.height * 0.03,
            ),
            child: FutureBuilder<List<dynamic>?>(
                future: _future,
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>?> snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox();
                  } else {
                    var _mentor = snapshot.data![0];
                    return Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.03,
                          right: MediaQuery.of(context).size.width * 0.03,
                        ),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.06,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                        Text(
                                            _mentor.details!.preference!.fee!
                                                        .select ==
                                                    0
                                                ? _mentor.details!.preference!
                                                        .fee!.value +
                                                    '원'
                                                : _mentor.details!.preference!
                                                            .fee!.select ==
                                                        1
                                                    ? '식사 대접'
                                                    : _mentor
                                                                .details!
                                                                .preference!
                                                                .fee!
                                                                .select ==
                                                            2
                                                        ? '커피 대접'
                                                        : '',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.06,
                                                fontWeight: FontWeight.bold)),
                                        Text(_mentor.details!.preference!.fee!
                                                    .select ==
                                                0
                                            ? '/1시간'
                                            : '')
                                      ])),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: BobColors.mainColor,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                              )),
                                          child: Text('밥자리 신청',
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                          onPressed: () {
                                            _propose();
                                          }))
                                ])));
                  }
                })));
  }

  Widget _spacer() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        height: MediaQuery.of(context).size.height * 0.005,
        width: MediaQuery.of(context).size.width);
  }
}
