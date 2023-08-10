import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';

class ScaleFadeTransition extends PageTransitionsBuilder {
  const ScaleFadeTransition();
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    final tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Constants.cubicAnimateFastToMedium));
    return ScaleTransition(
      scale: animation.drive(tween),
      child: FadeTransition(opacity: animation, child: child));
    }
}
