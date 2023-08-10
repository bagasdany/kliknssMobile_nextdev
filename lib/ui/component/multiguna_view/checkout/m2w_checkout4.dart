import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:kliknss77/application/app/app_log.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/app_dialog.dart';
import 'package:kliknss77/ui/component/button.dart';
import 'package:kliknss77/ui/component/multiguna_view/checkout/m2w_completed_temp.dart';

class M2WCheckout4 extends StatefulWidget {
  Map order = {};
  Map? kelurahan;

  M2WCheckout4(this.order, {Key? key}) : super(key: key);

  @override
  State<M2WCheckout4> createState() => _M2WCheckout4State();
}

class _M2WCheckout4State extends State<M2WCheckout4> {
  final Dio _dio = DioService.getInstance();
  final formatter = intl.NumberFormat.decimalPattern();
  int _state = 1;

  List<Map>? kelurahans;

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
      AppLog().logScreenView('M2W Checkout 4');
    });
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
    setState(() {
      _state = 2;
    });
    try {
      final response = await _dio
          .post(Endpoint.confirm, data: getFormData())
          .timeout(const Duration(seconds: 15));
      setState(() {
        _state = 1;
      });
      final order = response.data['order'];

      // AppPage.remove('m2w');
      // AppPage.remove('m2w-motor');

      if (response.data['ga'] != null) {
        AppLog().logPurchase(
            coupon: response.data['ga']['coupon'],
            value: response.data['ga']['value'],
            items: response.data['ga']['items'],
            shipping: response.data['ga']['shipping'],
            transactionId: response.data['ga']['transactionId']);
      }

      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) {
        return M2wCompleted(data: order);
      }), ModalRoute.withName('/'));
    } on TimeoutException catch (e) {
      AppDialog.snackBar(text: "Terjadi Kesalahan, Silahkan Coba Lagi");
      setState(() {
        _state = 1;
      });
    }
  }

  Widget buildSection1() {
    var item = widget.order['items'][0] ?? {};
    var extra = item['extra'] ?? {};
    var extraPrice = extra['price'] ?? {};
    var price = item['price'];
    var priceInstallment = item['priceInstallment'];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(Constants.spacing4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item['name'],
              style: const TextStyle(fontFamily: Constants.primaryFontBold)),
          const SizedBox(height: Constants.spacing1),
          Text('${extraPrice['year']} - ${extraPrice['ownershipText'] ?? ''}',
              style: const TextStyle(fontSize: Constants.fontSizeSm)),
          const SizedBox(height: Constants.spacing4),
          Row(
            children: [
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const Text('Pencairan',
                        style: TextStyle(
                            fontSize: Constants.fontSizeSm,
                            color: Constants.gray)),
                    const SizedBox(height: Constants.spacing1),
                    Text(price != null ? 'Rp. ${formatter.format(price)}' : '-',
                        style: const TextStyle(
                            color: Constants.primaryColor,
                            fontFamily: Constants.primaryFontBold))
                  ])),
              const SizedBox(width: Constants.spacing4),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const Text('Cicilan/bln',
                        style: TextStyle(
                            fontSize: Constants.fontSizeSm,
                            color: Constants.gray)),
                    const SizedBox(height: Constants.spacing1),
                    Text(
                        priceInstallment != null
                            ? 'Rp. ${formatter.format(priceInstallment)}'
                            : '-',
                        style: const TextStyle(
                            color: Constants.primaryColor,
                            fontFamily: Constants.primaryFontBold)) // TODO
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
      'deliveryAddress': 'Alamat Tempat Tinggal',
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
              SizedBox(
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
          child: const Text('Data Peminjam',
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
              SizedBox(
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 21,
          height: 21,
          decoration: BoxDecoration(
              color: active ? Constants.primaryColor : Constants.gray.shade300,
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
                      buildTabItem(4, 'Kirim', active: true, trailing: false),
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
            const SizedBox(height: Constants.spacing4),
            buildSection1(),
            const SizedBox(height: Constants.spacing4),
            buildSection2(context),
            const SizedBox(height: Constants.spacing4),
            buildSection3(context),
            const SizedBox(height: Constants.spacing4),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: Constants.spacing4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Button(
                    text: 'Kirim Pengajuan',
                    fontSize: Constants.fontSizeLg,
                    state:
                        _state == 2 ? ButtonState.loading : ButtonState.normal,
                    onPressed: () {
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
