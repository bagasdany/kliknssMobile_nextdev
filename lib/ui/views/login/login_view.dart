// main.dart

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/flavors.dart';
import 'package:kliknss77/infrastructure/apis/verification_api.dart';
import 'package:kliknss77/ui/component/app_dialog.dart';
import 'package:kliknss77/ui/component/button.dart';
import 'package:kliknss77/ui/component/dio_exceptions.dart';
import 'package:kliknss77/ui/component/get_error_message.dart';
import 'package:kliknss77/ui/views/login/verification_view.dart';
import 'package:kliknss77/ui/views/signup/signup_view.dart';
import '../../../infrastructure/database/shared_prefs.dart';

class LoginView extends StatefulWidget {
  static String? title;
  final bool? status;
  final Function? onSuccess;
  final Function? onCancel;

  const LoginView({Key? key, this.onSuccess, this.onCancel, this.status})
      : super(key: key);
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  final valueOtpController = TextEditingController();
  final Dio _dio = DioService.getInstance();
  final TextEditingController otpController = TextEditingController();
  bool valid = false;
  ButtonState pageState = ButtonState.normal;
  int state = 0;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void validate() {
    bool _isValid = otpController.text.length > 8;

    setState(() {
      valid = _isValid;
    });
  }

  void requestOTP(context, mobileNumber) async {
    try {
      setState(() {
        state = 2;
        pageState = ButtonState.loading;
      });

      final param = {'mobileNumber': mobileNumber ?? ""};
      final response = await _dio
          .post(Endpoint.requestOtp, data: param)
          .timeout(const Duration(seconds: 15));
      setState(() {
        pageState = ButtonState.normal;
        state = 1;
      });

      bool verified = false;

      FocusScope.of(context).unfocus();

      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerifikasiView(
                    customerId: response.data['customerId'],
                    mobileNumber: otpController.text,
                    onSuccess: () {
                      verified = true;
                    },
                  )));

      if (verified) {
        Navigator.of(context).pop();
        if (widget.onSuccess != null) {
          widget.onSuccess!();
        }
      }
    } on DioException catch (e) {
      FocusScope.of(context).unfocus();
      setState(() {
        pageState = ButtonState.normal;
        state = 1;
      });
      var message = GetErrorMessage.getErrorMessage(e.response?.data['errors']);
      AppDialog.snackBar(text: message);
      dynamic errors = DioExceptions.fromDioError(e);
      if (errors != null) {
        if (errors.message == "No Internet") {
        } else {}
      }
    } on TimeoutException catch (e) {
      setState(() {
        pageState = ButtonState.normal;
        state = 1;
      });
      AppDialog.snackBar(text: "Terjadi kesalahan,silahkan coba lagi");
    }
  }

  @override
  Widget build(BuildContext   context) {
    print("dev name ${F.appFlavor?.name}");
    print("");
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    Widget textEmailLogin() {
      return Container(
        margin: const EdgeInsets.only(top: Constants.spacing6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Login dengan',
              style: TextStyle(
                  // fontSize: Constants.fontSizeSm,
                  color: Constants.gray),
            ),
            const SizedBox(
              width: 6,
            ),
            InkWell(
              onTap: () async {
                FocusScope.of(context).unfocus();

                bool signup = false;

                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => SignUpView(
                        mobileNumber: otpController.text,
                        onSuccess: () async {
                          signup = true;
                        })));

                if (signup) {
                  Navigator.of(context).pop();
                  if (widget.onSuccess != null) {
                    widget.onSuccess!();
                  }
                }
              },
              child: const Text(
                'Email',
                style: TextStyle(
                    fontFamily: Constants.primaryFontBold,
                    color: Constants.primaryColor),
              ),
            )
          ],
        ),
      );
    }

    Widget title() {
      return Container(
        margin: const EdgeInsets.only(bottom: Constants.spacing11),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Masuk',
              style: Constants.heading1,
            ),
            SizedBox(
              height: Constants.spacing2,
            ),
            Text(
              "Masukkan nomor hp anda dibawah untuk melanjutkan",
              style: Constants.textLg,
            ),
          ],
        ),
      );
    }

    Widget formLogin() {
      return Container(
        // margin: const EdgeInsets.symmetric(vertical: 50),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nomor Hp',
                  style: TextStyle(
                    color: Constants.gray,
                  ),
                ),
                const SizedBox(
                  height: Constants.spacing1,
                ),
                Container(
                  height: 65,
                  width: MediaQuery.of(context).size.width,
                  // ignore: prefer_const_constructors
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                      color: Constants.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Row(
                      children: [
                        const Text('+62', style: Constants.textLg),
                        const SizedBox(
                          width: Constants.spacing2,
                        ),
                        Expanded(
                          child: TextFormField(
                            key: const ValueKey('mobileNumber'),
                            controller: otpController,
                            onChanged: (value) => validate(),
                            decoration: const InputDecoration.collapsed(
                                hintText: 'Masukkan Nomor HP',
                                hintStyle: TextStyle(
                                    fontSize: Constants.fontSizeMd,
                                    color: Constants.gray)),
                            keyboardType: TextInputType.number,
                            style: Constants.textLg,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]')),
                              //To remove first '0'
                              FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                              //To remove first '94' or your country code
                              FilteringTextInputFormatter.deny(RegExp(r'^62+')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 20),
                  child: Button(
                    key: const ValueKey('loginButton'),
                    fontSize: Constants.fontSizeLg,
                    state: !valid ? ButtonState.disabled : pageState,
                    text: "Lanjut",
                    onPressed: state == 2
                        ? null
                        : !valid
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();
                                var mobileNumber = otpController.text;
                                requestOTP(
                                  context,
                                  mobileNumber,
                                );
                              },
                  ),
                ),
              ],
            ),
            // textEmailLogin(),
          ],
        ),
      );
    }

    Widget register() {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Center(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        FocusScope.of(context).unfocus();

                        bool signup = false;

                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => SignUpView(
                                mobileNumber: otpController.text,
                                onSuccess: () async {
                                  signup = true;
                                })));

                        if (signup) {
                          Navigator.of(context).pop();
                          if (widget.onSuccess != null) {
                            widget.onSuccess!();
                          }
                        }
                      },
                      child: Text(
                        'Daftar Baru',
                        key: const ValueKey('signUpButton'),
                        style:
                            TextStyle(color: Constants.primaryColor.shade400),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: Constants.spacing3),
            ),
            InkWell(
              onTap: () async {
                // FocusScope.of(context).unfocus();

                // bool signup = false;

                // await Navigator.of(context).push(MaterialPageRoute(
                //     builder: (_) => LoginWithEmail(onSuccess: () async {
                //           signup = true;
                //         })));

                // if (signup) {
                //   Navigator.of(context).pop();
                //   if (widget.onSuccess != null) {
                //     widget.onSuccess!();
                //   }
                // }
              },
              child:
             
               Container(
                key: const ValueKey('loginWithPassword'),
                child: Text(
                  'Gunakan Password',
                  style: TextStyle(color: Constants.primaryColor.shade400),
                ),
              )
            ),
             F.appFlavor?.name == "dev" ? 
            InkWell(
              onTap: () async {
                FocusScope.of(context).unfocus();
                await VerificationApi().deleteUser("081234567890");
              },
              child: Container(
                margin: const EdgeInsets.only(top: Constants.spacing4),
                key: const ValueKey('deleteUser'),
                child: Text(
                  'Delete User',
                  style: TextStyle(color: Constants.primaryColor.shade400),
                ),
              ),
            ): Container(),
            Container(
              margin: const EdgeInsets.symmetric(vertical: Constants.spacing3),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: Constants.spacing3),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Constants.gray.shade100,
        shadowColor: Colors.transparent,
        leading: Navigator.canPop(context) == true
            ? InkWell(
                onTap: () async {
                  _unfocus(context);
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Constants.black,
                  size: 26,
                ),
              )
            : Container(),
        title: const Text(""),
        centerTitle: true,
      ),
      body: SizedBox(
        child: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: Constants.spacing10),
            child: Column(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title(),
                        formLogin(),
                      ],
                    )),

                // divider(),
                // loginWithEmail(),
                register(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _unfocus(BuildContext context) => FocusScope.of(context).unfocus();
}
