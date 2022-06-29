import 'package:bobjari_proj/widgets/signup_form.dart';
import 'package:bobjari_proj/widgets/topbar_back_contents.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bobjari_proj/const/colors.dart';
import 'package:bobjari_proj/providers/signup_provider.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/session_provider.dart';
import 'package:bobjari_proj/routes/routes.dart';
import 'package:bobjari_proj/screens/signup/mentor/topic.dart';
import 'package:bobjari_proj/const/etc.dart';
import './schedule.dart';

class SignupMentorTopicView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupMentorTopicView();
}

class _SignupMentorTopicView extends State<SignupMentorTopicView> {
  List<int> _topic = [];
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _pressBack() {
    Navigator.pop(context);
  }

  void _pressNext(bool isValue) {
    if (isValue) {
      Provider.of<Signup>(context, listen: false).topic = _topic;
    }
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SignupMentorScheduleView()));
  }

  void _onSelect(int selIdx) {
    if (_topic.contains(selIdx)) {
      setState(() {
        _topic.remove(selIdx);
      });
    } else {
      setState(() {
        _topic.add(selIdx);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignupForm(
        isbasePadding: true,
        child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.18),
                child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    spacing: MediaQuery.of(context).size.width * 0.02,
                    runSpacing: MediaQuery.of(context).size.height * 0.02,
                    children: List<Widget>.generate(Etc.topics.length,
                        (idx) => _topicCard(Etc.topics[idx], idx))))),
        topTitle: const ['밥자리를 통해 나눌 수 있는', '이야기를 선택해주세요.'],
        btn1Title: '다 음',
        btn1Color: BobColors.mainColor,
        pressBack: _pressBack,
        pressBtn1: _topic.isEmpty ? null : () => _pressNext(true),
        btn2Title: '나중에 하기',
        btn2Color: Colors.black,
        pressBtn2: () => _pressNext(false));
  }

  Widget _topicCard(String topic, int index) {
    return GestureDetector(
        onTap: () => _onSelect(index),
        child: Container(
            width: MediaQuery.of(context).size.width * 0.43,
            height: MediaQuery.of(context).size.height * 0.15,
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.02,
              right: MediaQuery.of(context).size.width * 0.02,
              top: MediaQuery.of(context).size.height * 0.015,
              bottom: MediaQuery.of(context).size.height * 0.015,
            ),
            decoration: BoxDecoration(
                color: _topic.contains(index) ? Colors.grey[200] : Colors.white,
                border: Border.all(
                  color: _topic.contains(index)
                      ? BobColors.mainColor
                      : Colors.grey,
                  width: MediaQuery.of(context).size.width * 0.006,
                ),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.question_mark,
                      size: MediaQuery.of(context).size.width * 0.15),
                  Spacer(),
                  Text(Etc.topics[index],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      softWrap: false),
                ])));
  }
}
