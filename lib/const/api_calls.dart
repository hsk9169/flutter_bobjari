class ApiCalls {
  static String signinKakao = '/api/signin/kakao';
  static String signinBob = '/api/signin/bob';

  static String userJoin = '/api/user';
  static String checkNickname = '/api/user/nickname';
  static String roleChange = '/api/user/change';

  //final String mentee        = '/api/mentee';

  static String mentor = '/api/mentor';
  static String searchMentor = '/api/mentor/search';
  static String recommendMentor = '/api/mentor/recommend';
  static String toggleSearchAllow = '/api/mentor/searchAllow';

  static String getToken = '/api/auth/token';
  static String emailAuth = '/api/auth/email';
  static String smsAuth = '/api/auth/phone';
  static String kakaoAuth = '/api/auth/kakao';
  static String verifyToken = '/api/auth/verify';

  static String bobjari = '/api/bobjari';
  static String getMenteeBobjari = '/api/bobjari/mentee';
  static String getMentorBobjari = '/api/bobjari/mentor';
  static String upgradeBobjariLevel = '/api/bobjari/level';

  static String like = '/api/like';

  static String recentReview = '/api/review/recent';

  static String getMessage = '/api/chat';
  static String newChatMessage = 'newChatMessage';
  static String socketServerUri = 'http://localhost:5000';

  static String jwtSecretKey = 'ThIsIsSeCrEtKeYfOrEnCrYpT';
}
