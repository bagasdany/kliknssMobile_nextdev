import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs_key.dart';
import 'package:kliknss77/ui/component/get_error_message.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:stacked_services/stacked_services.dart';
import 'package:events_emitter/events_emitter.dart';

class AuthApi {
  final Dio _dio = DioService.getInstance();
  Map data = {};
  final events = EventEmitter();

  final _sharedPrefs = SharedPrefs();
  // final _popUpDialogService = locator<DialogService>();
  Position? currentPosition;
  final location = SharedPrefs().get(SharedPreferencesKeys.userLocation);
  final username = SharedPrefs().get(SharedPreferencesKeys.customerName);

  Future<Position> getPosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error("Location not available");
      }
    } else {}
    return await Geolocator.getCurrentPosition();
  }

  Future<Map> getTokenInfo() async {
    try {
      final response = await _dio.get(Endpoint.authInfo);
      return response.data;
    } on DioException catch (e) {
      dynamic message =GetErrorMessage.getErrorMessage(e.response?.data['errors'] ?? "");
      // final errorMessage = DioExceptions.fromDioError(e).toString();

      return {};
    }
  }

  static Future<bool> saveImage(List<int> imageBytes) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String base64Image = base64Encode(imageBytes);
    return prefs.setString("image", base64Image);
  }

  Future<dynamic> getImage() async {
    final opened = await _sharedPrefs.get('firstInstall');
    if (opened == null) {
      AuthApi().refreshLoginInfo();
      _sharedPrefs.set('firstInstall', true);
      return null;
    } else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      dynamic bytes = base64Decode(prefs.getString("image") ?? "");
      return bytes;
    }
  }

  Future<void> refreshLoginInfo() async {
    //splash
    dynamic iconLogo =
        SharedPrefs().get(SharedPreferencesKeys.iconLogo) ?? "first";
    dynamic iconbgColor =
        SharedPrefs().get(SharedPreferencesKeys.iconbgColor) ?? "first";
    dynamic delay = SharedPrefs().get(SharedPreferencesKeys.delay) ?? "first";

    //bottom banner
    dynamic textbottomBanner =
        SharedPrefs().get(SharedPreferencesKeys.text) ?? "first";
    dynamic imageUrlbottomBanner =
        SharedPrefs().get(SharedPreferencesKeys.imageUrl) ?? "first";
    dynamic backgroundColorbottomBanner =
        SharedPrefs().get(SharedPreferencesKeys.bgColor) ?? "first";
    var data = await getTokenInfo();
    if (data['customerId'] == null) {
      await SharedPrefs().remove(SharedPreferencesKeys.customerId);
      await SharedPrefs().remove(SharedPreferencesKeys.customerName);
      await SharedPrefs().remove(SharedPreferencesKeys.sessionId);
    } else {
      await SharedPrefs()
          .set(SharedPreferencesKeys.customerId, data['customerId']);
      await SharedPrefs()
          .set(SharedPreferencesKeys.sessionId, data['sessionId']);
      events.emit('customerId', data['customerId']);
      events.emit('userIdChanged',data['customerId']);
    }
    if (data['splash'] != null &&
        (iconLogo != data['splash']['imageUrl'] ||
            iconbgColor != data['splash']['bgColor'] ||
            delay != data['splash']['delay'])) {
      var fetchedFile = await DefaultCacheManager().getSingleFile(data['splash']['imageUrl']);
      await SharedPrefs()
          .set(SharedPreferencesKeys.iconLogo, data['splash']['imageUrl']);
      await SharedPrefs()
          .set(SharedPreferencesKeys.iconbgColor, data['splash']['bgColor']);
      await SharedPrefs()
          .set(SharedPreferencesKeys.delay, data['splash']['delay']);
      File imageFile = File(fetchedFile.path);
      List<int> imageBytes = imageFile.readAsBytesSync();
      await saveImage(imageBytes);
    }
    if (data['bottomBanner'] != null &&
        (textbottomBanner != data['bottomBanner']['text'] ||
            imageUrlbottomBanner != data['bottomBanner']['imageUrl'] ||
            backgroundColorbottomBanner != data['bottomBanner']['bgColor'])) {
      await SharedPrefs()
          .set(SharedPreferencesKeys.text, data['bottomBanner']['text']);
      await SharedPrefs().set(
          SharedPreferencesKeys.imageUrl, data['bottomBanner']['imageUrl']);
      await SharedPrefs()
          .set(SharedPreferencesKeys.bgColor, data['bottomBanner']['bgColor']);
    }
  }

  Future<bool> signOut() async {
    await _dio.post(Endpoint.signout, data: {});
    // await getTokenInfo();
    return true;
  }

  void setUserID(userToken) async {
    await _sharedPrefs.set(SharedPreferencesKeys.userToken, userToken);
    events.emit('userToken', userToken);
  }

  Future<bool> refreshToken() async {
    final refreshToken = SharedPrefs().get(SharedPreferencesKeys.refreshToken);
    final response = await _dio
        .post(Endpoint.requestToken, data: {'refreshToken': refreshToken});

    if (response.statusCode == 200) {
      await SharedPrefs()
          .set(SharedPreferencesKeys.userToken, response.data['token']);
      await SharedPrefs().set(
          SharedPreferencesKeys.refreshToken, response.data['refreshToken']);
      setUserID(response.data['token']);

      events.emit('userToken', response.data['token']);
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> refreshTokenChat() async {
    final refreshToken = SharedPrefs().get(SharedPreferencesKeys.refreshToken);
    final response = await _dio
        .post(Endpoint.requestToken, data: {'refreshToken': refreshToken});

    if (response.statusCode == 200) {
      await SharedPrefs()
          .set(SharedPreferencesKeys.userToken, response.data['token']);
      await SharedPrefs().set(
          SharedPreferencesKeys.refreshToken, response.data['refreshToken']);
      setUserID(response.data['token']);

      events.emit('userToken', response.data['token']);
      return response.data['token'];
    } else {
      return null;
    }
  }

  Future<String?> requestToken() async {
    final response = await _dio.post(Endpoint.requestToken);

    if (response.statusCode == 200) {
      await SharedPrefs().set(SharedPreferencesKeys.userToken, response.data['token']);
      await SharedPrefs().set(
          SharedPreferencesKeys.refreshToken, response.data['refreshToken']);
      await SharedPrefs().remove(SharedPreferencesKeys.customerId);
      await SharedPrefs().remove(SharedPreferencesKeys.customerName);
      return response.data['token'];
    }
    return null;
  }

  // void showBadRequestDialog(String description) async {
  //   await _popUpDialogService.showCustomDialog(
  //     variant: PopUpDialogType.base,
  //     title: 'Maaf!',
  //     description: description,
  //     mainButtonTitle: 'Oke',
  //   );
  // }
}
