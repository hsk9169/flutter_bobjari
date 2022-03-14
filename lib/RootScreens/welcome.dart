import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  Widget kakaoSignInButton(
      Color btnColor, String title, Color txtColor, BuildContext buildCtx) {
    return ElevatedButton(
      onPressed: () {
        //Navigator.of(buildCtx).push(MaterialPageRoute(builder: (_) {
        //  return const SignInKakaoScreen();
        //}));
        Navigator.pushNamed(buildCtx, '/signin/kakao');
      },
      child: Text(title,
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: txtColor)),
      style: ElevatedButton.styleFrom(
        primary: btnColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        fixedSize: const Size.fromWidth(double.infinity),
        //fixedSize: const Size.fromHeight(double.infinity),
      ),
    );
  }

  Widget bobSignInButton(
      Color btnColor, String title, Color txtColor, BuildContext buildCtx) {
    return ElevatedButton(
      onPressed: () {
        //Navigator.of(buildCtx).push(MaterialPageRoute(builder: (_) {
        //  return const SignInBobScreen();
        //}));
        Navigator.pushNamed(buildCtx, '/signin/bob');
      },
      child: Text(title,
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: txtColor)),
      style: ElevatedButton.styleFrom(
          primary: btnColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
            flex: 6,
            child: Padding(
                padding: const EdgeInsets.only(top: 60, left: 25),
                child: Column(
                  children: [
                    Text('속 시원한',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    Text('현직자 인터뷰, 밥자리',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    Text('오래 꿈꿔온 직업부터',
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                    Text('한 번 알아보고 싶은 직업까지',
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                  ],
                ))),
        Expanded(
            flex: 3,
            child: Column(children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 20, right: 20),
                width: (MediaQuery.of(context).size.width),
                height: 80,
                child: kakaoSignInButton(const Color.fromARGB(248, 255, 230, 0),
                    '카카오 로그인', Colors.black, context),
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 20, right: 20),
                width: (MediaQuery.of(context).size.width),
                height: 80,
                child: bobSignInButton(
                    const Color(0xFFF75910), '밥자리 로그인', Colors.white, context),
              ),
            ]))
      ])
    ]));
  }
}
