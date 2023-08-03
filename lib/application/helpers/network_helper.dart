import 'package:dio/dio.dart';
import 'package:flutter_logs/flutter_logs.dart';

class NetworkLogger {
  static void logHeaderOptions({
    required dynamic token,
    required RequestOptions options,
  }) {
    /*developer.log('===== onRequest =====\n');
    developer.log(options.path, name: 'path');
    developer.log('${options.headers}', name: 'headers');
    developer.log('${options.queryParameters}', name: 'queryParameters');
    developer.log('${options.data}', name: 'data');
    developer.log('token $token', name: 'token');
    developer.log('=====================\n');*/

    /*_networkLogger('===== onRequest =====\n');
    _networkLogger('[PATH]: ${options.path}\n');
    _networkLogger('[HEADERS]: ${options.headers}\n');
    _networkLogger('[QUERY PARAM]: ${options.queryParameters}\n');
    _networkLogger('[PAYLOAD]: ${options.data}\n');
    _networkLogger('=====================\n');*/
  }

  static void logResponse(Response response) {
    /*_networkLogger('===== onResponse =====\n');
    _networkLogger('[PATH]: ${response.requestOptions.path}\n');
    _networkLogger('[DATA]: ${response.data}\n');
    _networkLogger('======================\n');*/
  }

  static void _networkLogger(String logMessage) {
    FlutterLogs.logToFile(
      logFileName: 'network',
      overwrite: false,
      logMessage: logMessage,
    );
  }
}
