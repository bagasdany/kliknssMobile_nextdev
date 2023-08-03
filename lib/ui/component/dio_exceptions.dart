import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  String? message;

  DioExceptions.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = "No Internet";
        break;
      case DioExceptionType.connectionTimeout:
        message = "No Internet";
        break;
      case DioExceptionType.receiveTimeout:
        message = "No Internet";
        break;

      case DioExceptionType.sendTimeout:
        message = "No Internet";
        break;
      case DioExceptionType.unknown:
        if ((dioError.message ?? "").contains("SocketException")) {
          message = 'No Internet';
          break;
        } else if ((dioError.message ?? "")
            .contains("Connection reset by peer")) {
          message = 'Maintenance';
          break;
        }
        // message = "Unexpected error occurred";
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return error['message'];
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message ?? "";
}
