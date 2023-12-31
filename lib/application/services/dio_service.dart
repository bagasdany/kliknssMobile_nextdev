import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';

import 'package:dio/dio.dart';
import 'package:kliknss77/flavors.dart';
import 'package:kliknss77/infrastructure/apis/api_interceptor.dart';

class DioService {
  static Dio getInstance() {
    
    String version = '2.0.0';
    String os = Platform.isAndroid ? 'Android' : (Platform.isIOS ? 'iOS' : 'Unknown');
    String osVersion = Platform.operatingSystemVersion;

    final dio = Dio(
      BaseOptions(
          persistentConnection: true,
          baseUrl: F.variables['baseURL'] as String,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),

          sendTimeout: const Duration(seconds: 1),
          headers: {'User-Agent': 'KlikNSS/$version $os $osVersion'}),
    );

    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      deviceInfoPlugin.androidInfo.then((deviceData) {
        dio.options.headers['User-Agent'] =
            'KlikNSS/$version $os $osVersion ${deviceData.model}';
      });
    } else if (Platform.isIOS) {
      deviceInfoPlugin.iosInfo.then((deviceData) {
        dio.options.headers['User-Agent'] =
            'KlikNSS/$version $os $osVersion ${deviceData.utsname.machine}';
      });
    }

    dio.interceptors.add(ApiInterceptor());

    return dio;
  }
}
