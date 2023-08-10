import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/button.dart';

import '../../../../application/app/app_log.dart';

class M2wCompleted extends StatefulWidget {
  final data;

  const M2wCompleted({Key? key, required this.data}) : super(key: key);

  @override
  _M2wCompleted createState() => _M2wCompleted();
}

class _M2wCompleted extends State<M2wCompleted> {
  Future<void> _copyToClipboard() async {
    await Clipboard.setData(
        ClipboardData(text: widget.data['code'].toString()));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [Text('Kode berhasil disalin.')],
      ),
    ));
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    AppLog().logScreenView('M2W Submitted');
  }

  Future<bool> onWillPop() async {
    Navigator.popUntil(context, ModalRoute.withName('/'));

    return false;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(Constants.spacing8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/avatar_completed.png',
                  width: screenWidth * .7,
                  height: screenWidth * .7,
                ),
                const Text('Pengajuan Terkirim',
                    style: TextStyle(
                        fontSize: Constants.fontSize2Xl,
                        fontFamily: Constants.primaryFontBold)),
                const SizedBox(height: Constants.spacing4),
                const Text(
                    'Terima kasih telah melakukan pengajuan multiguna motor melalui KlikNSS.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: Constants.fontSizeLg)),
                const SizedBox(height: Constants.spacing2),
                const Text(
                    'Harap tunggu, kami akan segera mengabari anda perihal pengajuan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: Constants.fontSizeLg)),
                const SizedBox(height: 24),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Kode Booking',
                        style: TextStyle(color: Constants.gray)),
                    const SizedBox(height: Constants.spacing1),
                    Container(
                      padding: const EdgeInsets.fromLTRB(
                          Constants.spacing4,
                          Constants.spacing1,
                          Constants.spacing2,
                          Constants.spacing1),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(widget.data['code'].toString(),
                              style: TextStyle(
                                  fontSize: Constants.fontSizeXl,
                                  fontFamily: Constants.primaryFontBold)),
                          IconButton(
                            icon: const Icon(Icons.copy,
                                size: 18, color: Constants.gray),
                            padding: const EdgeInsets.all(Constants.spacing2),
                            constraints: const BoxConstraints(),
                            onPressed: _copyToClipboard,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Constants.spacing6),
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 240),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Button(
                        text: 'Buka Pengajuan',
                        fontSize: Constants.fontSizeLg,
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/account/orders/${widget.data?['id']}',
                              ModalRoute.withName('/'));
                        },
                      ),
                      const SizedBox(height: Constants.spacing2),
                      Button(
                        text: 'Ke Home',
                        fontSize: Constants.fontSizeLg,
                        type: ButtonType.secondary,
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil(ModalRoute.withName('/'));
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
