// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/app_dialog.dart';
import 'package:kliknss77/ui/component/button_agent.dart';
import 'package:kliknss77/ui/component/dio_exceptions.dart';
import 'package:kliknss77/ui/component/handle_error/network_error.dart';
import 'package:kliknss77/ui/views/agent/hmc/agent_hmc_completed.dart';
import '../../../../../application/app/app_log.dart';

class HMCAgentCheckout3 extends StatefulWidget {
  Map order = {};
  Map? kelurahan;

  HMCAgentCheckout3(this.order, {Key? key}) : super(key: key);

  @override
  State<HMCAgentCheckout3> createState() => _HMCAgentCheckout3State();
}

class _HMCAgentCheckout3State extends State<HMCAgentCheckout3> {
  final Dio _dio = DioService.getInstance();
  final formatter = intl.NumberFormat.decimalPattern();

  List<Map>? kelurahans;
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
    // widget.order['customerName'] = "Bagas Dany" ?? '';
    // widget.order['customerKtpNumber'] = "33483748738474" ?? '';
    // widget.order['deliveryProvinceName'] = "Jawa Tengah" ?? '';
    // widget.order['deliveryCityName'] = "Semarang" ?? '';
    // widget.order['deliveryKecamatanName'] = "Semarang Barat" ?? '';
    // widget.order['deliveryKelurahanName'] = "Tambakrejo" ?? '';
    // widget.order['deliveryPostalCode'] = "50144" ?? '';
    // widget.order['deliveryRt'] = "001" ?? '';
    // widget.order['deliveryRw'] = "002" ?? '';

    AppLog().logScreenView('HMC Checkout 3');
  }

  FormData getFormData() {
    List<String> keys = ['id'];
    Map<String, dynamic> formMap = {};
    for (var key in keys) {
      formMap[key] = widget.order[key];
    }
    FormData form = FormData.fromMap(formMap);

    return form;
  }

  Future<void> submit(BuildContext context) async {
    // TODO: Handle error
    try {
      setState(() {
        _state = 2;
      });
      final response = await _dio
          .post(Endpoint.confirm, data: getFormData())
          .timeout(const Duration(seconds: 15));
      final order = response.data['order'];
      setState(() {
        _state = 1;
      });

      if (response.data['ga'] != null) {
        AppLog().logPurchase(
            coupon: response.data['ga']['coupon'],
            value: response.data['ga']['value'],
            items: response.data['ga']['items'],
            shipping: response.data['ga']['shipping'],
            transactionId: response.data['ga']['transactionId']);
      }

      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) {
        return HMCAgentCompleted(data: order);
      }), ModalRoute.withName('/'));
    } on TimeoutException catch (e) {
      setState(() {
        _state = 1;
      });
      // Navigator.pop(context);

      AppDialog.snackBar(
          text:
              "Maaf, Koneksi internet anda kurang mendukung, Silahkan coba lagi");
    } on DioException catch (e) {
      dynamic errors = DioExceptions.fromDioError(e);
      if (errors != null) {
        if (errors.message == "No Internet") {
          setState(() {
            _state = -2;
          });
        } else {
          setState(() {
            _state = 1;
          });
        }
      }
    }
  }

  Widget buildSection1() {
    var item = widget.order['items']?[0] ?? {};
    var extra = item['extra'] ?? {};
    var price = item['price'];
    var priceInstallment = extra['price']['installment'];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(Constants.spacing4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            item['imageUrl'] == null || item['imageUrl'] == "" ? Container():
            CachedNetworkImage(
                      imageUrl: item['imageUrl'] ?? "" ,
                    width: 84, height: 84,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) => Container(),
                                  ),
            // Image.network('${item['imageUrl']}',width: 84, height: 84),
            const SizedBox(width: Constants.spacing2),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.order['items'][0]['name'],
                      style: const TextStyle(
                          fontFamily: Constants.primaryFontBold)),
                  const SizedBox(height: Constants.spacing1),
                  Text('${extra['series_year']}',
                      style: const TextStyle(fontSize: Constants.fontSizeSm)),
                ],
              ),
            )
          ]),
          const SizedBox(height: Constants.spacing4),
          Row(
            children: [
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(item['otrPrice'] == null ? 'DP Bayar' : "Harga Cash",
                        style: const TextStyle(
                            fontSize: Constants.fontSizeSm,
                            color: Constants.gray)),
                    const SizedBox(height: Constants.spacing1),
                    Text(price != null ? 'Rp. ${formatter.format(price)}' : '-',
                        style: const TextStyle(
                            color: Constants.donker,
                            fontFamily: Constants.primaryFontBold))
                  ])),
              const SizedBox(width: Constants.spacing4),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(item['otrPrice'] == null ? 'Cicilan/bln' : "",
                        style: const TextStyle(
                            fontSize: Constants.fontSizeSm,
                            color: Constants.gray)),
                    const SizedBox(height: Constants.spacing1),
                    Text(
                        item['otrPrice'] != null
                            ? ''
                            : priceInstallment != null
                                ? 'Rp. ${formatter.format(priceInstallment)}'
                                : '-',
                        style: const TextStyle(
                            color: Constants.donker,
                            fontFamily: Constants.primaryFontBold))
                  ]))
            ],
          )
        ],
      ),
    );
  }

  Widget buildSection2(BuildContext context) {
    double leftWidth = MediaQuery.of(context).size.width * .4;
    Map keys = {
      'customerName': 'Nama Lengkap',
      'customerKtpNumber': 'Nomor KTP',
      'deliveryProvinceName': 'Provinsi',
      'deliveryCityName': 'Kota',
      'deliveryKecamatanName': 'Kecamatan',
      'deliveryKelurahanName': 'Kelurahan',
      'deliveryPostalCode': 'Kode Pos',
      'deliveryRt': 'RT',
      'deliveryRw': 'RW',
    };

    List<Widget> rows = [];
    keys.forEach((key, value) {
      rows.add(Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, Constants.spacing2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: leftWidth,
                child: Text(
                  value,
                  style: TextStyle(
                      color: Constants.gray.shade500,
                      fontSize: Constants.fontSizeSm),
                  textAlign: TextAlign.end,
                ),
              ),
              const SizedBox(width: Constants.spacing2),
              Expanded(
                child: Text(widget.order[key] ?? '',
                    style: const TextStyle(fontSize: Constants.fontSizeSm)),
              ),
            ],
          )));
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: Constants.spacing4),
          child: const Text('Data Debitur',
              style: TextStyle(color: Constants.gray)),
        ),
        const SizedBox(height: Constants.spacing2),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(Constants.spacing4),
          child: Column(
            children: rows,
          ),
        )
      ],
    );
  }

  Widget buildSection3(BuildContext context) {
    double leftWidth = MediaQuery.of(context).size.width * .4;
    Map keys = {
      'refKtpNumber': 'Nomor KTP',
      'refAddress': 'Alamat Tempat Tinggal',
      'refProvinceName': 'Provinsi',
      'refCityName': 'Kota',
      'refKecamatanName': 'Kecamatan',
      'refKelurahanName': 'Kelurahan',
      'refPostalCode': 'Kode Pos',
      'refRt': 'RT',
      'refRw': 'RW',
    };

    List<Widget> rows = [];
    keys.forEach((key, value) {
      rows.add(Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, Constants.spacing2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: leftWidth,
                child: Text(
                  value,
                  style: TextStyle(
                      color: Constants.gray.shade500,
                      fontSize: Constants.fontSizeSm),
                  textAlign: TextAlign.end,
                ),
              ),
              const SizedBox(width: Constants.spacing2),
              Expanded(
                child: Text(widget.order[key] ?? '',
                    style: const TextStyle(fontSize: Constants.fontSizeSm)),
              ),
            ],
          )));
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: Constants.spacing4),
          child: const Text('Data Penjamin',
              style: TextStyle(color: Constants.gray)),
        ),
        const SizedBox(height: Constants.spacing2),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(Constants.spacing4),
          child: Column(
            children: rows,
          ),
        )
      ],
    );
  }

  Widget buildTabItem(number, text, {active = false, trailing = true}) {
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
            child: Text('$number',
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
                      buildTabItem(1, 'Data Debitur', active: true),
                      buildTabItem(2, 'Foto KTP & KK Debitur', active: true),
                      buildTabItem(3, 'Kirim', active: true, trailing: false),
                      const SizedBox(width: Constants.spacing6)
                    ],
                  ),
                ),
              ))),
      body: _state == -2
          ? NetworkErrorPage(
              onSuccess: () {
                // submit(context);
              },
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Constants.spacing4),
                  buildSection1(),
                  const SizedBox(height: Constants.spacing4),
                  buildSection2(context),
                  const SizedBox(height: Constants.spacing4),
                  // buildSection3(context),
                  // const SizedBox(height: Constants.spacing4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Constants.spacing4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ButtonAgent(
                          text: 'Kirim Pengajuan',
                          fontSize: Constants.fontSizeLg,
                          state: _state == 2
                              ? ButtonState.loading
                              : ButtonState.normal,
                          onPressed: () {
                            // Navigator.of(context).pushAndRemoveUntil(
                            //     MaterialPageRoute(builder: (_) {
                            //   return HMCAgentCompleted(data: {});
                            // }), ModalRoute.withName('/'));
                            submit(context);
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
