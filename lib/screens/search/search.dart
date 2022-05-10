import 'package:bobjari_proj/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:bobjari_proj/const/spaces.dart';
import 'package:bobjari_proj/widgets/base_scroller_with_back.dart';
import 'package:bobjari_proj/widgets/topbar_search.dart';
import 'package:bobjari_proj/services/real_api_service.dart';
import 'package:bobjari_proj/services/fake_api_service.dart';
import 'package:bobjari_proj/models/mentor/mentor.dart';
import 'package:bobjari_proj/widgets/card/mentor_search.dart';
import 'package:bobjari_proj/screens/search/filter_menu.dart';
import 'package:bobjari_proj/const/spaces.dart';
import 'package:bobjari_proj/widgets/base_padding.dart';

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
  late FocusNode _textFocusNode;
  final List<String> _searchHistory = [];
  List<MentorModel> _searchResult = [];
  final String _searchIdx = '0';
  final String _searchNum = '30';

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onChanged);
    _textFocusNode = FocusNode();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
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
        body: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: SafeArea(
                top: true,
                bottom: false,
                child:
                    CustomScrollView(controller: _scrollController, slivers: [
                  SliverAppBar(
                      automaticallyImplyLeading: false,
                      pinned: false,
                      snap: false,
                      floating: true,
                      backgroundColor: Colors.white,
                      flexibleSpace: Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: TopBarSearch(
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
                      ),
                      bottom: PreferredSize(
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: BobSpaces.firstEgg,
                                right: BobSpaces.firstEgg),
                            child: FilterMenu()),
                        preferredSize: Size.fromHeight(
                            MediaQuery.of(context).size.height * 0.12),
                      )),
                  /*
                  SliverToBoxAdapter(
                      child: Padding(
                    padding: EdgeInsets.only(
                        left: BobSpaces.firstEgg, right: BobSpaces.firstEgg),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _renderKeywordHistory()),
                  )
                      //])
                      ),
                      */
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                    return Stack(children: [
                      Container(
                          padding: _searchResult.isNotEmpty
                              ? EdgeInsets.all(
                                  MediaQuery.of(context).size.height * 0.03)
                              : null,
                          decoration: BoxDecoration(color: Colors.grey[200]),
                          child: Column(children: _renderSearchResult()))
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
                              print(_searchHistory);
                            });
                          },
                          color: Colors.grey,
                          iconSize: MediaQuery.of(context).size.height * 0.02)
                    ])))));
  }
}
