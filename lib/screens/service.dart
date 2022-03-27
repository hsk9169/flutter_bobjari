import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/providers/session_provider.dart';
import 'package:bobjari_proj/const/spaces.dart';
import 'package:bobjari_proj/screens/screens.dart';

class ServiceView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ServiceView();
}

class _ServiceView extends State<ServiceView> {
  @override
  Widget build(BuildContext context) {
    print(Provider.of<Session>(context).user.toJson());
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding:
          EdgeInsets.only(left: BobSpaces.firstEgg, right: BobSpaces.firstEgg),
      child: const MainView(),
    )));
  }
}
