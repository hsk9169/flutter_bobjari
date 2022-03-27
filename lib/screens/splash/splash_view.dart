import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:bobjari_proj/screens/screens.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _init();
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: AnimatedBuilder(
                    animation: _controller,
                    child: Container(
                      alignment: Alignment.center,
                      width: (MediaQuery.of(context).size.width) * 0.6,
                      height: (MediaQuery.of(context).size.height * 0.5),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/cat.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    builder: (BuildContext context, Widget? _widget) {
                      return Transform.rotate(
                          angle: _controller.value * 2 * math.pi,
                          child: _widget);
                    }))));
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeView()),
      (Route<dynamic> route) => false,
    );
  }
}
