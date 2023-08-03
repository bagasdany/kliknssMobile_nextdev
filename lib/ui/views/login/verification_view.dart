// ignore_for_file: avoid_unnecessary_containers

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/flavors.dart';
import 'package:kliknss77/infrastructure/apis/verification_api.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs_key.dart';
import 'package:kliknss77/ui/component/app_dialog.dart';
import 'package:kliknss77/ui/component/button.dart';
import 'package:kliknss77/ui/component/get_error_message.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../infrastructure/database/shared_prefs.dart';

import '../../component/dio_exceptions.dart';
import 'package:events_emitter/events_emitter.dart';


class VerifikasiView extends StatefulWidget {
  final int customerId;
  final String mobileNumber;
  final Function? onSuccess;

  VerifikasiView(
      {Key? key,
      required this.customerId,
      required this.mobileNumber,
      this.onSuccess})
      : super(key: key);

  @override
  _VerifikasiViewState createState() => _VerifikasiViewState();
}

final events = EventEmitter();

class _VerifikasiViewState extends State<VerifikasiView>
    with TickerProviderStateMixin {
  final valueOtpController = TextEditingController();

  final _sharedPrefs = SharedPrefs();

  final Dio _dio = DioService.getInstance();
  int state = 0;
  Map component = {};
  String? verificationcode = "";
  Map type = {};

  EventListener? listener;
  EventListener? listenerbadges;

  dynamic userID = SharedPrefs().get(SharedPreferencesKeys.customerId);

  final events = EventEmitter();

  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 19;
  int endTime2 = DateTime.now().millisecondsSinceEpoch + 1000 * 60;

  TextEditingController pinController = TextEditingController();
  bool isValid = false;
  void nextField({String? value, FocusNode? focus}) {
    if (value!.length == 1) {
      focus!.requestFocus();
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void validate() {
    bool _isValid = pinController.text.length == 4;

    setState(() {
      isValid = _isValid;
    });
  }

  Widget field({FocusNode? focus, FocusNode? next, bool autofocus = false}) {
    return SizedBox(
      width: 64,
      child: TextFormField(
          autofocus: autofocus,
          focusNode: focus,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.left,
          onChanged: (e) {
            next != null ? nextField(value: e, focus: next) : null;
          },
          decoration: const InputDecoration(
              fillColor: Colors.green,
              border: OutlineInputBorder(borderSide: BorderSide.none))),
    );
  }

  void requestOTP(context) async {
    try {
      final param = {'mobileNumber': widget.mobileNumber};

      Response response = await _dio.post(Endpoint.requestOtp, data: param);

      // var verificationCode = response.data['verificationCode'];
      // //masih dipakai
    } on DioException catch (e) {
      dynamic message = GetErrorMessage.getErrorMessage(
          e.response?.data?['errors'] ??
              "Terjadi Kesalahan, silahkan coba lagi");
      AppDialog.snackBar(text: message ?? "");
      dynamic errors = DioExceptions.fromDioError(e);
      if (errors != null) {
        if (errors.message == "No Internet") {
        } else {}
      }
    }
  }

  

  Future<void> setUserID(userID) async {
    await _sharedPrefs.set(SharedPreferencesKeys.customerId, userID);
    events.emit('userIdChanged', userID);
    events.emit('buildLogin', true);
  }

  bool changeColor = false;
  ScrollController? secrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (listener != null) {
      events.removeEventListener(listener!);
    }
    if (listenerbadges != null) {
      events.removeEventListener(listener!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    var newString =
        widget.mobileNumber.substring(0, widget.mobileNumber.length - 5);

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
            // AppNavigatorService.pushReplacementNamed('/login');
          },
          child: const Icon(
            Icons.arrow_back,
            color: Constants.black,
          ),
        ),
        automaticallyImplyLeading: true,
        shadowColor: Colors.transparent,
        backgroundColor: Constants.gray.shade100,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Container(
                color: Constants.gray.shade100,
                child: GestureDetector(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Constants.spacing10),
                      margin:const EdgeInsets.symmetric(vertical: Constants.spacing10),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Verifikasi',
                            style: Constants.heading1,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Kode verifikasi telah dikirimkan ke nomor +62${newString}xxxxx",
                            style: Constants.textLg,
                          ),
                        ],
                      ),
                      // color: Colors.red,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Constants.spacing10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: Constants.spacing2),
                            child: const Text("Kode verifikasi",
                                style: TextStyle(
                                    fontSize: Constants.fontSizeLg,
                                    color: Constants.gray)),
                          ),
                          PinCodeTextField(
                            key: const ValueKey("pinCode"),
                            appContext: context,
                            length: 4,
                            pastedTextStyle: const TextStyle(
                              color: Color.fromARGB(255, 235, 4, 4),
                              fontWeight: FontWeight.bold,
                            ),
                            blinkWhenObscuring: true,
                            controller: pinController,
                            pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(20),
                                fieldHeight: 70,
                                fieldWidth: 65,
                                activeColor: Constants.gray,
                                activeFillColor: Colors.white,
                                inactiveColor: Constants.white,
                                inactiveFillColor: Constants.white,
                                selectedColor: Constants.white,
                                selectedFillColor: Constants.white),
                            cursorColor: Colors.black,
                            animationDuration:
                                const Duration(milliseconds: 300),
                            enableActiveFill: true,
                            keyboardType: TextInputType.number,
                            onCompleted: (v) {
                              // valueOtpController.clear();
                              pinController.text.length == 4 ? v = "" : null;
                            },
                            beforeTextPaste: (text) {
                              return true;
                            },
                            onChanged: (value) {
                              validate();

                              // viewModel.onChangeValueOtp(value);
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin:
                                const EdgeInsets.only(top: Constants.spacing2),
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constants.spacing10),
                            child: Button(
                              key: const ValueKey("verificationButton"),
                              fontSize: Constants.fontSizeLg,
                              text: "Lanjut",
                              state: isValid
                                  ? ButtonState.values[state]
                                  : ButtonState.disabled,
                              onPressed: isValid
                                  ? () async{
                                      setState(() {
                                        state = 2;
                                      });
                                    await VerificationApi().requestVerification(context, widget.customerId,
                                      pinController.text, widget.mobileNumber, widget.onSuccess).then((value) {
                                    if(value == -1) {
                                              setState(() {
                                                valueOtpController.clear();
                                                pinController.text = "";
                                                state = 0;
                                              });
                                            }       
                                   });
                                      
                                    }
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
              ),
            ),
            Container(
              child: Center(
                child: CountdownTimer(
                  endTime: endTime,
                  widgetBuilder: (_, time) {
                    if (time == null) {
                      return Center(
                        child: SizedBox(
                          width: 200,
                          child: InkWell(
                            onTap: () {
                              requestOTP(context);
                              setState(() {
                                endTime =
                                    DateTime.now().millisecondsSinceEpoch +
                                      (F.appFlavor?.name == "prod" ? 1000 * 60  :
                                        1000 * 12);
                              });
                            },
                            child: Text(
                              
                              "Kirim Ulangss",
                              key: const ValueKey("resendButton"),
                              style: TextStyle(
                                color: Constants.primaryColor.shade400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'kirim ulange',
                          style: TextStyle(
                            color: Constants.gray.shade400,
                            // fontSize: Constants.fontSizeLg,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          
                          '(00:${time.sec! < 10 ? "0${time.sec}" : time.sec}) ',
                          key: const ValueKey("initialResendButton"),
                          style: TextStyle(
                            color: Constants.gray.shade400,
                            fontSize: Constants.fontSizeMd,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              },
              child: Container(
                
                padding: const EdgeInsets.all(Constants.spacing6),
                child: Text(
                  'Lanjut Tanpa Login',
                  key: const ValueKey("skipButton"),
                  style: TextStyle(color: Constants.primaryColor.shade400),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginInterceptor extends InterceptorsWrapper {
  Function(dynamic)? callback;

  LoginInterceptor({this.callback});

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    dynamic responseuserId =
        SharedPrefs().get(SharedPreferencesKeys.customerId);
    dynamic responseLoginInfo = SharedPrefs().get(SharedPreferencesKeys.badges);

    String? responseBadges = "${responseLoginInfo ?? "0,0,0"}";

    await SharedPrefs().set(SharedPreferencesKeys.badges, responseBadges);
    List<String> listBadges = responseBadges.split(',');

    events.emit('buildLogin', true);
    if (callback != null) {
      callback!(listBadges);
    }
    events.emit('buildLogin', responseuserId);
    super.onResponse(response, handler);
  }
}
