import 'package:flutter/material.dart';
import 'package:bobjari_proj/models/bobjari_model.dart';
import 'package:bobjari_proj/services/fake_api_service.dart';
import 'package:bobjari_proj/services/real_api_service.dart';
import 'package:bobjari_proj/widgets/card/chat_component.dart';
import 'package:bobjari_proj/routes/routes.dart';
import 'package:bobjari_proj/screens/bob/chat_room.dart';

class MyBob extends StatefulWidget {
  const MyBob({Key? key, required this.session}) : super(key: key);
  final session;

  @override
  State<StatefulWidget> createState() => _MyBob();
}

class _MyBob extends State<MyBob> {
  //final FakeApiService _apiService = FakeApiService();
  final RealApiService _apiService = RealApiService();
  late List<BobjariModel> _bobjariList;
  late var _getBobjariFuture;

  @override
  void initState() {
    _getBobjariFuture = _getBobjariList();
    super.initState();
  }

  Future<List<BobjariModel>>? _getBobjariList() async {
    List<BobjariModel> _bobjari = await _apiService.bobjariList(
        widget.session.user.role == 'mentee'
            ? widget.session.user.mentee.id
            : widget.session.user.mentor.id,
        widget.session.user.role);
    setState(() {
      _bobjariList = _bobjari;
    });
    return _bobjari;
  }

  void _enterChatRoom(BobjariModel _model) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ChatRoom(bobjariInfo: _model)));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: FutureBuilder<List<BobjariModel?>>(
            future: _getBobjariFuture,
            builder: (BuildContext context,
                AsyncSnapshot<List<BobjariModel?>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Column(children: _bobjariRender(_bobjariList))
                  ],
                );
              }
            }));
  }

  List<Widget> _bobjariRender(List<BobjariModel> _list) {
    var _role = widget.session.user.role;
    return List.generate(
        _list.length,
        (idx) => Center(
                child: Column(children: [
              _role == 'mentee'
                  ? GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => _enterChatRoom(_list[idx]),
                      child: ChatComponentCard(
                          bobjariId: _list[idx].bobjariId,
                          profileImage: _list[idx]
                              .mentor
                              ?.userDetail
                              ?.profile
                              ?.profileImage
                              ?.data,
                          nickname:
                              _list[idx].mentor?.userDetail?.profile?.nickname,
                          job: _list[idx].mentor?.career?.job,
                          message: _list[idx].chat?.message,
                          status: _list[idx].status,
                          updatedAt: _list[idx].updatedAt))
                  : GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => print(idx),
                      child: ChatComponentCard(
                          profileImage: _list[idx]
                              .mentee
                              ?.userDetail
                              ?.profile
                              ?.profileImage
                              ?.data,
                          nickname:
                              _list[idx].mentee?.userDetail?.profile?.nickname,
                          message: _list[idx].chat?.message,
                          status: _list[idx].status,
                          updatedAt: _list[idx].updatedAt)),
              const Divider(color: Colors.grey)
            ])));
  }
}
