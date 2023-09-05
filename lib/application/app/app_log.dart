import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs_key.dart';
import '../../infrastructure/database/shared_prefs.dart';
import '../../ui/component/dio_exceptions.dart';

class AppLog {

  static List errors = [];
  static List logs = [];

  Future<void> reportError(String message, String detail) async {
    var param = {
      'type': 'error',
      'error': {'message': message, 'trace': detail}
    };
    AppLog.errors.add(param);
    print("error global list $errors");
  }

  Future<void> logPurchase(
      {String? coupon,
      int? value,
      List<dynamic>? items,
      double? shipping,
      String? transactionId}) async {
    List<AnalyticsEventItem>? gaItems;
    if (items != null) {
      gaItems = [];
      items.map((item) {
        gaItems?.add(AnalyticsEventItem(
            itemName: item['name'], quantity: item['quantity']));
      });
    }

    await FirebaseAnalytics.instance.logPurchase(
        currency: 'IDR',
        coupon: coupon,
        value: value?.toDouble(),
        items: gaItems,
        shipping: shipping,
        transactionId: transactionId);
  }

  Future<void> logScreenView(String screenName) async {
    AppLog.logs.add({"t": 1, "p": screenName, "ts": DateTime.now().millisecondsSinceEpoch});
    //
    await FirebaseAnalytics.instance.logScreenView(
        screenClass: screenName.replaceAll(RegExp(r"\s+"), ""),
        screenName: screenName);
  }

  Future<void> flush() async {
    final Dio _dio = DioService.getInstance();
    
    try {
      if (AppLog.errors.isNotEmpty || AppLog.logs.isNotEmpty) {
        try {
          AppLog.errors.removeWhere((item) =>
              item['error']['message'] ==
              'Failed host lookup: www.kliknss.co.id');
          AppLog.errors.removeWhere(
              (item) => item['error']['message'] == 'CameraException');
          AppLog.errors
              .removeWhere((item) => item['error']['message'] == 'No Internet');
          AppLog.errors.removeWhere(
              (item) => item['error']['message'].contains("SocketException"));
          AppLog.errors.removeWhere((item) =>
              item['error']['message'].contains("No host specified in URI"));
          AppLog.errors.removeWhere((item) => item['error']['message']
              .contains("Exception: Invalid image data"));
          AppLog.errors.removeWhere((item) => item['error']['message'].contains(
              "DioError [DioExceptionType.response]: Http status error [429]"));
          AppLog.errors.removeWhere((item) => item['error']['message'].contains(
              "DioError [DioExceptionType.response]: Http status error [400]"));
          AppLog.errors.removeWhere((item) =>
              item['error']['message'].contains("Connection timed out"));

          AppLog.errors.removeWhere((item) => item['error']['message']
              .contains("Connection closed while receiving data"));

          AppLog.errors.removeWhere((item) =>
              item['error']['message'].contains("Connection reset by peer"));

          AppLog.errors.removeWhere(
              (item) => item['error']['message'].contains("Write failed"));

          AppLog.errors.removeWhere(
              (item) => item['error']['message'].contains("Read failed"));

          AppLog.errors.removeWhere((item) => item['error']['message']
              .contains("Software caused connection abort"));

          AppLog.errors.removeWhere((item) => item['error']['message']
              .contains("Connection closed before full header was received"));

          AppLog.errors.removeWhere((item) => item['error']['message'].contains(
              "CameraException(Disposed CameraController, buildPreview() was called on a disposed CameraController.)"));

          AppLog.errors.removeWhere(
              (item) => item['error']['message'].contains("Broken pipe"));

          AppLog.errors.removeWhere((item) => item['error']['message'].contains(
              "DioError [DioExceptionType.response]: Http status error [400]"));
          AppLog.errors.removeWhere((item) =>
              item['error']['message'].contains("Failed host lookup"));
          AppLog.errors.removeWhere(
              (item) => item['error']['message'].contains("Connection failed"));

          AppLog.errors.removeWhere((item) => item['error']['message']
              .contains("The request returned an invalid status code of 400"));

          AppLog.errors.removeWhere((item) =>
              item['error']['message'].contains("Unexpected error occurred"));

          AppLog.errors.removeWhere((item) => item['error']['message'].contains(
              "CameraException(Uninitialized CameraController, stopImageStream()"));

          AppLog.errors.removeWhere((item) => item['error']['message'].contains(
              "DioError [DioExceptionType.other]: HttpException: Software caused connection abort, uri"));
          AppLog.errors.removeWhere(
              (item) => item['error']['message'].contains("Error: Bad state"));
          AppLog.errors.removeWhere((item) => item['error']['message'].contains(
              "DioError [bad response]: The request returned an invalid status code of 401."));
          AppLog.errors.removeWhere((item) => item['error']['message'].contains(
              "DioError [DioExceptionType.other]: HttpException: Software caused connection abort, uri = https://api.kliknss.co.id/auth"));
          AppLog.errors.removeWhere((item) =>
              item['error']['message'].contains("DioError [unknown]: null"));

          await _dio.post(Endpoint.logging, data: {
            "errors": AppLog.errors,
            "logs": AppLog.logs,
            "sessionId": SharedPrefs().get(SharedPreferencesKeys.sessionId)
          });
          print("flush");

          AppLog.errors = [];
          AppLog.logs = [];
        } on DioException catch (e) {
          dynamic errors = DioExceptions.fromDioError(e);
          if (errors != null) {
            if (errors.message == "No Internet") {
            } else {}
          }
        }
      }
    } on DioException catch (e) {
      dynamic errors = DioExceptions.fromDioError(e);
      if (errors != null) {
        if (errors.message == "No Internet") {
        } else {}
      }
    }
  }
}