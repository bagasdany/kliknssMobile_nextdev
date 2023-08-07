import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import '../../ui/component/dio_exceptions.dart';

class NotificationApi {
  final Dio _dio = DioService.getInstance();

  subscribe() async {
    FirebaseMessaging.instance.getToken().then((value) async {
      String? token = value;

      if (token != null) {
        try {
          final data = {'deviceToken': token};
          await _dio.post(Endpoint.subscribeNotification, data: data);
        } on DioException catch (e) {
          dynamic errorMessage = DioExceptions.fromDioError(e);
        }
      }
    });
  }

  setAsRead(id) async {
    await _dio.post("${Endpoint.notification}/${id}/read");
  }
}
