import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:kliknss77/application/app/app_log.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/app_dialog.dart';
import 'package:kliknss77/ui/component/button.dart';
import 'package:kliknss77/ui/component/get_error_message.dart';
import 'package:kliknss77/ui/component/multiguna_view/checkout/m2w_checkout3.dart';
import 'package:kliknss77/ui/views/ocr/stnk_card.dart';

class M2WCheckout2 extends StatefulWidget {
  Map order = {};
  Map? kelurahan;

  M2WCheckout2(this.order, {Key? key}) : super(key: key);

  @override
  State<M2WCheckout2> createState() => _M2WCheckout2State();
}

class _M2WCheckout2State extends State<M2WCheckout2> {
  final Dio _dio = DioService.getInstance();

  Map invalids = {};

  List<Map>? kelurahans;
  List<int>? stnkImageBytes;
  List<int>? stnkImage2Bytes;

  Map _invalids = {};
  bool _valid = false;
  int _state = 1;
  bool expand = false;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      validate();

      AppLog().logScreenView('M2W Checkout 2');
    });
  }

  FormData getFormData() {
    List<String> keys = ['id'];
    Map<String, dynamic> formMap = {};
    keys.forEach((key) {
      formMap[key] = widget.order[key];
    });
    FormData form = FormData.fromMap(formMap);

    if (stnkImageBytes != null) {
      MultipartFile stnkImage = MultipartFile.fromBytes(stnkImageBytes!,
          contentType: MediaType('image', 'jpg'),
          filename: 'Image-${DateTime.now().millisecondsSinceEpoch}.jpg');
      form.files.add(MapEntry('stnkImage', stnkImage));
    }

    if (stnkImage2Bytes != null) {
      MultipartFile stnkImage2 = MultipartFile.fromBytes(stnkImage2Bytes!,
          contentType: MediaType('image', 'jpg'),
          filename: 'Image-${DateTime.now().millisecondsSinceEpoch}.jpg');
      form.files.add(MapEntry('stnkImage2', stnkImage2));
    }

    return form;
  }

  Future<void> save(BuildContext context) async {
    setState(() {
      _state = 2;
    });
    try {
      FormData data = getFormData();
      final response = await _dio
          .post(Endpoint.checkout, data: data)
          .timeout(const Duration(seconds: 15));
      setState(() {
        _state = 1;
      });
      final order = response.data['order'];

      FocusScope.of(context).unfocus();

      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        FocusScope.of(context).unfocus();
        return M2WCheckout3(order);
      }));
    } on DioException catch (e) {
      String? message =
          GetErrorMessage.getErrorMessage(e.response?.data['errors'] ?? "");
      AppDialog.snackBar(text: message);
      setState(() {
        _state = 1;
      });
    } on TimeoutException catch (e) {
      AppDialog.snackBar(text: "Terjadi kesalahan, silahkan coba lagi");
      setState(() {
        _state = 1;
      });
    }
  }

  void validate() {
    invalids['stnkImage'] =
        stnkImageBytes == null ? 'Foto STNK diperlukan' : null;

    invalids['stnkImage2'] =
        stnkImage2Bytes == null ? 'Foto STNK bagian belakang diperlukan' : null;

    invalids.removeWhere((key, value) => value == null);

    setState(() {
      _valid = invalids.isEmpty;
      _invalids = _invalids;
    });
  }

  Widget buildForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Constants.spacing4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(Constants.spacing4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(_invalids['stnkImage'] ?? 'Foto STNK bagian depan',
                    style: TextStyle(
                        fontSize: Constants.fontSizeSm,
                        color: _invalids['stnkImage'] != null
                            ? Constants.primaryColor
                            : Constants.gray)),
                const SizedBox(height: Constants.spacing1),
                StnkCard(
                  onChanged: (List<int> bytes) {
                    setState(() {
                      stnkImageBytes = bytes;
                    });
                    validate();
                  },
                ),
                const SizedBox(height: Constants.spacing4),
                Text(_invalids['stnkImage2'] ?? 'Foto STNK bagian belakang',
                    style: TextStyle(
                        fontSize: Constants.fontSizeSm,
                        color: _invalids['stnkImage2'] != null
                            ? Constants.primaryColor
                            : Constants.gray)),
                const SizedBox(height: Constants.spacing1),
                StnkCard(
                  onChanged: (List<int> bytes) {
                    setState(() {
                      stnkImage2Bytes = bytes;
                    });
                    validate();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildTabItem(number, text, {active= false, trailing= true}) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 21,
            height: 21,
            decoration: BoxDecoration(
                color:
                    active ? Constants.primaryColor : Constants.gray.shade300,
                borderRadius: const BorderRadius.all(Radius.circular(21))),
            alignment: Alignment.center,
            child: Text('${number}',
                style: const TextStyle(
                    color: Colors.white, fontSize: Constants.fontSizeSm)),
          ),
          const SizedBox(width: Constants.spacing1),
          Text(text,
              style: TextStyle(
                  fontSize: Constants.fontSizeSm,
                  color: active ? Constants.primaryColor : Constants.gray)),
          const SizedBox(width: Constants.spacing1),
          trailing
              ? Container(
                  height: 3,
                  width: 30,
                  color:
                      active ? Constants.primaryColor : Constants.gray.shade300,
                )
              : Container(),
          const SizedBox(width: Constants.spacing1)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Foto STNK'),
          titleSpacing: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(32),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: Constants.spacing2),
                  child: Row(
                    children: [
                      const SizedBox(width: Constants.spacing6),
                      buildTabItem(1, 'Data Peminjam', active: true),
                      buildTabItem(2, 'STNK', active: true),
                      buildTabItem(3, 'Penjamin'),
                      buildTabItem(4, 'Kirim', trailing: false),
                      const SizedBox(width: Constants.spacing6)
                    ],
                  ),
                ),
              ))),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildForm(context),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: Constants.spacing4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Button(
                    text: 'Lanjut',
                    fontSize: Constants.fontSizeLg,
                    state: !_valid
                        ? ButtonState.disabled
                        : (_state == 2
                            ? ButtonState.loading
                            : ButtonState.normal),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (_valid) {
                        save(context);
                      } else {
                        validate();
                        setState(() {
                          _invalids = invalids;
                        });
                      }
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: Constants.spacing8),
            const SizedBox(height: Constants.spacing8)
          ],
        ),
      ),
    );
  }
}
