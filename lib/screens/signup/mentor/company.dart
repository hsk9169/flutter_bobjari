import 'dart:async';
import 'package:bobjari_proj/services/real_api_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bobjari_proj/widgets/signup_form.dart';
import 'package:bobjari_proj/widgets/topbar_back_contents.dart';
import 'package:flutter/material.dart';
import 'package:bobjari_proj/const/colors.dart';
import 'package:bobjari_proj/providers/signup_provider.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/session_provider.dart';
import 'package:bobjari_proj/routes/routes.dart';
import 'package:bobjari_proj/screens/signup/mentor/company.dart';
import './years.dart';

class SignupMentorCompanyView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupMentorCompanyView();
}

class _SignupMentorCompanyView extends State<SignupMentorCompanyView> {
  final RealApiService _apiService = RealApiService();
  String _company = '';
  final TextEditingController _textController = TextEditingController();
  String _query = '';
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

  void _getSuggestions() {
    if (_query != '') {
      _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) async {
        final _res = await _apiService.autocompleteCorp(_query, '10');
        _timer?.cancel();
        setState(() {
          _suggestionList.value = _res;
          _found = true;
        });
      });
    }
  }

  void _pressBack() {
    Navigator.pop(context);
  }

  void _pressNext(bool isValue) {
    if (isValue) {
      Provider.of<Signup>(context, listen: false).company = _company;
    }
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SignupMentorYearsView()));
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
              onTapDown: _company == ''
                  ? (details) {
                      setState(() {
                        _isSearchbarTapped = true;
                      });
                    }
                  : null,
              onTapUp: _company == ''
                  ? (details) {
                      Future.delayed(const Duration(milliseconds: 100), () {
                        setState(() {
                          _isSearchbarTapped = false;
                        });
                        _openSearchJob();
                      });
                    }
                  : null,
              onTapCancel: () {
                Future.delayed(const Duration(milliseconds: 100), () {
                  setState(() {
                    _isSearchbarTapped = false;
                  });
                });
              },
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: _company == ''
                              ? BobColors.mainColor
                              : Colors.grey,
                          width: 2),
                      borderRadius: BorderRadius.circular(30)),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: Row(children: [
                    const Padding(padding: EdgeInsets.all(7)),
                    Icon(Icons.search,
                        size: MediaQuery.of(context).size.height * 0.035,
                        color:
                            _company == '' ? BobColors.mainColor : Colors.grey),
                    const Padding(padding: EdgeInsets.all(3)),
                    Text('회사명을 입력해주세요.',
                        style: TextStyle(
                            color: _isSearchbarTapped
                                ? Colors.grey[300]
                                : Colors.grey[600],
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            fontWeight: FontWeight.bold))
                  ]))),
          Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.03)),
          Container(
              alignment: Alignment.centerLeft,
              child: _company != '' ? renderChip() : null)
        ]),
        topTitle: const ['재직 중인 회사를 등록해주세요', ''],
        btn1Title: '다 음',
        btn1Color: BobColors.mainColor,
        pressBack: _pressBack,
        pressBtn1: _company == '' ? null : () => _pressNext(true),
        btn2Title: '나중에 하기',
        btn2Color: Colors.black,
        pressBtn2: () => _pressNext(false));
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
                hintText: '회사명 입력'),
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
                            _company = _textController.text;
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
                                  _company = _suggestionList.value[idx];
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

  Widget renderChip() {
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
              Text(_company,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false),
              Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01)),
              GestureDetector(
                  onTap: () => setState(() {
                        _company = '';
                      }),
                  child: Icon(Icons.clear_outlined,
                      size: MediaQuery.of(context).size.width * 0.04))
            ]));
  }
}
