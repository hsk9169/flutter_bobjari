import 'dart:math';

import 'package:bobjari_proj/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:bobjari_proj/services/fake_api_service.dart';
import 'package:bobjari_proj/services/real_api_service.dart';
import 'package:bobjari_proj/models/bobjari_model.dart';
import 'package:bobjari_proj/widgets/topbar_back_contents.dart';
import 'package:bobjari_proj/models/chat_model.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/session_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';
import 'dart:math';
import 'package:bobjari_proj/screens/service.dart';

class StreamSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

class ChatRoom extends StatefulWidget {
  final BobjariModel? bobjariInfo;
  const ChatRoom({Key? key, this.bobjariInfo});

  @override
  State<StatefulWidget> createState() => _ChatRoom();
}

class _ChatRoom extends State<ChatRoom> {
  final RealApiService _apiService = RealApiService();
  late IO.Socket _socket;
  final TextEditingController _textController = TextEditingController();
  late List<ChatModel> _chatList;
  late String _myId;
  late String _myRole;
  late String _myNickname;
  late String _yourId;
  late String _yourDeviceToken;
  late String _yourNickname;
  late String _yourImage;
  int _startIdx = 0;
  int _num = 100;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  var _curDateTime = DateTime.now();
  AssetImage dog = const AssetImage('assets/images/dog.png');
  late ScrollController _scrollController;
  late var _future;
  late StreamSocket _streamSocket;

  @override
  void initState() {
    _future = _getChatList();
    _streamSocket = StreamSocket();
    _socketConnectAndListen();
    _textController.addListener(_onChanged);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _streamSocket.dispose();
    _socket.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _socketConnectAndListen() {
    _socket = IO.io(
        'http://localhost:5000',
        //'http://172.20.10.12:5000',
        //'http://ec2-18-191-220-124.us-east-2.compute.amazonaws.com:5000',
        IO.OptionBuilder()
            .enableForceNew()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setQuery({'roomId': widget.bobjariInfo!.bobjariId})
            .setExtraHeaders({'roomId': widget.bobjariInfo!.bobjariId})
            .build());
    _socket.connect();
    _socket.on('connect', (data) {
      _streamSocket.addResponse;
    });
    _socket.on('newChatMessage', (data) {
      _streamSocket.addResponse;
      setState(() {
        _chatList.add(ChatModel(
            authorId: data[0]['senderId'],
            message: data[0]['body'],
            date: data[1]));
      });
      _textController.text = '';
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(
            milliseconds: 200,
          ),
          curve: Curves.easeInOut);
    });
  }

  Future<List<ChatModel>>? _getChatList() async {
    List<ChatModel> _chat = await _apiService.chatList(
        widget.bobjariInfo!.bobjariId!, _startIdx.toString(), _num.toString());
    setState(() {
      _chatList = _chat.reversed.toList();
      _myRole = Provider.of<Session>(context, listen: false).user.role!;
      _myId = _myRole == 'mentee'
          ? Provider.of<Session>(context, listen: false).user.mentee!.id!
          : Provider.of<Session>(context, listen: false).user.mentor!.id!;
      _myNickname =
          Provider.of<Session>(context, listen: false).user.profile!.nickname!;
      _yourId = _myRole == 'mentee'
          ? widget.bobjariInfo!.mentor!.id!
          : widget.bobjariInfo!.mentee!.id!;
      _yourDeviceToken = _myRole == 'mentee'
          ? widget.bobjariInfo!.mentor!.userDetail!.deviceToken ?? ''
          : widget.bobjariInfo!.mentee!.userDetail!.deviceToken ?? '';
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
      _socket.emit('newChatMessage', <String, dynamic>{
        'deviceToken': _yourDeviceToken,
        'nickname': _myNickname,
        'senderId': _myId,
        'body': _textController.text,
      });
      _textController.text = '';
      _scrollBottom();
    }
  }

  void _scrollBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 200,
        ),
        curve: Curves.easeInOut);
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var __myRole = Provider.of<Session>(context, listen: false).user.role!;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: TopBarBackContents(
              pressBack: _goBack,
              title: __myRole == 'mentee'
                  ? widget.bobjariInfo!.mentor!.userDetail!.profile!.nickname!
                  : widget.bobjariInfo!.mentee!.userDetail!.profile!.nickname!,
              icon1: const Icon(Icons.more_horiz),
              pressIcon1: _sendMessage,
              bottomLine: true,
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
              child: FutureBuilder<List<ChatModel?>>(
                  future: _future,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ChatModel?>> snapshot) {
                    if (snapshot.hasData) {
                      return Column(children: _renderMessages());
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            )),
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
    var _curDate = DateTime.now();
    return List.generate(_chatList.length, (idx) {
      bool _dateChanged = false;
      var _then = DateTime.parse(_chatList[idx].date!);
      if (_curDate.year == _then.year &&
          _curDate.month == _then.month &&
          _curDate.day == _then.day) {
        _dateChanged = true;
      } else {
        _curDate = _then;
      }
      return Column(children: [
        _dateChanged == false
            ? Column(children: [
                _dateRender(DateTime.parse(_chatList[idx].date!)),
                Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height * 0.005))
              ])
            : SizedBox(),
        _chatList[idx].authorId! == _myId
            ? _myMessage(_chatList[idx])
            : _yourMessage(_yourImage, _yourNickname, _chatList[idx]),
        Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01)),
      ]);
    });
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
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width * 0.01,
            bottom: MediaQuery.of(context).size.width * 0.01,
            left: MediaQuery.of(context).size.width * 0.02,
            right: MediaQuery.of(context).size.width * 0.02,
          ),
          decoration: BoxDecoration(
              color: Colors.grey[400], borderRadius: BorderRadius.circular(15)),
          child: Text(_ret,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                  color: Colors.white))),
    );
  }

  int _dateChecker(DateTime _then, DateTime _cur) {
    int _ret = 0;
    if (_cur.year == _then.year &&
        _cur.month == _then.month &&
        _cur.day == _then.day) {
      _ret = 1;
    }
    // should make timing to fit this in
    //else {
    //  setState(() {
    //    _curDateTime = _then;
    //  });
    //}
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
