import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kliknss77/application/services/dummy/home_json.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/button.dart';
import 'package:kliknss77/ui/views/login/login_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../infrastructure/database/shared_prefs.dart';

class OnBoardings extends StatefulWidget {
  dynamic item;
  OnBoardings({
    Key? key,
    this.item,
  }) : super(key: key);

  @override
  State<OnBoardings> createState() => _OnBoardingsState();
}

class _OnBoardingsState extends State<OnBoardings> {
  final PageController controller = PageController(initialPage: 0);
  final PageController formController = PageController(initialPage: 0);

  final _sharedPrefs = SharedPrefs();
  int currentIndex = 0;
  int indexPage = 0;
  int indexDialog = 0;

  @override
  void initState() {
    super.initState();

    widget.item = (ResponseHomeType().onBoardings ?? []);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // _sharedPrefs.set('opened', true);
    });
  }

  Widget _buildIndicator(items) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding:  EdgeInsets.symmetric(
              horizontal: Constants.spacing8, vertical:  indexPage == (widget.item ?? []).length - 1
                  ? Constants.spacing2: Constants.spacing4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              indexPage == (widget.item ?? []).length - 1
                  ? Button(
                    key: const ValueKey("masuk"),
                    
                    text: 'Masuk',
                                        // iconSvg: 'assets/svg/add.svg',
                                        type: ButtonType.secondary,
                                        fontSize: Constants.fontSizeLg,
                                        onPressed: () async{

                                      Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      const LoginView()),
             (Route<dynamic> route) => route.isFirst);
                    
                                        },
                                      )
                  : InkWell(
                      onTap: () {
                        setState(() {
                          indexPage == widget.item.length - 1
                              ? indexPage = widget.item.length
                              : indexPage = indexPage + 1;

                          // controller. = PageController(initialPage: 0);
                        });
                        controller.animateToPage(indexPage,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut);
                      },
                      child: const Text(
                        'Lanjut',
                        key:  ValueKey("lanjut"),
                        style: TextStyle(
                          fontSize: Constants.fontSizeXl,
                          color: Constants.white,
                        ),
                      ),
                    ),
              const SizedBox(
                width: Constants.spacing2,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    indexPage == widget.item.length - 1
                        ? indexPage = widget.item.length
                        : indexPage = indexPage + 1;

                    // controller. = PageController(initialPage: 0);
                  });
                  indexPage == (widget.item ?? []).length
                      ? null
                      : controller.animateToPage(indexPage,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut);
                },
                child: indexPage == widget.item.length - 1
                    ? Container()
                    : SvgPicture.asset(
                        'assets/svg/arrow_forward.svg',
                        color: Constants.white,
                        width: 23,
                        height: 23,
                        alignment: Alignment.center,
                      ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              Constants.spacing5, 0, Constants.spacing5, Constants.spacing9),
          child: SmoothPageIndicator(
              controller: controller,
              count: items.length,
              effect: ExpandingDotsEffect(
                  dotHeight: 13,
                  strokeWidth: 13,
                  expansionFactor: 5,
                  spacing: 16,
                  dotWidth: 10,
                  dotColor: Constants.primaryColor.shade50,
                  activeDotColor: Constants.gray.shade400)),
        ),
      ],
    );
  }

  Future<bool> onWillPop() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                SingleChildScrollView(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // Container(height: 100, child: _buildIndicator(widget.item ?? [])),
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: PageView.builder(
                          onPageChanged: (value) {
                            setState(() {
                              indexPage = value;
                            });
                          },
                          controller: controller,
                          itemCount: (widget.item ?? []).length,
                          itemBuilder: (BuildContext context, index) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {});
                            return Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      widget.item?[index]?['images_bg']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Constants.spacing8),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1 / 1,
                                      child: Image.asset(
                                        widget.item[index]['images_obj'],
                                      ),
                                    ),
                                    Container(
                                      child: Center(
                                          child: Text(
                                        widget.item[index]['title'],
                                        style: const TextStyle(
                                            fontFamily:
                                                Constants.primaryFontBold,
                                            color: Constants.white,
                                            fontSize: Constants.fontSize3Xl),
                                        textAlign: TextAlign.center,
                                      )),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                        top: Constants.spacing2,
                                        bottom: Constants.spacing5,
                                      ),
                                      child: Text(
                                        widget.item[index]['description'],
                                        style: const TextStyle(
                                          color: Constants.white,
                                          fontSize: Constants.fontSizeMd,

                                          // fontFamily: Constants.primaryFontBold
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildIndicator(widget.item ?? []),
                        ],
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(
                        0, Constants.spacing10, Constants.spacing6, 0),
                    child: Text(
                      
                      "Lewati",

                    key: const ValueKey("lewati"),
                      style: TextStyle(
                          fontSize: Constants.fontSizeSm,
                          fontFamily: Constants.primaryFontBold,
                          color: Constants.white.withOpacity(0.7)),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
