import 'package:flutter/material.dart';
import 'package:bobjari_proj/models/like_model.dart';
import 'package:bobjari_proj/services/fake_api_service.dart';
import 'package:bobjari_proj/services/real_api_service.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/session_provider.dart';
import 'package:bobjari_proj/widgets/card/like_component.dart';
import 'package:bobjari_proj/routes/routes.dart';
import 'package:bobjari_proj/const/spaces.dart';
import 'package:bobjari_proj/app.dart';

class LikeBob extends StatefulWidget {
  const LikeBob({Key? key, required this.session}) : super(key: key);
  final session;

  @override
  State<StatefulWidget> createState() => _LikeBob();
}

class _LikeBob extends State<LikeBob> with RouteAware {
  late var _future;
  late ScrollController _scrollController;
  final RealApiService _apiService = RealApiService();
  //final FakeApiService _apiService = FakeApiService();
  late List<LikeModel> _likeList;

  @override
  void initState() {
    _future = _getLike();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    _future = _getLike();
    print('pop');
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

  Future<List<LikeModel>>? _getLike() async {
    var _menteeId =
        Provider.of<Session>(context, listen: false).user.mentee != null
            ? Provider.of<Session>(context, listen: false).user.mentee!.id!
            : 'none';
    var _res = await _apiService.likeList(_menteeId);
    setState(() {
      _likeList = _res.reversed.toList();
    });
    return _res;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SingleChildScrollView(
          child: FutureBuilder<List<LikeModel>>(
              future: _future,
              builder: (BuildContext context,
                  AsyncSnapshot<List<LikeModel>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (_likeList.isEmpty) {
                  return Container(
                      height: constraints.maxHeight,
                      alignment: Alignment.center,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('아직 찜한 멘토가 없어요',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.06,
                                    fontWeight: FontWeight.bold)),
                            Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.03)),
                            GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () =>
                                    Navigator.pushNamed(context, Routes.SEARCH),
                                child: Text('멘토 검색을 원하시면 클릭!',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold)))
                          ]));
                } else {
                  return Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.03,
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: Column(children: _likeRender(_likeList)));
                }
              }));
    });
  }

  List<Widget> _likeRender(List<LikeModel> _list) {
    return List.generate(
        _list.length,
        (idx) => Center(
              child: Column(children: [
                GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => Navigator.pushNamed(
                        context, Routes.MENTOR_DETAILS,
                        arguments: _list[idx].mentor!.id),
                    child: LikeComponentCard(mentor: _list[idx].mentor)),
                Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height * 0.015))
              ]),
            ));
  }
}
