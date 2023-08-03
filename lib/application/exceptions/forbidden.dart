import 'package:dio/dio.dart';

class ForbiddenException extends DioException{
  ForbiddenException({required RequestOptions requestOptions}) : super(requestOptions: requestOptions);
}