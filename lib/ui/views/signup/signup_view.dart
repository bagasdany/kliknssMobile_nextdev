// ignore_for_file: must_be_immutable, avoid_unnecessary_containers

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/app_dialog.dart';
import 'package:kliknss77/ui/component/button.dart';
import 'package:kliknss77/ui/component/get_error_message.dart';
import 'package:kliknss77/ui/views/login/verification_view.dart';
import '../../component/dio_exceptions.dart';

class SignUpView extends StatefulWidget {
  int? id;
  String? mobileNumber;
  final Function? onSuccess;
  bool? isLogin;

  SignUpView(
      {Key? key, this.onSuccess, this.id, this.mobileNumber, this.isLogin})
      : super(key: key);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> with TickerProviderStateMixin {
  double secrollOffset = 0.0;
  TextEditingController namaController = TextEditingController();
  TextEditingController nohpController = TextEditingController();
  TextEditingController ktpController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController referralController = TextEditingController();
  double get scrollOffset => secrollOffset;
  final Dio _dio =DioService.getInstance();
  bool isValid = false;
  Map component = {};
  int state = 0;
  // String
  List kategoribrand = [];

  Map type = {};
  ButtonState buttonState = ButtonState.normal;

  void validate() {
    bool _isValid = widget.isLogin == false
        ? (namaController.text.isNotEmpty && nohpController.text.isNotEmpty)
        : true;

    setState(() {
      isValid = _isValid;
    });
  }

  void requestRegisterData(context) async {
    setState(() {
      state = 2;
      buttonState = ButtonState.loading;
    });
    try {
      final param = {
        "name": namaController.text,
        "mobileNumber": nohpController.text,
        "ktpNumber": ktpController.text,
        "email": emailController.text,
        "referralCode": referralController.text,
      };

      Response response = await _dio.post(Endpoint.registerUser, data: param);

      var custId = response.data['customerId'];
      var verificationCode = response.data['verificationCode'];

      bool verified = false;
      setState(() {
        state = 1;
        buttonState = ButtonState.normal;
      });

      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerifikasiView(
                  customerId: custId,
                  mobileNumber: nohpController.text,
                  onSuccess: () {
                    verified = true;
                  })));

      if (verified) {
        Navigator.of(context).pop();
        if (widget.onSuccess != null) {
          widget.onSuccess!();
        }
      }

      ModalRoute.withName('/');
    } on DioException catch (e) {
      var message = e.response == null
          ? "Silahkan cek data anda kembali"
          : GetErrorMessage.getErrorMessage(e.response?.data['errors']);
      AppDialog.snackBar(text: message);
      setState(() {
        state = 1;
        buttonState = ButtonState.normal;
      });
      dynamic errors = DioExceptions.fromDioError(e);
      if (errors != null) {
        if (errors.message == "No Internet") {
        } else {}
      }
    }
  }

  void updateData(context) async {
    setState(() {
      state = 2;
      buttonState = ButtonState.loading;
    });
    try {
      final param = {
        "name": namaController.text,
        "ktpNumber": ktpController.text,
        "email": emailController.text,
        "referralCode": referralController.text,
      };

      Response response = await _dio.post(Endpoint.updateUser, data: param);

      var custId = response.data['customerId'];
      var verificationCode = response.data['verificationCode'];

      bool verified = false;
      setState(() {
        state = 1;
        buttonState = ButtonState.normal;
      });

      if (widget.onSuccess != null) {
        Navigator.of(context).pop();
        widget.onSuccess!();
        AppDialog.snackBar(text: "Terima kasih sudah melengkapi profile");
      } else {
        Navigator.pop(context);
      }
    } on DioException catch (e) {
      var message = GetErrorMessage.getErrorMessage(e.response?.data['errors']);
      AppDialog.snackBar(text: message);
      setState(() {
        state = 1;
        buttonState = ButtonState.normal;
      });
      dynamic errors = DioExceptions.fromDioError(e);
      if (errors != null) {
        if (errors.message == "No Internet") {
        } else {}
      }
    }
  }

  bool changeColor = false;
  ScrollController? secrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    nohpController.text = widget.mobileNumber ?? '';
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    // _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildTitle() {
      return Column(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Text(
                          widget.isLogin == true
                              ? "Edit Profile"
                              : 'Pendaftaran',
                          style: Constants.heading1,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: Constants.spacing2),
                        child: const Text(
                          "Masukkan informasi dibawah ini.",
                          style: Constants.textLg,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget buildNamaLengkap() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nama Lengkap',
            style: TextStyle(
              color: Constants.gray,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: Constants.spacing1),
            padding: const EdgeInsets.all(
              Constants.spacing4,
            ),
            decoration: BoxDecoration(
              color: Constants.white,
              borderRadius: BorderRadius.circular(Constants.spacing4),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    key: const Key('namaLengkap'),
                    controller: namaController,
                    style: Constants.textLg,
                    onChanged: (value) {
                      validate();
                    },
                    decoration: InputDecoration.collapsed(
                      hintText: 'Nama Lengkap',
                      hintStyle: TextStyle(
                          fontSize: Constants.fontSizeMd,
                          color: Constants.gray.shade300),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget buildNomorHp() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: Constants.spacing4),
            child: const Text(
              'Nomor HP',
              style: TextStyle(
                color: Constants.gray,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: Constants.spacing1),
            padding: const EdgeInsets.all(Constants.spacing4),
            decoration: BoxDecoration(
              color: Constants.white,
              borderRadius: BorderRadius.circular(Constants.spacing4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('+62', style: Constants.textLg),
                const SizedBox(
                  width: Constants.spacing4,
                ),
                // Container(
                //   width: 5,
                //   color: CustomColor.backgroundGrayColor,
                // ),
                Expanded(
                  child: TextFormField(
                    key: const Key('noHp'),
                    controller: nohpController,
                    onChanged: (value) {
                      validate();
                    },
                    decoration: InputDecoration.collapsed(
                      hintText: 'Nomor HP',
                      hintStyle: TextStyle(
                        color: Constants.gray.shade300,
                        fontSize: Constants.fontSizeMd,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    style: Constants.textLg,
                    inputFormatters: [
                      // username == null
                      //     ?
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      // :
                      // FilteringTextInputFormatter
                      //     .allow(RegExp(
                      //         r'^ ?\d*')),
                      //To remove first '0'
                      // username == null
                      //     ?
                      FilteringTextInputFormatter.deny(RegExp(r'^0+')),

                      // : FilteringTextInputFormatter
                      //     .allow(RegExp(
                      //         '[a-zA-Z]')),
                      //To remove first '94' or your country code
                      FilteringTextInputFormatter.deny(RegExp(r'^62+')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget buildNomorKtp() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: Constants.spacing4),
                child: const Text(
                  'Nomor KTP ',
                  style: TextStyle(
                    color: Constants.gray,
                  ),
                ),
              ),
              widget.isLogin == true
                  ? Container()
                  : Container(
                      margin: const EdgeInsets.only(top: Constants.spacing4),
                      child: const Text(
                        '(Opsional)',
                        style: TextStyle(
                            color: Constants.gray,
                            fontSize: Constants.fontSizeXs),
                      ),
                    ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: Constants.spacing1),
            // ignore: prefer_const_constructors
            // padding: EdgeInsets.all(Constants.spacing4),
            decoration: BoxDecoration(
              color: Constants.white,
              borderRadius: BorderRadius.circular(Constants.spacing4),
            ),
            child: Center(
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLength: 16,
                      controller: ktpController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          counterText: '',
                          hintText: 'Nomor KTP',
                          contentPadding:
                              const EdgeInsets.all(Constants.spacing4),
                          hintStyle: TextStyle(
                              color: Constants.gray.shade300,
                              fontSize: Constants.fontSizeMd),
                          border: const OutlineInputBorder(),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Constants.white),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Constants.spacing3))),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Constants.white),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Constants.spacing3)))),
                      // InputDecoration(
                      //   counterText: "",
                      //   hintText: 'Nomor KTP',
                      //   hintStyle: TextStyle(
                      //     color: Constants.gray.shade300,
                      //     fontSize: Constants.fontSizeMd,
                      //   ),
                      // ),
                      style: Constants.textLg,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: Constants.spacing1),
            child: Text(
              'Jika pelanggan NSS, Anda dapat menghubungkan histori sebelumnya dengan memasukan nomor KTP ',
              style: TextStyle(
                  color: Constants.gray.shade400,
                  fontSize: Constants.fontSizeSm),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          )
        ],
      );
    }

    Widget buildEmail() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: Constants.spacing4),
                child: const Text(
                  'Email ',
                  style: TextStyle(
                    color: Constants.gray,
                    fontSize: Constants.fontSizeMd,
                  ),
                ),
              ),
              widget.isLogin == true
                  ? Container()
                  : Container(
                      margin: const EdgeInsets.only(top: Constants.spacing4),
                      child: const Text(
                        '(Opsional)',
                        style: TextStyle(
                            color: Constants.gray,
                            fontSize: Constants.fontSizeXs),
                      ),
                    ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: Constants.spacing1),
            // ignore: prefer_const_constructors
            padding: EdgeInsets.all(Constants.spacing4),
            decoration: BoxDecoration(
              color: Constants.white,
              borderRadius: BorderRadius.circular(Constants.spacing4),
            ),
            child: Center(
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: emailController,
                      onChanged: (value) {},
                      decoration: InputDecoration.collapsed(
                        hintText: 'Email',
                        hintStyle: TextStyle(
                            color: Constants.gray.shade300,
                            fontSize: Constants.fontSizeMd),
                      ),
                      style: Constants.textLg,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    Widget buildReferral() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: Constants.spacing4),
                child: const Text(
                  'Kode Referral ',
                  style: TextStyle(
                    color: Constants.gray,
                  ),
                ),
              ),
              widget.isLogin == true
                  ? Container()
                  : Container(
                      margin: const EdgeInsets.only(top: Constants.spacing4),
                      child: const Text(
                        '(Opsional)',
                        style: TextStyle(
                            color: Constants.gray,
                            fontSize: Constants.fontSizeXs),
                      ),
                    ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(
                top: Constants.spacing1, bottom: Constants.spacing6),
            // ignore: prefer_const_constructors
            padding: EdgeInsets.all(Constants.spacing4),
            decoration: BoxDecoration(
              color: Constants.white,
              borderRadius: BorderRadius.circular(Constants.spacing4),
            ),
            child: Center(
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: referralController,
                      onChanged: (value) {},
                      decoration: InputDecoration.collapsed(
                        hintText: 'Kode Referral',
                        hintStyle: TextStyle(
                            fontSize: Constants.fontSizeMd,
                            color: Constants.gray.shade300),
                      ),
                      style: Constants.textLg,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    Widget buildSignuP() {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: Constants.spacing2),
                  child: Button(
                    key: const ValueKey("signUpButtonPendaftaran"),
                    text: widget.isLogin == true ? "Update Data" : "Daftar",
                    state: !isValid ? ButtonState.disabled : buttonState,
                    fontSize: Constants.fontSizeLg,
                    onPressed: state == 2
                        ? null
                        : isValid
                            ? () {
                                FocusScope.of(context).unfocus();
                                widget.isLogin == true
                                    ? updateData(context)
                                    : requestRegisterData(context);
                              }
                            : null,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    void showDialog() {
      double maxWidth = MediaQuery.of(context).size.width * .85;
      double maxHeight = MediaQuery.of(context).size.height * .7;

      AppDialog.confirm(
        keyOnCancel: const Key("cancelButton"),
        keyOnConfirm: const Key("confirmButton"),
          title: "Profilmu belum lengkap nih,",
          description:
              "Yakin nih gamau lengkapi profil kamu dulu ? Yuk segera lengkapi untuk memperoleh pengalaman terbaik di aplikasi klikNSS",
          onConfirm: () {
            // Navigator.pop(context);
          },
          onCancel: () {
            if (widget.onSuccess != null) {
              Navigator.of(context).pop();
              widget.onSuccess!();
            } else {
              Navigator.pop(context);
            }
          },

          confirmText: "Lanjutkan",
          cancelText: "Nanti Aja");
    }

    Future<bool> onWillPop() {
      showDialog();
      return Future.value(false);
    }

    return WillPopScope(
      onWillPop: widget.isLogin == true ? onWillPop : null,
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              widget.isLogin == true ? showDialog() : Navigator.pop(context);
            },
            child: const Icon(
              
              Icons.arrow_back,
              key: ValueKey("backButton"),
              color: Constants.black,
            ),
          ),
          automaticallyImplyLeading: true,
          shadowColor: Colors.transparent,
          backgroundColor: Constants.gray.shade100,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Constants.gray.shade100,
            padding: const EdgeInsets.symmetric(
                horizontal: Constants.spacing8, vertical: Constants.spacing5),
            child: Column(
              children: [
                buildTitle(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: Constants.spacing8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildNamaLengkap(),
                      widget.isLogin == true ? Container() : buildNomorHp(),
                      buildNomorKtp(),
                      buildEmail(),
                      buildReferral(),
                      buildSignuP(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
