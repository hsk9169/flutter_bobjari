import 'package:flutter/material.dart';
import 'package:bobjari_proj/widgets/big_button.dart';
import 'package:bobjari_proj/widgets/base_padding.dart';
import 'package:bobjari_proj/screens/screens.dart';
import 'package:bobjari_proj/const/colors.dart';
import 'package:bobjari_proj/routes/routes.dart';
import 'package:bobjari_proj/services/kakao_service.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:bobjari_proj/services/real_api_service.dart';
import 'package:bobjari_proj/services/fake_api_service.dart';
import 'package:bobjari_proj/providers/signup_provider.dart';
import 'package:bobjari_proj/providers/session_provider.dart';
import 'package:provider/provider.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WelcomeView();
}

class _WelcomeView extends State<WelcomeView> {
  final PageController _pController = PageController(initialPage: 0);
  final KakaoService _kakaoService = KakaoService();
  final RealApiService _realApiService = RealApiService();
  final FakeApiService _fakeApiService = FakeApiService();

  int _curPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => _pageSlider());
  }

  void _pageSlider() {
    Future.delayed(const Duration(seconds: 2)).then((_) {
      if (_curPage < _pageList.length - 1) {
        _curPage++;
      } else {
        _curPage = 0;
      }

      _pController
          .animateToPage(_curPage,
              duration: const Duration(milliseconds: 300),
              curve: Curves.elasticOut)
          .then((_) => _pageSlider());
    });
  }

  @override
  void dispose() {
    _pController.dispose();
    super.dispose();
  }

  void _kakaoSignIn() async {
    var _jwt;
    var _user;
    if (await _kakaoService.checkToken() == true) {
      AccessTokenInfo _tokenInfo = await _kakaoService.getExistingToken();
      if (_tokenInfo.appId != 0) {
        print('토큰 유효성 체크 성공 ${_tokenInfo.id} ${_tokenInfo.expiresIn}');
      } else {
        try {
          OAuthToken _token = await _kakaoService.getTokenWithAccount();
          print('로그인 성공 ${_token.accessToken}');
        } catch (error) {
          print('로그인 실패 $error');
        }
      }
    } else {
      try {
        OAuthToken _token = await _kakaoService.getTokenWithKakaoTalk();
        print('카카오톡으로 로그인 성공 ${_token.accessToken}');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');
      }
    }
    try {
      User _userInfo = await _kakaoService.getUserInfo();
      print('사용자 정보 요청 성공'
          '\n회원번호: ${_userInfo.id}'
          '\n닉네임: ${_userInfo.kakaoAccount?.profile?.nickname}'
          '\n이메일: ${_userInfo.kakaoAccount?.email}');
      //------------------------- Real
      _user = await _realApiService
          .signInKakao(_userInfo.kakaoAccount?.email ?? '');
      if (_user.profile?.email == _userInfo.kakaoAccount?.email) {
        _jwt = await _realApiService.getJWT(_user.profile?.email);
        Provider.of<Session>(context, listen: false).user = _user;
        Provider.of<Session>(context, listen: false).token = _jwt;
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.SERVICE, (Route<dynamic> route) => false);
      } else if (_user.userId == null) {
        Provider.of<Signup>(context, listen: false).email =
            _userInfo.kakaoAccount?.email ?? '';
        Navigator.pushNamed(context, Routes.SIGNUP);
      } else {
        throw Exception('email not matched');
      }
      //------------------------- Fake test
      //_user = await _fakeApiService.signInKakao('mentee_login');
      //Provider.of<Signup>(context, listen: false).email = _user.profile.email;
      //Navigator.pushNamed(context, Routes.SIGNUP);
    } catch (err) {
      print('조회 가능한 카카오 계정이 없습니다. $err');
      _bobjariSignIn();
    }
  }

  void _bobjariSignIn() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const PhoneSubmitView()));
  }

  void _lookAround() {
    Navigator.pushNamedAndRemoveUntil(
        context, Routes.SERVICE, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: BasePadding(
                child: Column(
      children: [
        const Padding(padding: EdgeInsets.all(10)),
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: PageView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _pController,
                itemCount: _pageList.length,
                itemBuilder: (BuildContext context, int index) {
                  return _pageList[index];
                })),
        Column(children: [
          SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  onPressed: _kakaoSignIn,
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(248, 255, 230, 0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    side: const BorderSide(
                        color: Color.fromRGBO(254, 229, 0, 1), width: 2.0),
                  ),
                  child: const Text('카카오 로그인',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(0, 0, 0, 0.85))))),
          const Padding(padding: EdgeInsets.all(5)),
          SizedBox(
              width: double.infinity,
              height: 50,
              child: BigButton(
                  btnColor: BobColors.mainColor,
                  title: '밥자리 로그인',
                  txtColor: Colors.white,
                  press: _bobjariSignIn)),
          const Padding(padding: EdgeInsets.all(5)),
          SizedBox(
              width: double.infinity,
              height: 50,
              child: BigButton(
                btnColor: Colors.white,
                title: '한번 둘러보기',
                txtColor: Colors.black,
                borderColor: Colors.black,
                press: _lookAround,
              ))
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
        height: (MediaQuery.of(context).size.height * 0.3),
        decoration: BoxDecoration(
          image: img,
        ),
      ),
    ]);
  }
}

List<Widget> _pageList = [
  const SlidePage(
    title: [
      Text('속 시원한',
          style: TextStyle(
              fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black)),
      Text('현직자 인터뷰, 밥자리',
          style: TextStyle(
              fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black)),
    ],
    body: [
      Text('오래 꿈꿔온 직업부터', style: TextStyle(fontSize: 20, color: Colors.black)),
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
              fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black)),
      Text('안전하고 만족스롭게',
          style: TextStyle(
              fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black)),
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
              fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black)),
      Text('밥자리 만남 프로세스',
          style: TextStyle(
              fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black)),
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
