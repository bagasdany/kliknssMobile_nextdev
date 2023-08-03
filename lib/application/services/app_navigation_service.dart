import 'package:flutter/material.dart';

abstract class AppNavigatorService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<dynamic>? pushNamed(String routeName) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // debugPrint('route by navigatorKey: $routeName');
      AppNavigatorService.navigatorKey.currentState?.pushNamed(routeName);
    });
  }

  static Future<dynamic>? pushNamedAndRemoveUntil(String routeName) {
    // debugPrint('route by navigatorKey: $routeName');
    return AppNavigatorService.navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
  }

  static Future<dynamic>? pushReplacementNamed(String routeName) {
    // debugPrint('route by navigatorKey: $routeName');
    return AppNavigatorService.navigatorKey.currentState
        ?.pushReplacementNamed(routeName);
  }

  static void pop() {
    // debugPrint('route by navigatorKey pop');
    return AppNavigatorService.navigatorKey.currentState?.pop();
  }
}

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<ScaffoldState> bottomScaffoldKey = GlobalKey<ScaffoldState>();
