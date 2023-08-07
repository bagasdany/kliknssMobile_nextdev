import 'package:flutter/material.dart';
import 'package:kliknss77/ui/component/button.dart';

import '../../../application/style/constants.dart';

class NetworkErrorPage extends StatelessWidget {
  final Function? onSuccess;
  const NetworkErrorPage({
    Key? key,
    this.onSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Align(
            child: Container(
                margin: const EdgeInsets.only(top: Constants.spacing8),
                padding: const EdgeInsets.all(Constants.spacing4),
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Image.asset(
                      'assets/images/payment_failed.png',
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: Constants.spacing4),
                      child: const Text(
                        "Koneksi internetmu terganggu!",
                        style: TextStyle(
                            fontSize: Constants.fontSize2Xl,
                            color: Constants.gray,
                            fontFamily: Constants.primaryFontBold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: Constants.spacing2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: Constants.spacing6,
                      ),
                      child: const Text(
                        "Pastikan internetmu lancar dengan cek ulang paket data, Wifi, atau jaringan di tempatmu.",
                        style: TextStyle(
                          color: Constants.gray,
                          fontSize: Constants.fontSizeSm,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin:
                            const EdgeInsets.only(bottom: Constants.spacing6),
                        padding: const EdgeInsets.all(Constants.spacing4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Button(
                                type: ButtonType.primary,
                                text: 'Coba Lagi',
                                fontSize: Constants.fontSizeLg,
                                onPressed: () {
                                  if (onSuccess != null) {
                                    onSuccess!();
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ));
  }
}
