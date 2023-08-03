import 'dart:async';

// import 'package:mobileapps/application/app/contants/endpoint.dart';

import 'package:kliknss77/application/exceptions/forbidden.dart';
import 'package:kliknss77/application/exceptions/internal_server_error.dart';
import 'package:kliknss77/application/exceptions/not_found.dart';
import 'package:kliknss77/application/exceptions/sign_in_required.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/helpers/network_helper.dart';
import 'package:kliknss77/infrastructure/apis/auth_api.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs_key.dart';
import 'package:kliknss77/ui/component/app_dialog.dart';

import '../../flavors.dart';
import 'package:dio/dio.dart';
// import 'package:mobileapps/application/app/contants/shared_preferences_key.dart';
// import 'package:mobileapps/application/exceptions/forbidden.dart';
// import 'package:mobileapps/application/exceptions/internal_server_error.dart';
// import 'package:mobileapps/application/exceptions/not_found.dart';
// import 'package:mobileapps/application/exceptions/sign_in_required.dart';
// import 'package:mobileapps/application/helpers/network_helper.dart';
// import 'package:mobileapps/infrastructure/database/shared_prefs.dart';
// import 'package:mobileapps/ui/component/app_dialog.dart';

// import 'auth_api.dart';

class ApiInterceptor extends InterceptorsWrapper {
  final Dio api = Dio();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = SharedPrefs().get(SharedPreferencesKeys.userToken);

    if ((token == '' ||
            token == null ||
            token == 'invalid token' ||
            token == 'jwt malformed' ||
            token == 'jwt signature is required' ||
            token == 'invalid signature' ||
            token == 'jwt audience invalid. expected: [OPTIONS AUDIENCE]' ||
            token == 'jwt issuer invalid. expected: [OPTIONS ISSUER]' ||
            token == 'jwt id invalid. expected: [OPTIONS JWT ID]' ||
            token == 'jwt subject invalid. expected: [OPTIONS SUBJECT]') &&
        ![Endpoint.requestToken].contains(options.path)) {
      if (await AuthApi().requestToken() != null) {
        return handler.resolve(await _retry(options));
      } else {
        // TODO: Handle this situation
      }
    } else {
      if (options.data is FormData) {
        options.contentType = 'multipart/form-data';
        options.headers['Content-Type'] = 'multipart/form-data';
      } else {
        options.contentType = "application/json";
      }
      options.headers['KlikNSS-Token'] = token ?? '';

      if (options.data is FormData) {}
    NetworkLogger.logHeaderOptions(token: token, options: options);
      super.onRequest(options, handler);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.data != null &&
        response.data.runtimeType.toString() ==
            '_InternalLinkedHashMap<String, dynamic>' &&
        response.data['offer'] != null) {
      final opened = await SharedPrefs().get('opened');
      if (!opened) {
        Map offer = response.data['offer'];
        AppDialog.showOffer(
            imageUrl: offer['imageUrl'],
            target: offer['target'],
            delay: offer['delay'],
            timeout: offer['timeout']);
      }
    }

    NetworkLogger.logResponse(response);

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // if (err.type == DioExceptionType.connectTimeout ||
    //     err.type == DioExceptionType.receiveTimeout ||
    //     err.message.contains("SocketException: Failed")) {
    //   AppDialog.alert(
    //       title: "Koneksi internetmu tergangguee!",
    //       description:
    //           "Pastikan internetmu lancar dengan cek ulang paket data, Wifi, atau jaringan di tempatmu.");
    // } else {}
    // if (err.type == DioExceptionType.receiveTimeout ||
    //     err.type == DioExceptionType.connectTimeout) {
    //   // AppDialog.alert(
    //   //     title: 'Gagal memuat data', description: 'Harap coba kembali');
    // } else

    if (err.type == DioExceptionType.badResponse) {
      switch (err.response?.statusCode) {
        case 401:
          if (err.response!.data["errors"] == "Token expired" ||
              err.response!.data["errors"] == "Token refresh required") {
            if (await AuthApi().refreshToken()) {
              handler.resolve(await _retry(err.requestOptions));
            } else {
              super.onError(err, handler);
            }
          } else if (err.response!.data["errors"] == "Token required") {
            if (await AuthApi().refreshToken()) {
              handler.resolve(await _retry(err.requestOptions));

              await SharedPrefs().remove(SharedPreferencesKeys.customerName);
              await SharedPrefs().remove(SharedPreferencesKeys.userToken);
              await SharedPrefs().remove(SharedPreferencesKeys.customerId);
            } else {
              super.onError(err, handler);
            }
          } else if (err.response!.data['errors'] ==
              "Sign in required to access this resource") {
            await SharedPrefs().remove(SharedPreferencesKeys.customerName);
            await SharedPrefs().remove(SharedPreferencesKeys.customerId);

            handler.next(
                SignInRequiredException(requestOptions: err.requestOptions));
          } else {
            super.onError(err, handler);
          }
          break;

        case 403:
          handler.next(ForbiddenException(requestOptions: err.requestOptions));
          break;

        case 404:
          handler.next(NotFoundException(requestOptions: err.requestOptions));
          break;

        case 500:
          handler.next(
              InternalServerErrorException(requestOptions: err.requestOptions));
          break;

        default:
          super.onError(err, handler);
      }
    } else {
      super.onError(err, handler);
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    var headers = requestOptions.headers;

    headers['KlikNSS-Token'] =
        SharedPrefs().get(SharedPreferencesKeys.userToken);

    final options = Options(
        method: requestOptions.method,
        headers: headers,
        receiveTimeout: Duration(seconds: 15),
        sendTimeout: Duration(seconds: 15));

    return api.request<dynamic>(F.variables['baseURL'] + requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }
}
