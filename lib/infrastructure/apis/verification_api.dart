import 'package:dio/dio.dart';
import 'package:events_emitter/emitters/event_emitter.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/services/debouncer.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/flavors.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs_key.dart';
import 'package:kliknss77/ui/component/app_dialog.dart';
import 'package:kliknss77/ui/component/dio_exceptions.dart';
import 'package:kliknss77/ui/component/get_error_message.dart';
import 'package:kliknss77/ui/views/signup/signup_view.dart';

import '../database/shared_prefs.dart';

class VerificationApi {
  final Dio _dio = DioService.getInstance();
  final _sharedPrefs = SharedPrefs();

  final _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  
  final events = EventEmitter();

  Future<dynamic> selectCartinCity(List? listId, selected) async {
    var params = {'id': listId, 'selected': selected};
    var response = await _dio.post(Endpoint.selectIteminCity, data: params);

    return response.data;
  }

  Future<dynamic> deleteUser(phone) async {
    var params = {'mobileNumber': phone};
    var response = await _dio.delete(Endpoint.updateUser, data: params);
    return response.data;
  }

  Future<dynamic> requestVerification(context,customerId,pinControllerText,mobileNumber,onSuccess) async {
    try {
      final param = {
        "customerId": customerId,
        "verificationCode": F.appFlavor?.name == "prod" ? int.parse(pinControllerText): pinControllerText
      };
      final response = await _dio.post(Endpoint.verificationOtp, data: param);

      await SharedPrefs()
          .set(SharedPreferencesKeys.customerId, response.data['customerId']);

      await SharedPrefs().set(SharedPreferencesKeys.buildLogin, true);

     await setUserID(response.data['customerId']).then((value) {

      events.emit('buildLogin', true);

      events.emit('userIdChanged', response.data['customerId']);
     });

      events.emit('buildLogin', true);

      events.emit('userIdChanged', response.data['customerId']);

      if (response.data['requireUpdateProfile'] == true) {
        FocusScope.of(context).unfocus();

        bool signup = false;

        await Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => SignUpView(
                isLogin: true,
                mobileNumber: mobileNumber,
                onSuccess: () async {
                  signup = true;
                  if (onSuccess != null) {
                    onSuccess!();
                  }
                })));

        if (signup) {
          Navigator.of(context).pop();
          if (onSuccess != null) {
            onSuccess!();
          }
        }
        //  Navigator.pushNamedAndRemoveUntil(
        //                 context, '/', (route) => false);
      } else {
        Navigator.pop(context);
        if (onSuccess != null) {
          onSuccess!();
        }
      }
    } on DioException catch (e) {
      // setState(() {
      //   valueOtpController.clear();
      //   pinController.text = "";
      //   state = 0;
      // });
      var snack =
          GetErrorMessage.getErrorMessage(e.response?.data['errors'] ?? "");
      AppDialog.snackBar(text: snack);
      dynamic errors = DioExceptions.fromDioError(e);
      if (errors != null) {
        if (errors.message == "No Internet") {
        } else {}
      }
      return -1;
    }
  }
  
  Future<void> setUserID(userID) async {
    await _sharedPrefs.set(SharedPreferencesKeys.customerId, userID);
    events.emit('userIdChanged', userID);
    events.emit('buildLogin', true);
  }


}
