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
  final List<String> _searchHistory = [];
  List<MentorModel> _searchResult = [];
  final String _searchIdx = '0';
  final String _searchNum = '30';

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onChanged() {}

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
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Colors.grey[200])),
      Column(children: [
        // Search, Sort, Filter
        Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: SafeArea(
                top: true,
                bottom: false,
                child: Column(children: [
                  TopBarSearch(
                    press: _goBack,
                    search: TextField(
                        onSubmitted: (_value) {
                          _onSearch(_value);
                        },
                        textAlignVertical: TextAlignVertical.center,
                        autofocus: true,
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
                  Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.01)),
                  BasePadding(
                      child: Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _renderKeywordHistory()),
                    Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.01)),
                    FilterMenu(),
                  ]))
                ]))),
        // Mentor Search Results
        Expanded(
            child: SingleChildScrollView(
                child: SizedBox(
                    child: Column(children: [
          Padding(
              padding: EdgeInsets.all(BobSpaces.firstEgg),
              child: Center(
                  child: Column(
                children: _renderSearchResult(),
              )))
        ]))))
      ])
    ]));
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
