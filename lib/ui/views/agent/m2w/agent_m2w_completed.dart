import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/button_agent.dart';

import '../../../../../application/app/app_log.dart';

class M2WAgentCompleted extends StatefulWidget {
  final data;

  const M2WAgentCompleted({Key? key, required this.data}) : super(key: key);

  @override
  _M2WAgentCompleted createState() => _M2WAgentCompleted();
}

class _M2WAgentCompleted extends State<M2WAgentCompleted> {
  @override
  void initState() {
    super.initState();

    AppLog().logScreenView('HMC Submitted');
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(
        ClipboardData(text: widget.data['code'].toString()));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('${widget.data['code'].toString()} berhasil disalin'),
          SvgPicture.asset(
            'assets/svg/check.svg',
            color: Constants.lime,
            width: 32,
            height: 32,
            alignment: Alignment.topCenter,
          )
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(40),
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
                  'Terima kasih telah melakukan pengajuan Multiguna Motor melalui KlikNSC.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: Constants.fontSizeLg)),
              const SizedBox(height: Constants.spacing4),
              const Text(
                  'Harap tunggu, kami akan segera mengabari anda perihal pengajuan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: Constants.fontSizeLg)),
              const SizedBox(height: Constants.spacing8),
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
              const SizedBox(height: Constants.spacing8),
              Row(
                children: [
                  Expanded(
                      child: ButtonAgent(
                          fontSize: Constants.fontSizeLg,
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/page?url=/account/orders/${widget.data?['id']}',
                              // '/account/orders/${widget.data?['id']}',
                              ModalRoute.withName('/page=""'));
                          },
                          text: 'Lihat Pengajuan')),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                      child: ButtonAgent(
                          fontSize: Constants.fontSizeLg,
                          type: ButtonType.secondary,
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/page', (route) => false);
                          },
                          text: 'Kembali ke Home')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
