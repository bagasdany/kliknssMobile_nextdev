import 'package:dio/dio.dart';

class NotFoundException extends DioException{
  NotFoundException({required RequestOptions requestOptions}) : super(requestOptions: requestOptions);
}