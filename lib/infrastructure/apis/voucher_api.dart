import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/models/vouchers_models.dart';
import 'package:kliknss77/application/services/dio_service.dart';

class VoucherApi {
  final Dio _dio = DioService.getInstance();

  Future<Either<ResponseGetVoucherModel, ResponseGetVoucherModel>>
      requestVoucher(businessId, seriesId, typeId, colorId) async {
    try {
      final param = {
        'businessId': businessId.toString(),
        'seriesId': seriesId,
        'typeId': typeId,
        'colorId': colorId
      };
      print("paramsss $param");
      final responList =
          await _dio.get(Endpoint.requestVoucher, queryParameters: param);
      return Right(ResponseGetVoucherModel.fromJson(responList.data));
    } on DioException catch (e) {
      return Left(
        ResponseGetVoucherModel.errorJson(
          {
            'error': e.response?.data['error 1'],
            'data': e.response?.data['error data'],
          },
        ),
      );
    }
  }

  Future<Either<ResponseGetVoucherModel, ResponseGetVoucherModel>>
      requestVoucherByCode(businessId, code, seriesId, typeId, colorId,
          paymentMethod, paymentType, price, term, cityId) async {
    try {
      // businessId=1&paymentMethod=2&paymentType=2&seriesId=140
      // &typeId=476&colorId=726&cityId=158&price=12000000&term=35
      // &code=PTDP500
      final param = {
        'businessId': businessId,
        'code': code,
        'seriesId': seriesId,
        'typeId': typeId,
        'colorId': colorId,
        'paymentMethod': paymentMethod,
        'paymentType': paymentType,
        'price': price,
        'term': term,
        'cityId': cityId,
      };
      print("paramsss $param");
      return Future.delayed(const Duration(milliseconds: 300), () async {
        final responList =
            await _dio.get(Endpoint.requestVoucher, queryParameters: param);
        print("responList $responList");
        return Right(ResponseGetVoucherModel.fromJson(responList.data));
      });
    } on DioException catch (e) {
      return Left(
        ResponseGetVoucherModel.errorJson(
          {
            'error': e.response?.data['error 1'],
            'data': e.response?.data['error data'],
          },
        ),
      );
    }
  }
}
