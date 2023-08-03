import 'package:dio/dio.dart';

class UnauthorizedException extends DioException{
  UnauthorizedException({required RequestOptions requestOptions}) : super(requestOptions: requestOptions);
}