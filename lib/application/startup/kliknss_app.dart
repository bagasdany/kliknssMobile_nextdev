import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kliknss77/application/animation/transition/custom_animation.dart';
import 'package:kliknss77/application/app/app_log.dart';
import 'package:kliknss77/application/app/scroll_behavior.dart';
import 'package:kliknss77/application/router/router.dart';
import 'package:kliknss77/application/services/app_navigation_service.dart';
import 'package:kliknss77/application/services/connectivity_services.dart';
import 'package:kliknss77/application/statusApp/connectivity_status.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../../infrastructure/database/shared_prefs.dart';

class NssApp extends StatefulWidget {
  const NssApp({Key? key}) : super(key: key);

  @override
  State<NssApp> createState() => _NssAppState();
}

class _NssAppState extends State<NssApp> with WidgetsBindingObserver {

  final _sharedPrefs = SharedPrefs();
  dynamic transition = "fade";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    transition = _sharedPrefs.get('transition') ?? "fade";
    
    
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {

  
  dynamic transitionBuilder({String transition = "fade"}) {
    switch (transition) {
      // Floating Header
      case "ScaleFadeTransition":
        return const ScaleFadeTransition();
      case "CupertinoPageTransitionsBuilder":
        return const CupertinoPageTransitionsBuilder();
      case "OpenUpwardsPageTransitionsBuilder":
        return const OpenUpwardsPageTransitionsBuilder();
      case "FadeUpwardsPageTransitionsBuilder":
        return const FadeUpwardsPageTransitionsBuilder();
     
      default:
      return const CupertinoPageTransitionsBuilder();
        // return const ScaleFadeTransition();
        //ZoomPageTransitionsBuilder()
    }
  }

    return Listener(
      child: StreamProvider<ConnectivityStatus>(
        initialData: ConnectivityStatus.cellular,
        create: (context) =>
            ConnectivityService().connectionStatusController.stream,
        child: OverlaySupport(
            child: MaterialApp(
          // theme: ThemeData.light(), // Tema terang
          title: "KlikNSS",
          navigatorKey: AppNavigatorService.navigatorKey,
          scaffoldMessengerKey: scaffoldKey,
          initialRoute: '/startup',
          // home: ,

          onGenerateRoute: AppRouter().onGenerateRoute,
          debugShowCheckedModeBanner: false,
          // themeAnimationCurve: Constants.cubicAnimateFastToMedium,
          // themeAnimationDuration: Duration(seconds: 5),
          scrollBehavior: AppScrollBehavior(),
          theme: ThemeData(
              splashFactory: NoSplash.splashFactory,
              pageTransitionsTheme:  PageTransitionsTheme(
                builders: <TargetPlatform, PageTransitionsBuilder>{
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
                  TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.android :transitionBuilder(transition: transition),
                },
              ),
              
              primarySwatch: Constants.primaryColor,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              canvasColor: Constants.base,
              fontFamily: Constants.primaryFont,
              appBarTheme: AppBarTheme(
                titleTextStyle: TextStyle(color: Constants.gray.shade800)
                    .merge(Constants.heading4),
              ),
              textTheme: const TextTheme(bodyMedium: Constants.textMd)),
        )),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        // cekNotif();
        // _authApi.refreshLoginInfo();
        break;

      case AppLifecycleState.inactive:
        // AppLog().flush();
        break;

      case AppLifecycleState.paused:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.detached:
        // validateNotif();
        // detached tidak selalu works,rawan

        break;
    }
  }
}
