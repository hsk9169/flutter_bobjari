import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bobjari_proj/const/spaces.dart';
import 'package:bobjari_proj/widgets/topbar_search.dart';
import 'package:bobjari_proj/services/real_api_service.dart';
import 'package:bobjari_proj/services/fake_api_service.dart';
import 'package:bobjari_proj/models/mentor/mentor.dart';
import 'package:bobjari_proj/widgets/card/mentor_search.dart';
import 'package:bobjari_proj/screens/search/filter_menu.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchView();
}

class _SearchView extends State<SearchView> {
  final RealApiService _apiService = RealApiService();
  //final FakeApiService _apiService = FakeApiService();
  final TextEditingController _textController = TextEditingController();
  late ScrollController _scrollController;
  late ScrollPhysics _scrollPhysics;
  late FocusNode _textFocusNode;
  final List<String> _searchHistory = [];
  List<MentorModel> _searchResult = [];
  String _searchIdx = '0';
  final String _searchNum = '5';
  bool _isRefreshing = false;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onChanged);
    _textFocusNode = FocusNode();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _scrollPhysics = ScrollPhysics();
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onChanged() {}

  void _scrollListener() {
    /*
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
    */
    if (_scrollController.offset <=
            (_scrollController.position.minScrollExtent -
                MediaQuery.of(context).size.height * 0.05) &&
        _scrollController.position.outOfRange) {
      _scrollPhysics = NeverScrollableScrollPhysics();
      _refreshData();
    }
    if (_scrollController.offset >=
            (_scrollController.position.maxScrollExtent +
                MediaQuery.of(context).size.height * 0.05) &&
        _scrollController.position.outOfRange) {
      _scrollPhysics = NeverScrollableScrollPhysics();
      _fetchMoreData();
    }
  }

  void _refreshData() async {
    setState(() {
      _isRefreshing = true;
      _searchIdx = '0';
    });
    List<MentorModel> _result = await _apiService.searchMentor(
        _textController.text, _searchIdx, _searchNum);
    setState(() {
      _isRefreshing = false;
      _searchResult = _result;
    });
    _scrollPhysics = ScrollPhysics();
  }

  void _fetchMoreData() async {
    setState(() {
      _isFetchingMore = true;
      _searchIdx = (int.parse(_searchIdx) + int.parse(_searchNum)).toString();
    });
    List<MentorModel> _result = await _apiService.searchMentor(
        _textController.text, _searchIdx, _searchNum);
    setState(() {
      _isFetchingMore = false;
      _result.forEach((element) {
        _searchResult.add(element);
      });
    });
    _scrollPhysics = ScrollPhysics();
  }

  void _onSearch(String _val) async {
    List<MentorModel> _result =
        await _apiService.searchMentor(_val, _searchIdx, _searchNum);
    setState(() {
      _searchHistory.add(_val);
      _searchResult = _result;
    });
  }

  void _removeSearchInput() {
    setState(() {
      _textController.text = '';
    });
    _textFocusNode.requestFocus();
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            top: true,
            bottom: false,
            child: Container(
                color: Colors.grey[200],
                child: CustomScrollView(
                    controller: _scrollController,
                    physics: _scrollPhysics,
                    slivers: [
                      SliverAppBar(
                          automaticallyImplyLeading: false,
                          pinned: false,
                          snap: false,
                          floating: true,
                          backgroundColor: Colors.white,
                          flexibleSpace: TopBarSearch(
                            press: _goBack,
                            search: TextField(
                                onSubmitted: (_value) {
                                  _onSearch(_value);
                                },
                                textAlignVertical: TextAlignVertical.center,
                                autofocus: true,
                                focusNode: _textFocusNode,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: const Icon(Icons.search),
                                    suffixIcon: IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: const Icon(Icons.cancel),
                                        color: Colors.grey,
                                        onPressed: _removeSearchInput),
                                    hintText: '직업명, 직군, 회사 등'),
                                controller: _textController,
                                keyboardType: TextInputType.text),
                          ),
                          bottom: PreferredSize(
                            child: Container(
                                padding: EdgeInsets.only(
                                    left: BobSpaces.firstEgg,
                                    right: BobSpaces.firstEgg),
                                child: FilterMenu(),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 8,
                                        offset: Offset(
                                            0,
                                            MediaQuery.of(context).size.height *
                                                0.02), // changes position of shadow
                                      ),
                                    ])),
                            preferredSize: Size.fromHeight(
                                MediaQuery.of(context).size.height * 0.12),
                          )),
                      SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                        return Column(children: [
                          _isRefreshing
                              ? Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width * 0.03),
                                  child: CupertinoActivityIndicator(
                                    animating: true,
                                    radius: MediaQuery.of(context).size.height *
                                        0.015,
                                  ))
                              : SizedBox(),
                          Padding(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.05),
                              child: Column(children: _renderSearchResult())),
                          _isFetchingMore
                              ? Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width * 0.03),
                                  child: CupertinoActivityIndicator(
                                    animating: true,
                                    radius: MediaQuery.of(context).size.height *
                                        0.015,
                                  ))
                              : SizedBox(),
                        ]);
                      }, childCount: 1))
                    ]))));
  }

  List<Widget> _renderKeywordHistory() {
    return List.generate(
        _searchHistory.length, (idx) => myChip(idx, _searchHistory[idx]));
  }

  List<Widget> _renderSearchResult() {
    return List.generate(
        _searchResult.length,
        (idx) => Column(children: [
              MentorSearchCard(mentor: _searchResult[idx]),
              Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height * 0.01))
            ]));
  }

  Widget myChip(int idx, String content) {
    return Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.04,
            decoration: BoxDecoration(
              color: Colors.amber[100],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(children: [
                      Text(content),
                      const Padding(padding: EdgeInsets.all(3)),
                      IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchHistory.removeAt(idx);
                            });
                          },
                          color: Colors.grey,
                          iconSize: MediaQuery.of(context).size.height * 0.02)
                    ])))));
  }
}
