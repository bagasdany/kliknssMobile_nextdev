import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/bank_account_card.dart';
import 'package:kliknss77/ui/component/button_agent.dart';
import 'package:kliknss77/ui/views/agent/hmc/checkout_hmc_agent3.dart';
import 'package:kliknss77/ui/views/ocr/ktp_card.dart';
import '../../../../../application/app/app_log.dart';

class HMCAgentCheckout2 extends StatefulWidget {
  Map order = {};
  Map? kelurahan;

  HMCAgentCheckout2(this.order, {Key? key}) : super(key: key);

  @override
  State<HMCAgentCheckout2> createState() => _HMCAgentCheckout2State();
}

class _HMCAgentCheckout2State extends State<HMCAgentCheckout2> {
  final Dio _dio = DioService.getInstance();

  Map invalids = {};

  List<Map>? kelurahans;
  List<int>? stnkImageBytes;
  List<int>? stnkImage2Bytes;

  Map _invalids = {};
  bool _valid = false;
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

    validate();

    AppLog().logScreenView('M2W Checkout 2');
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
      form.files.add(MapEntry('customerRefImage', stnkImage));
    }

    if (stnkImage2Bytes != null) {
      MultipartFile stnkImage2 = MultipartFile.fromBytes(stnkImage2Bytes!,
          contentType: MediaType('image', 'jpg'),
          filename: 'Image-${DateTime.now().millisecondsSinceEpoch}.jpg');
      form.files.add(MapEntry('customerRefImage', stnkImage2));
    }

    return form;
  }

  Future<void> save(BuildContext context) async {
    setState(() {
      _state = 2;
    });
    FormData data = getFormData();
    final response = await _dio.post(Endpoint.checkout, data: data);
    setState(() {
      _state = 1;
    });
    final order = response.data['order'];

    FocusScope.of(context).unfocus();

    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      FocusScope.of(context).unfocus();
      return HMCAgentCheckout3(order);
    }));
  }

  void validate() {
    invalids['stnkImage'] =
        stnkImageBytes == null ? 'Foto KTP Penjamin diperlukan' : null;

    invalids['stnkImage2'] =
        stnkImage2Bytes == null ? 'Foto KK diperlukan' : null;

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
                Text(_invalids['stnkImage'] ?? 'Foto KTP Penjamin',
                    style: TextStyle(
                        fontSize: Constants.fontSizeSm,
                        color: _invalids['stnkImage'] != null
                            ? Constants.donker.shade500
                            : Constants.gray)),
                const SizedBox(height: Constants.spacing1),
                // onChanged: (List<int> bytes, String? ktpNumber) async {
                //     ktpImageBytes = bytes;
                //     if (ktpNumber != null && ktpNumber != "") {
                //       _text2.text = ktpNumber;
                //     }
                //     validate();
                //   },
                KTPCard(
                  onChanged: (List<int> bytes, String? ktpNumber) {
                    setState(() {
                      stnkImageBytes = bytes;
                    });
                    validate();
                  },
                ),
                const SizedBox(height: Constants.spacing4),
                Text(_invalids['stnkImage2'] ?? 'Foto Kartu Keluarga',
                    style: TextStyle(
                        fontSize: Constants.fontSizeSm,
                        color: _invalids['stnkImage2'] != null
                            ? Constants.donker.shade500
                            : Constants.gray)),
                const SizedBox(height: Constants.spacing1),
                BankAccountCard(
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
          title: const Text('Foto Penjamin & KK'),
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
                      buildTabItem(2, 'Foto KTP Penjamin & KK ', active: true),
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
                        //   return HMCAgentCheckout3({});
                        // }));
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
