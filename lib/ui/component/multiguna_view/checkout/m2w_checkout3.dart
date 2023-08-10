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
import 'package:kliknss77/ui/views/ocr/ktp_card.dart';
import 'm2w_checkout4.dart';

class M2WCheckout3 extends StatefulWidget {
  Map order = {};
  Map? kelurahan;

  M2WCheckout3(this.order, {Key? key}) : super(key: key);

  @override
  State<M2WCheckout3> createState() => _M2WCheckout3State();
}

class _M2WCheckout3State extends State<M2WCheckout3> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  Map invalids = {};
  final TextEditingController _text2 = TextEditingController();
  final TextEditingController _text3 = TextEditingController();
  final TextEditingController _text4 = TextEditingController();
  final TextEditingController _text5 = TextEditingController();

  final Dio _dio = DioService.getInstance();

  List<int>? customerRefImageBytes;
  RegExp ktpNumberRegex = RegExp(r'^.{16}$');
  int _inputPhase = 0;
  Map _invalids = {};
  bool _valid = false;
  bool expand = false;
  int _state = 1;

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
      _text2.text = widget.order['refKtpNumber'] ?? '';
      _text3.text = widget.order['refAddress'] ?? '';
      _text4.text = widget.order['refRt'] ?? '';
      _text5.text = widget.order['refRw'] ?? '';

      validate();

      AppLog().logScreenView('M2W Checkout 3');
    });
  }

  FormData getFormData() {
    List<String> keys = [
      'id',
      'refKtpNumber',
      'refAddress',
      'refProvinceId',
      'refCityId',
      'refKecamatanId',
      'refKelurahanId',
      'refProvinceName',
      'refCityName',
      'refKecamatanName',
      'refKelurahanName',
      'refPostalCode',
      'refRt',
      'refRw',
    ];
    Map<String, dynamic> formMap = {};
    keys.forEach((key) {
      formMap[key] = widget.order[key];
    });
    FormData form = FormData.fromMap(formMap);
    if (customerRefImageBytes != null) {
      MultipartFile customerRefImage = MultipartFile.fromBytes(
          customerRefImageBytes!,
          contentType: MediaType('image', 'jpg'),
          filename: 'Image-${DateTime.now().millisecondsSinceEpoch}.jpg');
      form.files.add(MapEntry('customerRefImage', customerRefImage));
    }

    return form;
  }

  Future<void> save(BuildContext context) async {
    setState(() {
      _state = 2;
    });
    try {
      FormData data = getFormData();
      final response = await _dio.post(Endpoint.checkout, data: data);
      setState(() {
        _state = 1;
      });
      final order = response.data['order'];

      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        FocusScope.of(context).unfocus();
        return M2WCheckout4(order);
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
    invalids['customerRefImage'] =
        customerRefImageBytes == null ? 'Foto KTP penjamin diperlukan' : null;

    invalids['refKtpNumber'] = (widget.order['refKtpNumber'] ?? '').isEmpty
        ? 'Nomor KTP belum diisi'
        : (!ktpNumberRegex.hasMatch(widget.order['refKtpNumber'] ?? '')
            ? 'Masukkan nomor KTP dengan benar'
            : null);
    // if (_inputPhase >= 1) {
    //   _invalids['refKtpNumber'] = invalids['refKtpNumber'];
    // }

    invalids['refAddress'] = (widget.order['refAddress'] ?? '').length < 5
        ? 'Harap isi alamat tempat tinggal'
        : null;
    // if (_inputPhase >= 2) {
    //   _invalids['refAddress'] = invalids['refAddress'];
    // }refKelurahanId

    invalids['refKelurahanId'] = widget.order['refKelurahanId'] == null
        ? 'Harap isi Kecamatan/Kota'
        : null;

    invalids['refRt'] =
        (widget.order['refRt'] ?? '').isEmpty ? 'RT belum diisi' : null;
    // if (_inputPhase >= 4) {
    //   _invalids['refRt'] = invalids['refRt'];
    // }

    invalids['refRw'] =
        (widget.order['refRw'] ?? '').isEmpty ? 'RW belum diisi' : null;
    if (_inputPhase >= 5) {
      _invalids['refRw'] = invalids['refRw'];
    }

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
                Text(_invalids['customerRefImage'] ?? 'Foto KTP Penjamin',
                    style: TextStyle(
                        fontSize: Constants.fontSizeSm,
                        color: _invalids['customerRefImage'] != null
                            ? Constants.primaryColor
                            : Constants.gray)),
                const SizedBox(height: Constants.spacing1),
                KTPCard(
                  onChanged: (List<int> bytes, String? ktpNumber) async {
                    customerRefImageBytes = bytes;
                    if (ktpNumber != null && ktpNumber != "") {
                      _text2.text = ktpNumber;
                    }
                    validate();
                  },
                ),
                const SizedBox(height: Constants.spacing4),
                Text(_invalids['refKtpNumber'] ?? 'Nomor KTP',
                    style: TextStyle(
                        fontSize: Constants.fontSizeSm,
                        color: _invalids['refKtpNumber'] != null
                            ? Constants.primaryColor
                            : Constants.gray)),
                const SizedBox(height: Constants.spacing1),
                Focus(
                  onFocusChange: (hasFocus) {
                    if (hasFocus && _inputPhase < 1) {
                      _inputPhase = 1;
                    }
                  },
                  child: TextField(
                    controller: _text2,
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    decoration: InputDecoration(
                        counterText: '',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: Constants.spacing3),
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.gray.shade200),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(Constants.spacing3))),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.gray.shade200),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(Constants.spacing3)))),
                    onChanged: (text) {
                      widget.order['refKtpNumber'] = text;
                      validate();
                    },
                  ),
                ),
                const SizedBox(height: Constants.spacing4),
                Text(_invalids['refAddress'] ?? 'Alamat tempat tinggal',
                    style: TextStyle(
                        fontSize: Constants.fontSizeSm,
                        color: _invalids['refAddress'] != null
                            ? Constants.primaryColor
                            : Constants.gray)),
                const SizedBox(height: Constants.spacing1),
                Focus(
                    onFocusChange: (hasFocus) {
                      if (hasFocus && _inputPhase < 2) {
                        _inputPhase = 2;
                      }
                    },
                    child: TextField(
                      controller: _text3,
                      minLines: 6,
                      maxLines: 12,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: Constants.spacing3,
                              vertical: Constants.spacing3),
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Constants.gray.shade200),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(Constants.spacing3))),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Constants.gray.shade200),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(Constants.spacing3)))),
                      onChanged: (text) {
                        widget.order['refAddress'] = _text3.text;
                        validate();
                      },
                    )),
                const SizedBox(height: Constants.spacing4),
                Text(_invalids['refKelurahanId'] ?? 'Kota/Kecamatan',
                    style: TextStyle(
                        fontSize: Constants.fontSizeSm,
                        color: _invalids['refKelurahanId'] != null
                            ? Constants.primaryColor
                            : Constants.gray)),
                const SizedBox(height: Constants.spacing1),
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    selectKelurahan(context);
                    validate();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(Constants.spacing3)),
                        border: Border.all(color: Constants.gray.shade200)),
                    padding: const EdgeInsets.all(Constants.spacing3),
                    alignment: widget.kelurahan == null
                        ? Alignment.center
                        : Alignment.centerLeft,
                    child: widget.kelurahan == null
                        ? const Text('Pilih Kota/Kecamatan...',
                            style: TextStyle(color: Constants.gray))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.kelurahan!['alias']),
                              const SizedBox(height: Constants.spacing1),
                              Text(
                                  "${widget.kelurahan!['kecamatan']['alias']} - ${widget.kelurahan!['kecamatan']['city']['alias']} ${widget.kelurahan!['postalCode']}",
                                  style: const TextStyle(
                                      fontSize: Constants.fontSizeSm)),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: Constants.spacing4),
                Row(
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_invalids['refRt'] ?? 'RT',
                            style: TextStyle(
                                fontSize: Constants.fontSizeSm,
                                color: _invalids['refRt'] != null
                                    ? Constants.primaryColor
                                    : Constants.gray)),
                        const SizedBox(height: Constants.spacing1),
                        Focus(
                            onFocusChange: (hasFocus) {
                              if (hasFocus && _inputPhase < 4) {
                                _inputPhase = 4;
                              }
                            },
                            child: TextField(
                              controller: _text4,
                              maxLength: 3,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: Constants.spacing3),
                                  border: const OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Constants.gray.shade200),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(Constants.spacing3))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Constants.gray.shade200),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(
                                              Constants.spacing3)))),
                              onChanged: (text) {
                                widget.order['refRt'] = _text4.text;
                                validate();
                              },
                            )),
                      ],
                    )),
                    const SizedBox(width: Constants.spacing4),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_invalids['refRw'] ?? 'RW',
                            style: TextStyle(
                                fontSize: Constants.fontSizeSm,
                                color: _invalids['refRw'] != null
                                    ? Constants.primaryColor
                                    : Constants.gray)),
                        const SizedBox(height: Constants.spacing1),
                        Focus(
                          onFocusChange: (hasFocus) {
                            if (hasFocus && _inputPhase < 5) {
                              _inputPhase = 5;
                            }
                          },
                          child: TextField(
                            controller: _text5,
                            maxLength: 3,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                counterText: '',
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: Constants.spacing3),
                                border: const OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Constants.gray.shade200),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(Constants.spacing3))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Constants.gray.shade200),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(Constants.spacing3)))),
                            onChanged: (text) {
                              widget.order['refRw'] = _text5.text;
                              validate();
                            },
                          ),
                        ),
                      ],
                    ))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> selectKelurahan(BuildContext context) async {
    final kelurahan = await AppDialog.openKelurahanSelector();

    if (kelurahan != null) {
      setState(() {
        widget.kelurahan = kelurahan;
        widget.order['refKelurahanId'] = kelurahan['id'];
        widget.order['refKecamatanId'] = kelurahan['kecamatan']['id'];
        widget.order['refCityId'] = kelurahan['kecamatan']['city']['id'];
        widget.order['refProvinceId'] =
            kelurahan['kecamatan']['city']['province']['id'];
        widget.order['refPostalCode'] = kelurahan['postalCode'];
        widget.order['refKelurahanName'] = kelurahan['alias'];
        widget.order['refKecamatanName'] = kelurahan['kecamatan']['alias'];
        widget.order['refCityName'] = kelurahan['kecamatan']['city']['alias'];
        widget.order['refProvinceName'] =
            kelurahan['kecamatan']['city']['province']['alias'];
      });
      validate();
    }
    validate();
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
          title: const Text('Lengkapi Berkas'),
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
                      buildTabItem(3, 'Penjamin', active: true),
                      buildTabItem(4, 'Kirim', trailing: false),
                      const SizedBox(width: Constants.spacing6)
                    ],
                  ),
                ),
              ))),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
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
                        if (_valid) {
                          save(context);
                        } else {
                          validate();
                          setState(() {
                            _invalids = invalids;
                            if (_text4.text.isEmpty ||
                                widget.order['deliveryKelurahanId'] == null ||
                                _text5.text.isEmpty ||
                                _text3.text.isEmpty) {
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn,
                              );
                            } else {
                              _scrollController.animateTo(
                                0.0,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn,
                              );
                            }
                          });
                        }
                      },
                    )
                  ],
                ),
              ),
              expand == true
                  ? const SizedBox(height: 300)
                  : SizedBox(
                      height: 50,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
