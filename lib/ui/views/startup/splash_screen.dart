// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      //
      //TODO : Load Api Global Config + Api Gambar
      // MiscApi().patchGlobal("").then((value) {
      //   setState(() {
      //     delay = value['splash_delay'];
      //     isAgen = value['is_agen'];
      //     //Api Splash screen Gambar
          
      //   });
      // });
      // miliseconds dari api,url params dari api 
      // TODO : Navigate to target Global Config
      Future.delayed(Duration(milliseconds:  delay ?? 1000)).then((value) {
          Navigator.pushNamedAndRemoveUntil(context,"/", (route) => false);
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