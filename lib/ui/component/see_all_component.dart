import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kliknss77/application/style/constants.dart';

class SeeAll extends StatefulWidget {
  final dynamic onClick;
  final dynamic width;
  const SeeAll({
    Key? key,
    this.width,
    this.onClick,
  }) : super(key: key);

  @override
  State<SeeAll> createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAll> {
  @override
  Widget build(BuildContext context) {
    String defaultcolor = "#BC4747";

    return Stack(
      children: [
        Container(
          
          decoration:  const BoxDecoration(
              borderRadius: BorderRadius.all(
            Radius.circular(Constants.spacing2),
            

          )),
        ),
        InkWell(
          onTap: () {
            widget.onClick();
          },
          child: AspectRatio(
            aspectRatio: 1 / 2.3,
            child: Container(
              margin:
                  const EdgeInsets.symmetric(vertical: Constants.spacing2),
                
              decoration: BoxDecoration(
                  color: Constants.white.withOpacity(0.8),

            border: Border.all(color: Constants.gray.shade300),
                  // border: Border(
                  //                     bottom: BorderSide(
                  //                         color: Constants.gray, width: 1)),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(Constants.spacing2),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(

                      color: Constants.white.withOpacity(0.8),
                      shadowColor: Colors.transparent,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(Constants.spacing2),
                        child: SvgPicture.asset(
                          'assets/svg/arrow_forward.svg',
                          color: Constants.primaryColor,
                          width: 25,
                          height: 25,
                          alignment: Alignment.topCenter,
                        ),
                      )),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: Constants.spacing2,
                        vertical: Constants.spacing2),
                    child: const Text(
                      "Lihat Produk Lainnya",
                      style: TextStyle(
                          color: Constants.primaryColor,
                          // fontSize: Constants.fontSizeLg,
                          fontFamily: Constants.primaryFontBold),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
