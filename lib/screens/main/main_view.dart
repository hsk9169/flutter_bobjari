import 'package:flutter/material.dart';

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      Expanded(
          flex: 0,
          child: Container(
              alignment: Alignment.centerLeft,
              child: Container(
                width: (MediaQuery.of(context).size.width) * 0.5,
                height: (MediaQuery.of(context).size.height * 0.2),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/slogan.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ))),
    ])));
  }
}
