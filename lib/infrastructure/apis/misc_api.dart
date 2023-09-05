import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/services/debouncer.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs_key.dart';
import 'package:kliknss77/ui/component/app_dialog.dart';
import 'package:kliknss77/ui/component/get_error_message.dart';
import 'package:url_launcher/url_launcher.dart';

import '../database/shared_prefs.dart';

class MiscApi {
  final Dio _dio = DioService.getInstance();
  final _sharedPrefs = SharedPrefs();

  final _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  Future<String> getCitybyId(id) async {
    var params = {'id': id};
    var response =
        await _dio.get(Endpoint.requestKota, queryParameters: params);

    return response.data['alias'];
  }

  Future<dynamic> searchKelurahan({search, cityId}) async {
    var params = {'search': search, 'cityId': cityId};
    var response = await _dio.get("/kelurahan", queryParameters: params);

    List<Map> _kelurahans = (response.data['kelurahan'] as List)
        .map((item) => item as Map)
        .toList();
    return _kelurahans;
  }

  Future<dynamic> searchCity({search, cityId}) async {
    var params = {'search': search, 'fields': 'id,code,name,alias'};
    var response = await _dio.get("/city", queryParameters: params);

    List<Map> city =
        (response.data['cities'] as List).map((item) => item as Map).toList();
    return city;
  }

  Future<dynamic> searchCityAgent(dynamic cityId) async {
    try {
      var params = cityId == null ? {} : {"cityId": cityId};
      print("#params: $params");
      var response = await _dio.patch(Endpoint.patchAgentHmcEmptyCity, data: params);
      
      List<Map> city = cityId == null
          ? (response.data['cities'] as List)
              .map((item) => item as Map)
              .toList()
          : (response.data['serieses'] as List)
              .map((item) => item as Map)
              .toList();
      return city;
    } on DioException catch (e) {
      var message =
          GetErrorMessage.getErrorMessage(e.response?.data['errors'] ?? "");
      print("#message: $message");
      AppDialog.snackBar(text: message ?? "Terjadi kesalahan,silahkan ulangi lagi");
    }
  }

  Future<dynamic> patchMotorAgent(dynamic cityId) async {
    try {
      var params = {"cityId": cityId};
      print("#params: $params");
      var response =
          await _dio.patch(Endpoint.patchAgentHmcEmptyCity, data: params);

      List<Map> city = (response.data['serieses'] as List)
          .map((item) => item as Map)
          .toList();
      return city;
    } on DioException catch (e) {
      var message = GetErrorMessage.getErrorMessage(e.response?.data['errors'] ?? "");
      print("#message: $message");
      AppDialog.snackBar(text: message ?? "Terjadi kesalahan,silahkan ulangi lagi");
    }
  }

  Future<dynamic> patchGlobal(dynamic param) async {
    try {
      var params = {"global": param};
      print("#params: $params");
      var response = await _dio.patch(Endpoint.global, data: params);

      List<Map> city = (response.data['patch'] as List)
          .map((item) => item as Map)
          .toList();
      return city;
    } on DioException catch (e) {
      var message = GetErrorMessage.getErrorMessage(e.response?.data['errors'] ?? "");
      print("#message: $message");
      AppDialog.snackBar(text: message ?? "Terjadi kesalahan,silahkan ulangi lagi");
    }
  }


  Future<dynamic> patchMotorAgentwithSeries(dynamic cityId, seriesId) async {
    try {
      var params = {"cityId": cityId, "seriesId": seriesId};
      print("#params: $params");
      var response =
          await _dio.patch(Endpoint.patchAgentHmcEmptyCity, data: params);

      dynamic data = (response.data);
      return data;
    } on DioException catch (e) {
      var message =
          GetErrorMessage.getErrorMessage(e.response?.data['errors'] ?? "");
      print("#message: $message");
      AppDialog.snackBar(
          text: message ?? "Terjadi kesalahan,silahkan ulangi lagi");
    }
  }

  

  Future<dynamic> patchMotorAgentwithType(
      dynamic cityId, seriesId, typeId) async {
    try {
      var params = {"cityId": cityId, "seriesId": seriesId, "typeId": typeId};
      print("#params: $params");
      var response =
          await _dio.patch(Endpoint.patchAgentHmcEmptyCity, data: params);

      dynamic data = (response.data);
      return data;
    } on DioException catch (e) {
      var message =
          GetErrorMessage.getErrorMessage(e.response?.data['errors'] ?? "");
      print("#message: $message");
      AppDialog.snackBar(
          text: message ?? "Terjadi kesalahan,silahkan ulangi lagi");
    }
  }

  Future<dynamic> patchMotorAgentwithPriceList(dynamic cityId, typeId,colorId) async {
    try {
      var params = {"cityId": cityId, "typeId": typeId,"colorId": colorId};
      print("#params: $params");
      var response = await _dio.post(Endpoint.patchAgentHmcPricelist, data: params);

      dynamic data = (response.data['url']);
      return data;
    } on DioException catch (e) {
      var message = GetErrorMessage.getErrorMessage(e.response?.data['errors'] ?? "");
      print("#message: $message");
      AppDialog.snackBar(text: message ?? "Terjadi kesalahan,silahkan ulangi lagi");
    }
  }

  Future<dynamic> getPriceAgentCash(dynamic cityId, typeId,paymentType,idmotor) async {
    try {
      var params = {"cityId": cityId, "typeId": typeId,"paymentType": paymentType};
      print("#params: $params");
      var response = await _dio.post("motor/agen/$idmotor/price", queryParameters: params);

      dynamic data = (response.data['price']);
      return data;
    } on DioException catch (e) {
      var message =
          GetErrorMessage.getErrorMessage(e.response?.data['errors'] ?? "");
      print("#message: $message");
      AppDialog.snackBar(
          text: message ?? "Terjadi kesalahan,silahkan ulangi lagi");
    }
  }



  Future<dynamic> searchKelurahanGlobal({search, cityId}) async {
    var params = {'search': search};
    var response = await _dio.get("/kelurahan", queryParameters: params);

    List<Map> _kelurahans = (response.data['kelurahan'] as List)
        .map((item) => item as Map)
        .toList();
    return _kelurahans;
  }

  Future<dynamic> getOccupation() async {
    var response = await _dio.get(Endpoint.requestpekerjaan);
    List<Map> listPekerjaan = (response.data['occupations'] as List)
        .map((item) => item as Map)
        .toList();
    return listPekerjaan;
  }

  Future<dynamic> getAgentApplicationForm() async {
    var response = await _dio.get(Endpoint.agentApplicatioinForm);
    // List<Map> applicationForm =
    //     (response.data as List).map((item) => item as Map).toList();
    return response.data;
  }

  Future<dynamic> requestOTPAgen(mobileNumber, id) async {
    final param = {'customerId': id ?? ""};
    final response = await _dio.post(Endpoint.requestOtpAgen, data: param);
    // var response = await _dio.get(Endpoint.agentApplicatioinForm);
    // List<Map> applicationForm =
    //     (response.data as List).map((item) => item as Map).toList();
    return response.data;
  }

  Future<void> launchWhatsApp() async {
    String _url = 'https://wa.me/6282135388068';
    final Uri url = Uri.parse(_url);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<dynamic> voucherBusiness(businessId) async {
    final param = {'businessId': businessId};
    final response =
        await _dio.get(Endpoint.requestVoucher, queryParameters: param);
    // var response = await _dio.get(Endpoint.agentApplicatioinForm);
    // List<Map> applicationForm =
    //     (response.data as List).map((item) => item as Map).toList();
    return response.data['vouchers'];
  }

  Future<dynamic> removeAgentApplicationForm() async {
    var response = await _dio.delete(Endpoint.agentApplicatioinForm);
    // List<Map> applicationForm =
    //     (response.data as List).map((item) => item as Map).toList();

    AppDialog.snackBar(text: response.data.toString());
    return response.data;
  }

  Future<dynamic> getAgentProfile() async {
    try {
      var response = await _dio.get(Endpoint.agentProfile);
      // List<Map> applicationForm =
      //     (response.data as List).map((item) => item as Map).toList();

      return response.data;
    } on DioException catch (e) {
      var message =
          GetErrorMessage.getErrorMessage(e.response?.data?['errors'] ?? "");
      // AppDialog.snackBar(text: message);
      return message;
    }
  }

  Future<dynamic> retrieveLocation() async {
    Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.bestForNavigation)
        .timeout(const Duration(seconds: 15));
    Map? location = {"lat": position.latitude, "lng": position.longitude};
    return location ?? {"permission": "permission denied"};
  }
  // Future<void> getLocationPermission() async {
  //   LocationPermission permission;
  //   permission = await Geolocator.checkPermission();

  //   setState(() {
  //     locationDenied = permission == LocationPermission.deniedForever;
  //   });
  // }

  void setCity(city, double? lat, double? lng) {
    _sharedPrefs.set(SharedPreferencesKeys.cityId, city['id']);
    _sharedPrefs.set(SharedPreferencesKeys.userLocation, city['alias']);
    if (lat != null) {
      _sharedPrefs.set(SharedPreferencesKeys.latitude, lat);
      _sharedPrefs.set(SharedPreferencesKeys.longitude, lng);
    } else {
      _sharedPrefs.remove(SharedPreferencesKeys.latitude);
      _sharedPrefs.remove(SharedPreferencesKeys.longitude);
    }
  }
}
