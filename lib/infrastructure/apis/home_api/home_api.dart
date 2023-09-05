

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
  try {
    var params = {"url": ((url)?? "")};
    final response = await _dio.patch(Endpoint.evolvePatchHome, data: params).timeout(Duration(seconds: 20));
    return response.data;
  } on SignInRequiredException catch (e) {
    print("error global 1 $e");    var params = {"url": ((url)?? "")};
    AppLog().reportError("patch Page Api : $url error", "error: $e ,params : $params, method: ${e.requestOptions.method},path: ${e.requestOptions.path}");

    return 4;
  } on SocketException catch (e) {
    print("error global 2 $e");
    var params = {"url": ((url)?? "")};
    AppLog().reportError("patch Page Api : $url error", "error: $e ,params : $params, method: patch,path: /pages");

    // Handle DioError
    return 4;
    // Handle DioException
  } on TimeoutException catch (e) {
        var params = {"url": ((url)?? "")};
    AppLog().reportError("patch Page Api : $url error", "error: $e ,params : $params, method: patch,path: /pages");

    print("error global 3 $e");
    
    // Handle DioError
    return 5;
    
  }
   on DioException catch (e) {
    var params = {"url": ((url)?? "")};
    AppLog().reportError("patch Page Api : $url error", "error: $e ,params : $params, method: ${e.requestOptions.method},path: ${e.requestOptions.path}");

    print("error global 3 $e");
    
    
    print(e);
    return e;
  } on Error catch (e) {
    var params = {"url": ((url)?? "")};
    AppLog().reportError("patch Page Api : $url error", "error: $e ,params : $params, method: patch,path: /pages");

    print("error global 5 $e");
    print(e);
  } finally {

    print("finally");
  }
  }


}
