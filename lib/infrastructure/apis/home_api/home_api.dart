

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/services/app_navigation_service.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/infrastructure/database/data_page.dart';
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
    try{
      
      var params = {"url": ((url)?? "")};
      final response = await _dio.patch(Endpoint.evolvePatchHome,data: params);
      // await Navigator.of(AppNavigatorService.navigatorKey.currentContext!).pushNamed(response.data['url'] ?? "/",arguments: response.data); 
      print(response.data);
      return response.data;
    }on DioException catch(e){
      print(e);
    }on Exception catch(e){
      print(e);
    }on Error catch(e){
      print(e);
    }
    finally{
      print("finally");
    }
    
  }
}
