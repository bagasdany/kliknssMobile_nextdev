import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kliknss77/application/app/app_log.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/application/services/dummy/home_json.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/infrastructure/apis/misc_api.dart';
import 'package:kliknss77/ui/component/app_dialog.dart';
import 'package:kliknss77/ui/component/button_agent.dart';
import 'package:kliknss77/ui/component/get_error_message.dart';
import 'package:kliknss77/ui/views/ocr/ktp_card.dart';


class HMCAgentCheckout1 extends StatefulWidget {
  Map<String, dynamic> order = {};
  Map? kelurahan;

  HMCAgentCheckout1(this.order, {Key? key}) : super(key: key);

  @override
  State<HMCAgentCheckout1> createState() => _HMCAgentCheckout1State();
}

class _HMCAgentCheckout1State extends State<HMCAgentCheckout1> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final TextEditingController _text1 = TextEditingController();
  final TextEditingController _text2 = TextEditingController();
  final TextEditingController _text3 = TextEditingController();
  final TextEditingController _text4 = TextEditingController();
  final TextEditingController _text5 = TextEditingController();
  final TextEditingController noHp = TextEditingController();
  final TextEditingController _text7 = TextEditingController();

  final Dio _dio = DioService.getInstance();
  List<int>? ktpImageBytes;
  RegExp ktpNumberRegex = RegExp(r'^.{16}$');
  int _inputPhase = 0;
  Map _invalids = {};
  bool _valid = false;
  int _state = 1;

  Map invalids = {};

  List<Map>? listhomeType;
  String? homeOwnership, homeType, codeOwnership, codehomeType;

  List<Map>? listPekerjaan;
  String? pekerjaan;
  dynamic kodePekerjaan;
  dynamic firstKtp;

  List<Map>? listLivingDuration;
  String? livingDuration, livingDurationUnit, livingDurationUnitDescription;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    dynamic listPekerjaans = (MiscApi().getOccupation().then((value) {
      setState(() {
        listPekerjaan = value;
      });
    }));
    super.initState();

    _text1.text = widget.order['customerName'] ?? '';
    _text7.text = widget.order['customerName'] ?? '';
    noHp.text = widget.order['customerPhone'] ?? '';
    pekerjaan = widget.order['customerOccupation'] ?? '';
    _text2.text = widget.order['customerKtpNumber'] ?? '';
    firstKtp = widget.order['customerKtpNumber'] ?? '';
    _text3.text = widget.order['deliveryAddress'] ?? '';
    _text4.text = widget.order['deliveryRt'] ?? '';
    _text5.text = widget.order['deliveryRw'] ?? '';
    validate();
    AppLog().logScreenView('Pengajuan Agen HMC (Form 1)');
  }

  FormData getFormData() {
    List<String> keys = [
      'id',
      'customerName',
      'customerKtpNumber',
      'deliveryProvinceId',
      'deliveryCityId',
      'deliveryKecamatanId',
      'deliveryKelurahanId',
      'deliveryPostalCode',
      'deliveryRt',
      'deliveryRw',
    ];
    Map<String, dynamic> formMap = {};
    keys.forEach((key) {
      formMap[key] = widget.order[key];
    });
    FormData form = FormData.fromMap(formMap);

    if (ktpImageBytes != null) {
      MultipartFile ktpImage = MultipartFile.fromBytes(ktpImageBytes!,
          contentType: MediaType('image', 'jpg'),
          filename: 'Image-${DateTime.now().millisecondsSinceEpoch}.jpg');
      form.files.add(MapEntry('customerKtpImage', ktpImage));
    }

    return form;
  }

  Future<void> save(BuildContext context) async {
    setState(() {
      _state = 2;
    });

    FormData data = getFormData();
    try {
      final response = await _dio.post(Endpoint.checkout, data: data);
      final order = response.data['order'];
      setState(() {
        _state = 1;
      });
      
      // Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      //   FocusScope.of(context).unfocus();
      //   return HMCAgentCheckout2(order);
      // }));
    } on DioException catch (e) {
      String? message =
          GetErrorMessage.getErrorMessage(e.response?.data['errors'] ?? "");
      AppDialog.snackBar(text: message);
      setState(() {
        _state = 1;
      });
    }

    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void validate() {
    invalids['customerKtpImage'] =
        ktpImageBytes == null ? 'Foto KTP diperlukan' : null;

    invalids['customerName'] = (widget.order['customerName'] ?? '').isEmpty
        ? 'Nama belum diisi'
        : null;

    // invalids['customerOccupation'] =
    //     (widget.order['customerOccupation'] ?? '').isEmpty
    //         ? 'Pekerjaan belum diisi'
    //         : null;

    // if (_inputPhase >= 1) {
    //   _invalids['customerName'] = invalids['customerName'];
    // }

    invalids['customerKtpNumber'] =
        (widget.order['customerKtpNumber'] ?? '').isEmpty
            ? 'Nomor KTP belum diisi'
            : (!ktpNumberRegex.hasMatch(widget.order['customerKtpNumber'] ?? '')
                ? 'Masukkan nomor KTP dengan benar'
                : null);

    // if (_inputPhase >= 2) {
    //   _invalids['customerKtpNumber'] = invalids['customerKtpNumber'];
    // }

    // invalids['deliveryAddress'] =
    //     (widget.order['deliveryAddress'] ?? '').length < 5
    //         ? 'Harap isi alamat tempat tinggal'
    //         : null;

    invalids['deliveryKelurahanId'] =
        widget.order['deliveryKelurahanId'] == null
            ? 'Harap isi Kecamatan/Kota'
            : null;

    // if (_inputPhase >= 3) {
    //   _invalids['deliveryAddress'] = invalids['deliveryAddress'];
    // }

    invalids['deliveryRt'] =
        (widget.order['deliveryRt'] ?? '').isEmpty ? 'RT belum diisi' : null;
    // if (_inputPhase >= 5) {
    //   _invalids['deliveryRt'] = invalids['deliveryRt'];
    // }

    invalids['deliveryRw'] =
        (widget.order['deliveryRw'] ?? '').isEmpty ? 'RW belum diisi' : null;
    // if (_inputPhase >= 6) {
    //   _invalids['deliveryRw'] = invalids['deliveryRw'];
    // }

    invalids.removeWhere((key, value) => value == null);

    setState(() {
      _valid = invalids.isEmpty;
      _invalids = _invalids;
    });
  }

  Widget buildOccupation(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          FocusScope.of(context).unfocus();
          String? listPekerjaans = await AppDialog.showTextSelector(
              context,
              (listPekerjaan as List ?? [])
                  .map((item) => item['text'] as String)
                  .toList(),
              title: 'Pilih Pekerjaan');

          if (listPekerjaans == "" || listPekerjaans == null) {
            setState(() {
              pekerjaan = "";
            });
          } else {
            setState(() {
              pekerjaan = listPekerjaans;
              dynamic listkodePekerjaan = listPekerjaan
                  ?.where((e) => e['text'] == listPekerjaans)
                  .toList();
              kodePekerjaan = listkodePekerjaan[0]['value'];
              widget.order['customerOccupation'] = kodePekerjaan;
            });
          }

          validate();

          FocusScope.of(context).unfocus();
        },
        child: Container(
            padding: const EdgeInsets.all(Constants.spacing2),
            decoration: BoxDecoration(
              border: Border.all(color: Constants.gray.shade200),
              borderRadius:
                  const BorderRadius.all(Radius.circular(Constants.spacing3)),
              color: Constants.white,
            ),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: Constants.spacing2),
                  child: Text(
                    pekerjaan == null || pekerjaan == ""
                        ? 'Pilih Pekerjaan'
                        : pekerjaan ?? "",
                    style: TextStyle(
                        color: pekerjaan == null || pekerjaan == ""
                            ? Constants.gray
                            : Constants.black),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
                SvgPicture.asset('assets/svg/chevron_down.svg',
                    width: 21, height: 21, color: Constants.gray)
              ],
            )));
  }

  Widget buildLivingDuration(BuildContext context) {
    return GestureDetector(
        //       {"homeLivingDurationUnit": "m", "homeLivingDescription": "Bulan"},
        // {
        //   "homeLivingDurationUnit": "y",
        //   "homeLivingDescription": "Tahun",
        // },
        onTap: () async {
          FocusScope.of(context).unfocus();
          String? listDuration = await AppDialog.showTextSelector(
              context,
              (ResponseHomeType().livingDuration as List)
                  .map((item) => item['homeLivingDescription'] as String)
                  .toList(),
              title: 'Pilih Durasi Waktu');

          if (listDuration == "" || listDuration == null) {
            setState(() {
              livingDuration = "";
            });
          } else {
            setState(() {
              // kalau mau pakai dicek lagi
              livingDurationUnitDescription = listDuration;
              dynamic listlivingDuration = ResponseHomeType()
                  .livingDuration
                  .where((e) => e['homeLivingDescription'] == listDuration)
                  .toList();
              livingDurationUnit =
                  listlivingDuration[0]['homeLivingDurationUnit'];
              widget.order['homeLivingDurationUnit'] = livingDurationUnit;
            });
          }
          validate();
        },
        child: Container(
            padding: const EdgeInsets.all(Constants.spacing2),
            decoration: BoxDecoration(
              border: Border.all(color: Constants.gray.shade200),
              borderRadius:
                  const BorderRadius.all(Radius.circular(Constants.spacing3)),
              color: Constants.white,
            ),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: Constants.spacing2),
                  child: Text(
                    livingDurationUnitDescription == null ||
                            livingDurationUnitDescription == ""
                        ? 'Pilih Durasi'
                        : livingDurationUnitDescription ?? "",
                    style: TextStyle(
                        color: livingDurationUnitDescription == null ||
                                livingDurationUnitDescription == ""
                            ? Constants.gray
                            : Constants.black),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
                SvgPicture.asset('assets/svg/chevron_down.svg',
                    width: 21, height: 21, color: Constants.gray)
              ],
            )));
  }

  Widget buildhomeTipe(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          FocusScope.of(context).unfocus();
          String? StringHomeTipe = await AppDialog.showTextSelector(
              context,
              (ResponseHomeType().response as List)
                  .map((item) => item['homeTypeDescription'] as String)
                  .toList(),
              title: 'Pilih Tempat Tinggal');
          if (StringHomeTipe == "" || StringHomeTipe == null) {
            setState(() {
              homeType = "";
              // listPekerjaan[0];
            });
          } else {
            setState(() {
              homeType = StringHomeTipe;
              listhomeType = ResponseHomeType()
                  .response
                  ?.where((e) => e['homeTypeDescription'] == StringHomeTipe)
                  .toList();
              codehomeType = listhomeType?[0]['homeType'] ?? "DS";
              widget.order['homeType'] = codehomeType;
            });
          }
          validate();
        },
        child: Container(
            padding: const EdgeInsets.all(Constants.spacing2),
            decoration: BoxDecoration(
              border: Border.all(color: Constants.gray.shade200),
              borderRadius:
                  const BorderRadius.all(Radius.circular(Constants.spacing3)),
              color: Constants.white,
            ),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: Constants.spacing2),
                  child: Text(
                    homeType == null || homeType == ""
                        ? 'Pilih Tipe Alamat'
                        : homeType ?? "",
                    style: TextStyle(
                        color: homeType == null || homeType == ""
                            ? Constants.gray
                            : Constants.black),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
                SvgPicture.asset('assets/svg/chevron_down.svg',
                    width: 21, height: 21, color: Constants.gray)
              ],
            )));
  }

  Widget buildhomeOwnership(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          FocusScope.of(context).unfocus();
          String? StringHomeOwnership = await AppDialog.showTextSelector(
              context,
              (listhomeType?[0]['homeOwnership'] ?? [] as List)
                  .map((item) => item['description'] as String)
                  .toList(),
              title: 'Pilih Kepemilikan');
          if (StringHomeOwnership == "" || StringHomeOwnership == null) {
            setState(() {
              homeOwnership = "";
              // listPekerjaan[0];
            });
          } else {
            setState(() {
              homeOwnership = StringHomeOwnership;
              dynamic listhomeOwnership = listhomeType?[0]['homeOwnership']
                  ?.where((e) => e['description'] == StringHomeOwnership)
                  .toList();
              codeOwnership = listhomeOwnership?[0]['code'];
              widget.order['homeOwnership'] = codeOwnership;
            });
          }

          validate();
        },
        child: Container(
            padding: const EdgeInsets.all(Constants.spacing2),
            decoration: BoxDecoration(
              border: Border.all(color: Constants.gray.shade200),
              borderRadius:
                  const BorderRadius.all(Radius.circular(Constants.spacing3)),
              color: Constants.white,
            ),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: Constants.spacing2),
                  child: Text(
                    homeOwnership == null || homeOwnership == ""
                        ? 'Pilih Jenis Kepemilikan'
                        : homeOwnership ?? "",
                    style: TextStyle(
                        color: homeOwnership == null || homeOwnership == ""
                            ? Constants.gray
                            : Constants.black),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
                SvgPicture.asset('assets/svg/chevron_down.svg',
                    width: 21, height: 21, color: Constants.gray)
              ],
            )));
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
                Text(_invalids['customerKtpImage'] ?? 'Foto KTP',
                    style: TextStyle(
                        fontSize: Constants.fontSizeSm,
                        color: _invalids['customerKtpImage'] != null
                            ? Constants.donker.shade500
                            : Constants.gray)),
                const SizedBox(height: Constants.spacing1),
                KTPCard(
                  onChanged: (List<int> bytes, String? ktpNumber) async {
                    ktpImageBytes = bytes;
                    if (ktpNumber != null && ktpNumber != "") {
                      _text2.text = ktpNumber;
                    }
                    validate();
                  },
                ),
                const SizedBox(height: Constants.spacing4),
                Text(_invalids['customerName'] ?? 'Nama Debitur',
                    style: TextStyle(
                        fontSize: Constants.fontSizeSm,
                        color: _invalids['customerName'] != null
                            ? Constants.donker.shade500
                            : Constants.gray)),
                const SizedBox(height: Constants.spacing1),
                Focus(
                  onFocusChange: (hasFocus) {
                    if (hasFocus && _inputPhase < 1) {
                      _inputPhase = 1;
                    }
                  },
                  child: TextField(
                    // readOnly:
                    //     _text7.text == null || _text7.text == "" ? false : true,
                    controller: _text1,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor:  Constants.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: Constants.spacing3),
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Constants.gray.shade900),
                            borderRadius: const BorderRadius.all(Radius.circular(Constants.spacing3))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Constants.gray.shade200),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(Constants.spacing3)))),
                    onChanged: (text) {
                      widget.order['customerName'] = _text1.text;
                      validate();
                    },
                  ),
                ),
                const SizedBox(height: Constants.spacing4),
                Text(_invalids['customerPhone'] ?? 'Nomor HP',
                    style: TextStyle(
                        fontSize: Constants.fontSizeSm,
                        color: _invalids['customerPhone'] != null
                            ? Constants.donker.shade500
                            : Constants.gray)),
                const SizedBox(height: Constants.spacing1),
                Focus(
                  onFocusChange: (hasFocus) {
                    if (hasFocus && _inputPhase < 2) {
                      _inputPhase = 2;
                    }
                  },
                  child: TextField(
                    // readOnly: true,
                    controller: noHp,
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    decoration: InputDecoration(
                        filled: true,
                        counterText: '',
                        fillColor: Constants.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: Constants.spacing3),
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.gray.shade900),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(Constants.spacing3))),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.gray.shade200),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(Constants.spacing3)))),
                  ),
                ),
                const SizedBox(height: Constants.spacing4),
                Text(_invalids['customerKtpNumber'] ?? 'Nomor KTP',
                    style: TextStyle(
                        fontSize: Constants.fontSizeSm,
                        color: _invalids['customerKtpNumber'] != null
                            ? Constants.donker.shade500
                            : Constants.gray)),
                const SizedBox(height: Constants.spacing1),
                Focus(
                  onFocusChange: (hasFocus) {
                    if (hasFocus && _inputPhase < 2) {
                      _inputPhase = 2;
                    }
                  },
                  child: TextField(
                    controller: _text2,
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    decoration: InputDecoration(
                        filled: true,
                        counterText: '',
                        fillColor:  Constants.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: Constants.spacing3),
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Constants.gray.shade900),
                            borderRadius: const BorderRadius.all(Radius.circular(Constants.spacing3))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Constants.gray.shade200),
                            borderRadius: const BorderRadius.all(Radius.circular(Constants.spacing3)))),
                    onChanged: (text) {
                      widget.order['customerKtpNumber'] = _text2.text;
                      validate();
                    },
                  ),
                ),
                
                const SizedBox(height: Constants.spacing4),
                Text(_invalids['deliveryKelurahanId'] ?? 'Kota/Kecamatan',
                    style: TextStyle(
                        fontSize: Constants.fontSizeSm,
                        color: _invalids['deliveryKelurahanId'] != null
                            ? Constants.donker.shade500
                            : Constants.gray)),
                const SizedBox(height: Constants.spacing1),
                InkWell(
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
                    child: widget.order['deliveryKelurahanName'] == null
                        ?  Text('Tekan untuk memilih Kota/Kecamatan...',
                            style: TextStyle(color: Constants.donker.shade500))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.order['deliveryKelurahanName']),
                              const SizedBox(height: Constants.spacing1),
                              Text(
                                  "${widget.order['deliveryKecamatanName']} - ${widget.order['deliveryCityName']} ${widget.order['deliveryPostalCode']}",
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
                        Text(_invalids['deliveryRt'] ?? 'RT',
                            style: TextStyle(
                                fontSize: Constants.fontSizeSm,
                                color: _invalids['deliveryRt'] != null
                                    ? Constants.donker.shade500
                                    : Constants.gray)),
                        const SizedBox(height: Constants.spacing1),
                        Focus(
                            onFocusChange: (hasFocus) {
                              if (hasFocus && _inputPhase < 5) {
                                _inputPhase = 5;
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
                                widget.order['deliveryRt'] = _text4.text;
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
                        Text(_invalids['deliveryRw'] ?? 'RW',
                            style: TextStyle(
                                fontSize: Constants.fontSizeSm,
                                color: _invalids['deliveryRw'] != null
                                    ? Constants.donker.shade500
                                    : Constants.gray)),
                        const SizedBox(height: Constants.spacing1),
                        Focus(
                          onFocusChange: (hasFocus) {
                            if (hasFocus && _inputPhase < 6) {
                              _inputPhase = 6;
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
                              widget.order['deliveryRw'] = _text5.text;
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
        widget.order['deliveryKelurahanId'] = kelurahan['id'];
        widget.order['deliveryKecamatanId'] = kelurahan['kecamatan']['id'];
        widget.order['deliveryCityId'] = kelurahan['kecamatan']['city']['id'];
        widget.order['deliveryProvinceId'] =
            kelurahan['kecamatan']['city']['province']['id'];
        widget.order['deliveryPostalCode'] = kelurahan['postalCode'];
        widget.order['deliveryKelurahanName'] = kelurahan['alias'];
        widget.order['deliveryKecamatanName'] = kelurahan['kecamatan']['alias'];
        widget.order['deliveryCityName'] =
            kelurahan['kecamatan']['city']['alias'];
        widget.order['deliveryProvinceName'] =
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
                    active ? Constants.donker.shade500 : Constants.gray.shade300,
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
                  color: active ? Constants.donker.shade500 : Constants.gray)),
          const SizedBox(width: Constants.spacing1),
          trailing
              ? Container(
                  height: 3,
                  width: 30,
                  color:
                      active ? Constants.donker.shade500 : Constants.gray.shade300,
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
          title: const Text('Lengkapi Data Peminjam'),
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
                      buildTabItem(1, 'Data Debitur', active: true),
                      buildTabItem(2, 'Foto KTP Penjamin & KK'),
                      buildTabItem(3, 'Kirim', trailing: false),
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
                    ButtonAgent(
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
                          // Navigator.of(context)
                          //     .push(MaterialPageRoute(builder: (_) {
                          //   FocusScope.of(context).unfocus();
                          //   return HMCAgentCheckout2({});
                          // }));
                        } else {
                          validate();
                          setState(() {
                            _invalids = invalids;
                            if (_text4.text.isEmpty ||
                                widget.order['deliveryKelurahanId'] == null ||
                                _text5.text.isEmpty) {
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
              const SizedBox(height: Constants.spacing8),
              const SizedBox(height: Constants.spacing8)
            ],
          ),
        ),
      ),
    );
  }
}
