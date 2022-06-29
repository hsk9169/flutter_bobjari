import 'package:bobjari_proj/screens/bob/chat_room.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/screens/screens.dart';
import 'package:bobjari_proj/const/colors.dart';
import 'package:bobjari_proj/providers/session_provider.dart';
import 'package:bobjari_proj/providers/signup_provider.dart';
import 'package:bobjari_proj/providers/propose_provider.dart';
import 'package:bobjari_proj/widgets/dismiss_keyboard.dart';
import 'routes/routes.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'main.dart';
import 'package:bobjari_proj/models/mentor/mentor.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
        child: MultiProvider(
            providers: [
          ChangeNotifierProvider<Session>.value(value: Session()),
          ChangeNotifierProvider<Signup>.value(value: Signup()),
          ChangeNotifierProvider<Propose>.value(value: Propose()),
        ],
            child: MaterialApp(
              navigatorObservers: [routeObserver],
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: BobColors.mainMaterialColor,
                scaffoldBackgroundColor: Colors.white,
                bottomSheetTheme: BottomSheetThemeData(
                    backgroundColor: Colors.black.withOpacity(0)),
              ),
              //navigatorObservers: [...FirebaseService.analytics.getObservers()],
              //darkTheme: Styles.dark,
              routes: {
                Routes.SPLASH: (context) => SplashView(),
                Routes.WELCOME: (context) => const WelcomeView(),
                Routes.SERVICE: (context) => const ServiceView(selected: 0),
                Routes.SIGNUP: (context) => SignupProfileNicknameView(),
                Routes.SIGNUP_MENTEE: (context) => SignupMenteeInterestsView(),
                Routes.SIGNUP_MENTOR: (context) => SignupMentorJobView(),
                Routes.SEARCH: (context) => const SearchView(),
                Routes.CHAT_ROOM: (context) => const ChatRoom(),
                Routes.MENTOR_DETAILS: (context) => MentorDetails(
                    ModalRoute.of(context)!.settings.arguments as String),
                Routes.BOB_PROPOSE_SCHEDULE: (context) => ScheduleCheckView(),
                Routes.BOB_PROPOSE_LOCATION: (context) => LocationCheckView(),
              },
              initialRoute: Routes.SPLASH,
            )));
  }

  @override
  void initState() {
    //scheduleMicrotask(() {
    //  precacheImage(SplashView.splashImage, context)
    //})
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      var androidNotiDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
      );
      var iOSNotiDetails = const IOSNotificationDetails();
      var details =
          NotificationDetails(android: androidNotiDetails, iOS: iOSNotiDetails);
      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          details,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
