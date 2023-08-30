import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kliknss77/application/style/constants.dart';


class Page404 extends StatelessWidget {
  const Page404({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            SvgPicture.asset('assets/svg/alert_circled.svg',
                width: 120, height: 120, color: Constants.gray),
            const SizedBox(height: Constants.spacing4),
            const Text("Halaman tidak ditemukan, coba lagi")
          ],
        ),
        const SizedBox(height: Constants.spacing10),
        const SizedBox(height: Constants.spacing10)
      ],
    );
  }
}
