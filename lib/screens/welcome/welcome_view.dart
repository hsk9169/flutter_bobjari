import 'package:flutter/material.dart';
import '../../widgets/big_button.dart';
import 'package:bobjari_proj/widgets/base_padding.dart';
import 'package:bobjari_proj/screens/screens.dart';
import '../../const/colors.dart';
import 'package:bobjari_proj/routes/routes.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WelcomeView();
}

class _WelcomeView extends State<WelcomeView> {
  final PageController _controller = PageController(initialPage: 0);
  int curPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => _pageSlider());
  }

  void _pageSlider() {
    Future.delayed(const Duration(seconds: 2)).then((_) {
      if (curPage < _pageList.length - 1) {
        curPage++;
      } else {
        curPage = 0;
      }

      _controller
          .animateToPage(curPage,
              duration: const Duration(milliseconds: 300),
              curve: Curves.elasticOut)
          .then((_) => _pageSlider());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<Widget> _pageList = [
    const SlidePage(
      title: [
        Text('속 시원한',
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        Text('현직자 인터뷰, 밥자리',
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ],
      body: [
        Text('오래 꿈꿔온 직업부터',
            style: TextStyle(fontSize: 20, color: Colors.black)),
        Text('한 번 알아보고 싶은 직업까지',
            style: TextStyle(fontSize: 20, color: Colors.black)),
      ],
      img: DecorationImage(
        image: AssetImage('assets/images/welcomeInterview.jpeg'),
        fit: BoxFit.fitWidth,
      ),
    ),
    const SlidePage(
      title: [
        Text('검증된 직업인과',
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        Text('안전하고 만족스롭게',
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ],
      body: [
        Text('직업인 인증절차에서 시작되는',
            style: TextStyle(fontSize: 20, color: Colors.black)),
        Text('성공적인 밥자리', style: TextStyle(fontSize: 20, color: Colors.black)),
      ],
      img: DecorationImage(
        image: AssetImage('assets/images/welcomeVerify.jpeg'),
        fit: BoxFit.fitWidth,
      ),
    ),
    const SlidePage(
      title: [
        Text('쉽고 간단한',
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        Text('밥자리 만남 프로세스',
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ],
      body: [
        Text('심플한 과정으로', style: TextStyle(fontSize: 20, color: Colors.black)),
        Text('날짜 시간 장소까지 빠르게 확정',
            style: TextStyle(fontSize: 20, color: Colors.black)),
      ],
      img: DecorationImage(
        image: AssetImage('assets/images/welcomeReserve.webp'),
        fit: BoxFit.fitWidth,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: BasePadding(
                child: Column(
      children: [
        const Padding(padding: EdgeInsets.all(10)),
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.63,
            child: PageView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _controller,
                itemCount: _pageList.length,
                itemBuilder: (BuildContext context, int index) {
                  return _pageList[index];
                })),
        Column(children: [
          SizedBox(
              width: double.infinity,
              height: 50,
              child: BigButton(
                  btnColor: const Color.fromARGB(248, 255, 230, 0),
                  title: '카카오 로그인',
                  txtColor: Colors.black,
                  press: () {
                    //MaterialPageRoute(builder: (context) => const SignInKakaoView())
                    print('kakao signin');
                  })),
          const Padding(padding: EdgeInsets.all(5)),
          SizedBox(
              width: double.infinity,
              height: 50,
              child: BigButton(
                  btnColor: BobColors.mainColor,
                  title: '밥자리 로그인',
                  txtColor: Colors.white,
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EmailSubmitView()));
                    print('bob signin');
                  })),
          const Padding(padding: EdgeInsets.all(5)),
          SizedBox(
              width: double.infinity,
              height: 50,
              child: BigButton(
                  btnColor: Colors.white,
                  title: '비회원으로 둘러보기',
                  txtColor: Colors.black,
                  borderColor: Colors.black,
                  press: () {
                    Navigator.pushNamed(context, Routes.SERVICE);
                  })),
        ])
      ],
    ))));
  }
}

class SlidePage extends StatelessWidget {
  final List<Widget> title;
  final List<Text> body;
  final DecorationImage img;
  const SlidePage(
      {Key? key, required this.title, required this.body, required this.img})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          width: (MediaQuery.of(context).size.width),
          padding: const EdgeInsets.only(top: 20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: title)),
      Container(
        width: (MediaQuery.of(context).size.width),
        padding: const EdgeInsets.only(top: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: body),
      ),
      Container(
        width: (MediaQuery.of(context).size.width),
        height: (MediaQuery.of(context).size.height * 0.4),
        decoration: BoxDecoration(
          image: img,
        ),
      ),
    ]);
  }
}
