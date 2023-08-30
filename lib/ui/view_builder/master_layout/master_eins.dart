
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kliknss77/application/builders/body_builder.dart';
import 'package:kliknss77/application/builders/header_builder.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/icon_refresh_indicator.dart';
import 'package:tailwind_style/tailwind_style.dart';
import '../../../infrastructure/database/shared_prefs.dart';

// ignore: must_be_immutable
class MasterEins extends StatefulWidget {
  dynamic controller,section,home,url,state;
  MasterEins({
    Key? key,
    this.section,
    this.state,
    this.controller,
    this.home,
    this.url
  }) : super(key: key);

  @override
  _MasterEins createState() => _MasterEins();
}

class _MasterEins extends State<MasterEins>{
  @override
  final Dio _dio = DioService.getInstance();


  final Color _warna = Constants.white;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _flashSalescrollController = ScrollController();
  List? listInfo = [];
  int state = 0;

  bool locationDenied = false;
  dynamic login, userId, isAgen;
  final _sharedPrefs = SharedPrefs();
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      print("shimmer widget di master eins ${widget.state}");
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
    ));
    return Scaffold(
    extendBody: true,
    extendBodyBehindAppBar: true,
    body: CustomRefreshIndicator(
      builder: MaterialIndicatorDelegate(
        builder: (context, controller) {
          return IconRefreshIndicator();
        },
      ),
      onRefresh: () async {
        
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: Stack(
          key: const ValueKey('coba'),
          children: <Widget>[
            SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                
                Container(color: Constants.amber,height: 95,),
                const TextTailwind(text:"apa iniii",
                extClass: "font-light underline text-6xl font-mono dark:text-emerald-600 bg-blue-500 p-6  md:mx-auto grid-cols-2 md:grid-cols-6 gap-4 md:gap-6  md:max-w-screen-xl",),
                const ContainerTailwind(extClass:  "pl-8 pt-10 pr-9 pb-11 max-w-max w-full  text-red-600 bg-blue-500 md:mx-auto grid-cols-2 md:grid-cols-6 gap-4 md:gap-6  md:max-w-screen-xl",
                  child: TextTailwind(text:"apa iniiis",
              extClass: "font-light underline text-6xl font-mono dark:text-emerald-600 bg-blue-500 pl-0 pt-1 pr-0 pb-1  md:mx-auto grid-cols-2 md:grid-cols-6 gap-4 md:gap-6  md:max-w-screen-xl",),),
                widget.section != null
                    ? ListView.builder(
                        padding: const EdgeInsets.all(0),
                        addAutomaticKeepAlives: true,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:(widget.section['components'] ?? []).length,
                        itemBuilder: ((context, index) {return BodyBuilder(section: widget.section?['components']?[index]??[],state: widget.state,);
                        }),
                      )
                    :  Container(),
                  ],
                ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 120,
                  child:  widget.section != null
                    ? ListView.builder(
                        padding: const EdgeInsets.all(0),
                        addAutomaticKeepAlives: true,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            (widget.section['headers'] ?? [])
                                .length,
                        itemBuilder: ((context, index) {
                          return HeaderBuilder(
                          key: const ValueKey("appbar"),
                          warna: _warna,
                          transparentMode: true,
                          controller: _scrollController,
                          section: widget.section?['headers']?[index]??[],);
                          // BodyBuilder(section: widget.section?['components']?[index]??[],state: widget.state,);
                        }),
                      )
                    :  Container(),
                    
                    
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  }
}


