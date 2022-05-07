import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: '26f7315e7729fc2588ef2c32be820a1e');
  _initNotiSetting();
  runApp(MyApp());
}

// Local Notification Init
void _initNotiSetting() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final initSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final initSettingsIOS = IOSInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );
  final initSettings = InitializationSettings(
    android: initSettingsAndroid,
    iOS: initSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
  );
}
