class SmsAuthModel {
  late String authResult;
  late String authNum;

  SmsAuthModel({required this.authResult, required this.authNum});

  SmsAuthModel.fromJson(Map<String, dynamic> json) {
    authResult = json['authResult'];
    authNum = json['authNum'];
  }

  Map<String, dynamic> toJson() => {
        'authResult': authResult,
        'authNum': authNum,
      };
}
