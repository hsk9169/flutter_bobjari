import 'package:bobjari_proj/const/colors.dart';
import 'package:bobjari_proj/const/spaces.dart';
import 'package:flutter/material.dart';
import 'package:bobjari_proj/services/fake_api_service.dart';
import 'package:bobjari_proj/services/real_api_service.dart';
import 'package:bobjari_proj/models/bobjari_model.dart';
import 'package:bobjari_proj/widgets/base_scroller_with_back.dart';
import 'package:bobjari_proj/widgets/topbar_back_contents.dart';
import 'package:bobjari_proj/models/chat_model.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/session_provider.dart';

class ChatRoom extends StatefulWidget {
  final BobjariModel? bobjariInfo;
  const ChatRoom({Key? key, this.bobjariInfo});

  @override
  State<StatefulWidget> createState() => _ChatRoom();
}

class _ChatRoom extends State<ChatRoom> {
  final RealApiService _apiService = RealApiService();
  final TextEditingController _textController = TextEditingController();
  // message, createdAt, authorId
  late List<ChatModel> _chatList;
  late var _getChatsFuture;
  late String _myId;
  late String _myRole;
  late String _yourId;
  late String _yourNickname;
  late String _yourImage;
  int _startIdx = 0;
  int _num = 30;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  var _curDateTime = DateTime.now();
  AssetImage dog = const AssetImage('assets/images/dog.png');
  late ScrollController _scrollController;

  @override
  void initState() {
    _getChatsFuture = _getChatList();
    _textController.addListener(_onChanged);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<ChatModel>>? _getChatList() async {
    List<ChatModel> _chat = await _apiService.chatList(
        widget.bobjariInfo!.bobjariId!, _startIdx.toString(), _num.toString());
    setState(() {
      _chatList = _chat;

      _myRole = Provider.of<Session>(context, listen: false).user.role!;
      _myId = _myRole == 'mentee'
          ? Provider.of<Session>(context, listen: false).user.mentee!.id!
          : Provider.of<Session>(context, listen: false).user.mentor!.id!;
      _yourId = _myRole == 'mentee'
          ? widget.bobjariInfo!.mentor!.id!
          : widget.bobjariInfo!.mentee!.id!;
      _yourNickname = _myRole == 'mentee'
          ? widget.bobjariInfo!.mentor!.userDetail!.profile!.nickname!
          : widget.bobjariInfo!.mentee!.userDetail!.profile!.nickname!;
      _yourImage = _myRole == 'mentee'
          ? widget.bobjariInfo!.mentor!.userDetail!.profile!.profileImage!.data!
          : widget
              .bobjariInfo!.mentee!.userDetail!.profile!.profileImage!.data!;
    });
    return _chat;
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

  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _chatList.add(ChatModel(
            authorId: _myId,
            message: _textController.text,
            date: DateTime.now().toString()));
      });
      _textController.text = '';
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(
            milliseconds: 200,
          ),
          curve: Curves.easeInOut);
    }
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: TopBarBackContents(
              pressBack: _goBack,
              title: widget.bobjariInfo!.mentor!.userDetail!.profile!.nickname!,
              icon: const Icon(Icons.more_horiz),
              pressIcon: _sendMessage,
            )),
        body: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.01,
                  bottom: MediaQuery.of(context).size.height * 0.07,
                  left: MediaQuery.of(context).size.width * 0.03,
                  right: MediaQuery.of(context).size.width * 0.03,
                ),
                child: Column(children: [
                  FutureBuilder<List<ChatModel?>>(
                      future: _getChatsFuture,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<ChatModel?>> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Column(children: _renderMessages());
                        }
                      }),
                ]))),
        bottomSheet: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.grey[300]),
            child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.01),
                child: TextField(
                  maxLines: 1,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.send_rounded),
                        color: BobColors.mainColor,
                        onPressed: _sendMessage),
                  ),
                  controller: _textController,
                  keyboardType: TextInputType.text,
                ))),
        bottomNavigationBar: Container(
            height: MediaQuery.of(context).size.height * 0.05,
            decoration: BoxDecoration(color: Colors.grey[300])));
  }

  // Compare every elements & update 'current date'
  // And compare again till the last one comes up
  List<Widget> _renderMessages() {
    return List.generate(
        _chatList.length,
        (idx) => Column(children: [
              _dateChecker(
                          DateTime.parse(_chatList[idx].date!), _curDateTime) ==
                      0
                  ? Column(children: [
                      _dateRender(DateTime.parse(_chatList[idx].date!)),
                      Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.height * 0.005))
                    ])
                  : SizedBox(),

              //_chatList[idx].authorId == _myId
              //    ? _myMessage(_chatList[idx])
              //    : _yourMessage(_yourImage, _yourNickname, _chatList[idx])
              _myMessage(_chatList[idx]),
              Padding(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height * 0.01)),
              _yourMessage(_yourImage, _yourNickname, _chatList[idx]),
              Padding(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height * 0.01)),
            ]));
  }

  Widget _myMessage(ChatModel _chat) {
    return SizedBox(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(_timeString(DateTime.parse(_chat.date!)),
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: MediaQuery.of(context).size.width * 0.03)),
              Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01)),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6),
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                decoration: BoxDecoration(
                    color: BobColors.mainColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(_chat.message!,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.04)),
              )
            ]),
        width: MediaQuery.of(context).size.width);
  }

  Widget _yourMessage(String _image, String _nickname, ChatModel _chat) {
    return SizedBox(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                  width: (MediaQuery.of(context).size.width) * 0.07,
                  height: (MediaQuery.of(context).size.width) * 0.07,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: Uri.parse(_image).data == null
                          ? dog
                          : Image.memory(
                                  Uri.parse(_image).data!.contentAsBytes(),
                                  gaplessPlayback: true)
                              .image,
                      fit: BoxFit.cover,
                    ),
                  )),
              Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01)),
              Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6),
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(_chat.message!,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.04))),
              Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01)),
              Text(_timeString(DateTime.parse(_chat.date!)),
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: MediaQuery.of(context).size.width * 0.03))
            ]),
        width: MediaQuery.of(context).size.width);
  }

  Widget _dateRender(DateTime _date) {
    String _ret = '';
    _ret = _date.year.toString() +
        '년 ' +
        _date.month.toString() +
        '월 ' +
        _date.day.toString() +
        '일 ';
    return Center(
      child: Container(
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(10)),
          child: Text(_ret)),
    );
  }

  int _dateChecker(DateTime _then, DateTime _cur) {
    int _ret = 0;
    if (_cur.year == _then.year &&
        _cur.month == _then.month &&
        _cur.day == _then.day) {
      _ret = 1;
    } else {
      setState(() {
        _curDateTime = _then;
      });
    }
    return _ret;
  }

  String _timeString(DateTime _date) {
    String _ret = '';
    if (_date.hour < 13) {
      _ret += '오전 ';
      _ret += _date.hour.toString();
    } else {
      _ret += '오후 ';
      _ret += (_date.hour - 12).toString();
    }
    _ret += ':';
    _ret += _date.minute < 10 ? '0${_date.minute}' : _date.minute.toString();

    return _ret;
  }
}
