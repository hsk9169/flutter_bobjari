import 'dart:async';
import 'package:bobjari_proj/services/real_api_service.dart';
import 'package:bobjari_proj/widgets/signup_form.dart';
import 'package:bobjari_proj/widgets/topbar_back_contents.dart';
import 'package:flutter/material.dart';
import 'package:bobjari_proj/const/colors.dart';
import 'package:bobjari_proj/providers/signup_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bobjari_proj/providers/session_provider.dart';
import 'package:bobjari_proj/models/signup_model.dart';
import 'package:bobjari_proj/routes/routes.dart';

class SignupMenteeInterestsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupMenteeInterestsView();
}

class _SignupMenteeInterestsView extends State<SignupMenteeInterestsView> {
  final RealApiService _apiService = RealApiService();
  final TextEditingController _textController = TextEditingController();
  String _query = '';
  List<String> _interests = [];
  var _isSearchbarTapped = false;
  ValueNotifier<bool> _isModalCloseTapped = ValueNotifier<bool>(false);
  ValueNotifier<bool> _isItemTapped = ValueNotifier<bool>(false);
  ValueNotifier<bool> _isWriteDirectTapped = ValueNotifier<bool>(false);

  Timer? _timer;
  bool _found = false;
  ValueNotifier<int> _selected = ValueNotifier<int>(-1);
  ValueNotifier<List<String>> _suggestionList = ValueNotifier<List<String>>([]);

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _textController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onChanged() async {
    if (_textController.text != _query) {
      setState(() {
        _query = _textController.text;
        _suggestionList.value = [];
        _found = false;
      });
      _timer?.cancel();
      _getSuggestions();
    }
  }

  void _pressBack() {
    Navigator.pop(context);
  }

  void _getSuggestions() {
    if (_query != '') {
      _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) async {
        final _res = await _apiService.autocompleteJob(_query, '10');
        _timer?.cancel();
        setState(() {
          _suggestionList.value = _res;
          _found = true;
        });
      });
    }
  }

  void _onSubmit() async {
    SignupModel _reqModel;
    var _jwt;
    var _user;
    Provider.of<Signup>(context, listen: false).show();
    String? _deviceToken = await FirebaseMessaging.instance.getToken();
    _reqModel = SignupModel(
        email: Provider.of<Signup>(context, listen: false).email,
        phone: Provider.of<Signup>(context, listen: false).phone,
        nickname: Provider.of<Signup>(context, listen: false).nickname,
        age: Provider.of<Signup>(context, listen: false).age,
        gender: Provider.of<Signup>(context, listen: false).gender,
        image: Provider.of<Signup>(context, listen: false).image,
        role: Provider.of<Signup>(context, listen: false).role,
        interests: _interests,
        deviceToken: _deviceToken);

    _user = await _apiService.signUpBob(_reqModel);
    if (_user.profile?.nickname == _reqModel.nickname) {
      _jwt = await _apiService
          .getJWT(_user.profile?.phone ?? _user.profile?.email);
      Provider.of<Session>(context, listen: false).user = _user;
      Provider.of<Session>(context, listen: false).token = _jwt;
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.SERVICE, (Route<dynamic> route) => false);
    } else {
      throw Exception('user profile not found');
    }
  }

  void _openSearchJob() {
    showModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Column(children: [
                    GestureDetector(
                        onTapDown: (details) {
                          _isModalCloseTapped.value = true;
                        },
                        onTapUp: (details) {
                          Future.delayed(const Duration(milliseconds: 100), () {
                            _isModalCloseTapped.value = false;
                            Navigator.pop(context);
                          });
                        },
                        onTapCancel: () {
                          Future.delayed(const Duration(milliseconds: 100), () {
                            _isModalCloseTapped.value = false;
                          });
                        },
                        child: ValueListenableBuilder(
                          builder: (BuildContext context, bool value,
                              Widget? child) {
                            return Container(
                                alignment: Alignment.centerRight,
                                child: Text('닫기',
                                    style: TextStyle(
                                        color: value
                                            ? Colors.cyan[200]
                                            : Colors.cyan[600],
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                        fontWeight: FontWeight.normal)));
                          },
                          valueListenable: _isModalCloseTapped,
                        )),
                    Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.015)),
                    renderSearchBar(),
                    Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.005)),
                    ValueListenableBuilder(
                      builder: (BuildContext context, List<String> value,
                          Widget? child) {
                        return renderJobList(value);
                      },
                      valueListenable: _suggestionList,
                    ),
                  ])));
        });
  }

  @override
  Widget build(BuildContext context) {
    return SignupForm(
      isbasePadding: true,
      child: Column(children: [
        GestureDetector(
            onTapDown: (details) {
              setState(() {
                _isSearchbarTapped = true;
              });
            },
            onTapUp: (details) {
              Future.delayed(const Duration(milliseconds: 100), () {
                setState(() {
                  _isSearchbarTapped = false;
                });
                _openSearchJob();
              });
            },
            onTapCancel: () {
              Future.delayed(const Duration(milliseconds: 100), () {
                setState(() {
                  _isSearchbarTapped = false;
                });
              });
            },
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: BobColors.mainColor, width: 2),
                    borderRadius: BorderRadius.circular(30)),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.06,
                child: Row(children: [
                  const Padding(padding: EdgeInsets.all(7)),
                  Icon(Icons.search,
                      size: MediaQuery.of(context).size.height * 0.035,
                      color: BobColors.mainColor),
                  const Padding(padding: EdgeInsets.all(3)),
                  Text('직업명을 입력해주세요.',
                      style: TextStyle(
                          color: _isSearchbarTapped
                              ? Colors.grey[300]
                              : Colors.grey[600],
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          fontWeight: FontWeight.bold))
                ]))),
        Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03)),
        SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 4,
                runSpacing: 4,
                children:
                    List.generate(_interests.length, (idx) => renderChip(idx))))
      ]),
      topTitle: const ['관심있는 직업이 무엇인가요?', ''],
      btn1Title: '예비직업인 등록 완료',
      btn1Color: BobColors.mainColor,
      pressBack: _pressBack,
      pressBtn1: _onSubmit,
    );
  }

  Widget renderSearchBar() {
    return Container(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.03,
          right: MediaQuery.of(context).size.width * 0.03,
        ),
        decoration: BoxDecoration(
            border: Border.all(color: BobColors.mainColor, width: 2),
            borderRadius: BorderRadius.circular(30)),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.06,
        alignment: Alignment.center,
        child: TextField(
            onSubmitted: (_value) {},
            textAlignVertical: TextAlignVertical.bottom,
            autofocus: true,
            decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.cancel),
                    color: Colors.grey,
                    onPressed: () {
                      _textController.text = '';
                      setState(() {
                        _query = '';
                      });
                    }),
                hintText: '직업명, 직군, 회사 등'),
            controller: _textController,
            keyboardType: TextInputType.text));
  }

  Widget renderJobList(List<String> list) {
    return _query != ''
        ? !_found
            ? const Text('검색 중...')
            : _suggestionList.value.isEmpty
                ? Column(children: [
                    Text('검색결과가 없습니다.',
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width * 0.04)),
                    Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.01)),
                    GestureDetector(
                        onTapDown: (details) {
                          _isWriteDirectTapped.value = true;
                        },
                        onTapUp: (details) {
                          Future.delayed(const Duration(milliseconds: 100), () {
                            _isWriteDirectTapped.value = false;
                            setState(() {
                              _interests.add(_textController.text);
                            });
                          });
                          Navigator.pop(context);
                        },
                        onTapCancel: () {
                          Future.delayed(const Duration(milliseconds: 100), () {
                            _isWriteDirectTapped.value = false;
                          });
                        },
                        child: ValueListenableBuilder(
                          builder: (BuildContext context, bool value,
                              Widget? child) {
                            return Text('직접 입력을 원하시면 탭!',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                    color: value
                                        ? Colors.cyan[300]
                                        : Colors.cyan[600],
                                    fontWeight: FontWeight.bold));
                          },
                          valueListenable: _isWriteDirectTapped,
                        ))
                  ])
                : Column(
                    children: List.generate(
                        list.length,
                        (idx) => GestureDetector(
                            onTapDown: (details) {
                              _isItemTapped.value = true;
                              _selected.value = idx;
                            },
                            onTapUp: (details) {
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                _isItemTapped.value = false;
                                _selected.value = -1;
                                setState(() {
                                  _interests.add(_suggestionList.value[idx]);
                                });
                                Navigator.pop(context);
                              });
                            },
                            onTapCancel: () {
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                _isItemTapped.value = false;
                                _selected.value = -1;
                              });
                            },
                            child: ValueListenableBuilder(
                                builder: (BuildContext context, int value,
                                    Widget? child) {
                                  return Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                        color: value == idx
                                            ? Colors.grey[200]
                                            : Colors.white,
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200] ??
                                                    Colors.black12))),
                                    padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.015,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.015,
                                      left: MediaQuery.of(context).size.width *
                                          0.03,
                                      right: MediaQuery.of(context).size.width *
                                          0.03,
                                    ),
                                    child: Text(list[idx],
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        softWrap: false),
                                  );
                                },
                                valueListenable: _selected))))
        : SizedBox();
  }

  Widget renderChip(int idx) {
    return Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * 0.03,
          bottom: MediaQuery.of(context).size.width * 0.03,
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
        ),
        decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(
                color: BobColors.mainColor,
                width: MediaQuery.of(context).size.width * 0.005),
            borderRadius: BorderRadius.circular(30)),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(_interests[idx],
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      fontWeight: FontWeight.bold)),
              Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01)),
              GestureDetector(
                  onTap: () => setState(() {
                        _interests.removeAt(idx);
                      }),
                  child: Icon(Icons.clear_outlined,
                      size: MediaQuery.of(context).size.width * 0.04))
            ]));
  }
}
