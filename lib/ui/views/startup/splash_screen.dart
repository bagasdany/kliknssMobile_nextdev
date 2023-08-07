// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kliknss77/application/builders/master_builder.dart';
import 'package:kliknss77/application/services/app_navigation_service.dart';
import 'package:kliknss77/infrastructure/apis/home_api/home_api.dart';
// import 'package:flutter/services.dart';
import '../../../infrastructure/database/shared_prefs.dart';

class SplashScreen extends StatefulWidget {
  dynamic item;

  SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _sharedPrefs = SharedPrefs();
  dynamic delay;
  dynamic isAgen;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds:  1000)).then((value) {
          AppNavigatorService.pushReplacementNamed('/');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/splash_juni_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/splash_juni_obj.png"),
                  fit: BoxFit.cover,
                ),
              ),
            )),
      ),
    );
  }
} 