import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bobjari_proj/screens/screens.dart';
import './const/colors.dart';
import 'package:bobjari_proj/providers/session_provider.dart';
import 'routes/routes.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Session>.value(value: Session()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: BobColors.mainMaterialColor,
            scaffoldBackgroundColor: Colors.white,
          ),
          //navigatorObservers: [...FirebaseService.analytics.getObservers()],
          //darkTheme: Styles.dark,
          routes: {
            Routes.SPLASH: (context) => SplashView(),
            Routes.WELCOME: (context) => const WelcomeView(),
            Routes.SERVICE: (context) => ServiceView(),
          },
          initialRoute: Routes.SPLASH,
        ));
  }

  @override
  void initState() {
    //scheduleMicrotask(() {
    //  precacheImage(SplashView.splashImage, context)
    //})
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
