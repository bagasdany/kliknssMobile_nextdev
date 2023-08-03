import 'package:dio/dio.dart';

class InternalServerErrorException extends DioException{
  InternalServerErrorException({required RequestOptions requestOptions}) : super(requestOptions: requestOptions);
}