

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kliknss77/application/app/app_log.dart';
import 'package:kliknss77/application/exceptions/sign_in_required.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs_key.dart';
import 'package:events_emitter/events_emitter.dart';

class HomeApi {
  final Dio _dio = DioService.getInstance();
  Map data = {};
  final events = EventEmitter();
  

  final _sharedPrefs = SharedPrefs();
  Position? currentPosition;
  final location = SharedPrefs().get(SharedPreferencesKeys.userLocation);
  final username = SharedPrefs().get(SharedPreferencesKeys.customerName);


  
  
  Future<dynamic> patchPage(String url) async {
    print("url : $url");
    var params = {"url": ((url)?? "")};
    print("doing load api");
    final response = await _dio.patch(Endpoint.evolvePatchHome, data: params).timeout(Duration(seconds: 20));
    return response.data;
  }


}
