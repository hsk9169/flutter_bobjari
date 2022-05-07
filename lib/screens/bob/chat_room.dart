import 'package:flutter/material.dart';
import 'package:bobjari_proj/services/fake_api_service.dart';
import 'package:bobjari_proj/services/real_api_service.dart';
import 'package:bobjari_proj/models/bobjari_model.dart';
import 'package:bobjari_proj/widgets/base_scroller_with_back.dart';
import 'package:bobjari_proj/widgets/topbar_back.dart';
import 'package:bobjari_proj/widgets/base_padding.dart';
import 'package:bobjari_proj/models/chat_model.dart';

class ChatRoom extends StatefulWidget {
  final BobjariModel? bobjariInfo;
  const ChatRoom({Key? key, this.bobjariInfo});

  @override
  State<StatefulWidget> createState() => _ChatRoom();
}

class _ChatRoom extends State<ChatRoom> {
  final RealApiService _apiService = RealApiService();
  late List<ChatModel> _chatList;
  late var _getChatsFuture;
  int _startIdx = 0;
  int _num = 30;

  @override
  void initState() {
    _getChatsFuture = _getChatList();
    super.initState();
  }

  Future<List<ChatModel>>? _getChatList() async {
    List<ChatModel> _chat = await _apiService.chatList(
        widget.bobjariInfo!.bobjariId!, _startIdx.toString(), _num.toString());
    setState(() {
      _chatList = _chat;
    });
    return _chat;
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScrollerWithBack(
        appBar: TopBarBack(press: _goBack),
        child: FutureBuilder<List<ChatModel?>>(
            future: _getChatsFuture,
            builder: (BuildContext context,
                AsyncSnapshot<List<ChatModel?>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(children: [Center(child: Text('messages'))]);
              }
            }),
        bottomSheet: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.1,
          decoration: BoxDecoration(color: Colors.grey),
          child: Center(child: Text('text input bar')),
        ));
  }
}
