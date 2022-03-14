import 'package:flutter/material.dart';
import './RootScreens/welcome.dart';
import './SignIn/sign_in_kakao.dart';
import './SignIn/sign_in_bob.dart';

const MaterialColor myColor = MaterialColor(0xFFF75910, <int, Color>{
  50: Color(0xFFF75910),
  100: Color(0xFFF75910),
  200: Color(0xFFF75910),
  300: Color(0xFFF75910),
  400: Color(0xFFF75910),
  500: Color(0xFFF75910),
  600: Color(0xFFF75910),
  700: Color(0xFFF75910),
  800: Color(0xFFF75910),
  900: Color(0xFFF75910),
});

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //primarySwatch: const Colors.blue,
        primarySwatch: myColor,
      ),
      //home: const WelcomeScreen(),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/signin/bob': (context) => const SignInBobScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/signin/kakao': (context) => const SignInKakaoScreen(),
      }));
}
