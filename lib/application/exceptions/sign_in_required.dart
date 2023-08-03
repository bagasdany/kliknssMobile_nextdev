import 'package:dio/dio.dart';

class SignInRequiredException extends DioException {
  SignInRequiredException({required RequestOptions requestOptions})
      : super(requestOptions: requestOptions);
}

class ValidationError extends DioException {
  ValidationError({required RequestOptions requestOptions})
      : super(requestOptions: requestOptions);
}

class AuthError extends DioException {
  AuthError({required RequestOptions requestOptions})
      : super(requestOptions: requestOptions);
}
