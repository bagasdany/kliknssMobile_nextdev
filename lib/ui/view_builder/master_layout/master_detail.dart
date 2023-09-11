
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kliknss77/application/builders/data_builder.dart';
import 'package:kliknss77/application/builders/header_builder.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/infrastructure/database/data_state.dart';
import 'package:kliknss77/ui/component/ahref_component.dart';
import 'package:kliknss77/ui/component/artikel1_component.dart';
import 'package:kliknss77/ui/component/banner_carousel.dart';
import 'package:kliknss77/ui/component/category_icons.dart';
import 'package:kliknss77/ui/component/feature_list.dart';
import 'package:kliknss77/ui/component/hmc/hmc_simulation_agent.dart';
import 'package:kliknss77/ui/component/icon_list.dart';
import 'package:kliknss77/ui/component/icon_refresh_indicator.dart';
import 'package:kliknss77/ui/component/image_component.dart';
import 'package:kliknss77/ui/component/multiguna_view/m2w_footer_view.dart';
import 'package:kliknss77/ui/component/multiguna_view/m2w_simulation.dart';
import 'package:kliknss77/ui/component/testimonial_component.dart';
import 'package:kliknss77/ui/component/text_block_component.dart';
import 'package:kliknss77/ui/component/toc.dart';
import 'package:kliknss77/ui/component/toc_component.dart';
import 'package:kliknss77/ui/component/youtube_player_component.dart';
import 'package:kliknss77/ui/views/motor/hmc_list_view.dart';
import 'package:tailwind_style/tailwind_style.dart';
import '../../../infrastructure/database/shared_prefs.dart';

// ignore: must_be_immutable
class MasterDetail extends StatefulWidget {
  dynamic controller,section,home,url,state,debug;
  void setButtonNavbar(params){
    debug = params;
  }
  MasterDetail({
    Key? key,
    this.section,
    this.state,
    this.controller,
    this.home,
    this.debug,
    this.url
  }) : super(key: key);

  @override
  _MasterDetail createState() => _MasterDetail();
}

class _MasterDetail extends State<MasterDetail>
     {
  
  final Dio _dio = DioService.getInstance();
  final Color _warna = Constants.white;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _flashSalescrollController = ScrollController();
  List? listInfo = [];
  int state = 0;
  
  bool locationDenied = false;
  dynamic login, userId, isAgen;
  Map? buttonNavbar ;
  DataState? dataState ;
  int? debug;
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
      dataState =  DataBuilder((widget.url ?? "")).getDataState();
      print("shimmer widget di master eins ${widget.state}");
    });
  }
  Widget _buildSection(BuildContext context, dynamic section) {
    // MotorAgentView
    switch (section['type'] ?? "") {
      case 'Flex':
        return FlexTW(
          mainClass: section['class'] ?? '',
          bgImage: section['bgImage'] is List ? "${Constants.baseURLImages}${section['bgImage']?[0]?['imageUrl'] ?? ""}" : "",
          children: [
             for (var item in section['items'] ?? [])
            _buildSection(context, item ?? {})
        ]);
        // FlexTailwind(
        //   mainClass: section['class'] ?? '',
        //   bgImage: section['bgImage'] is List ? "${Constants.baseURLImages}${section['bgImage']?[0]?['imageUrl'] ?? ""}" : "",
        //   children: [
        //   for (var item in section['items'] ?? [])
        //     _buildSection(context, item ?? {})
        // ]);

      case 'ToC' :
        return ToC(section: section ?? []);
      // case 'IconList':
      //   return Flexible(
      //     child: IconList(
      //       section: section ?? [],
      //       mainClass: section['class'] ?? '',
      //     ),
      //   );
      // case 'TextBlock':
      //   return TextBlockComponent(section: section ?? []);
      // case 'Article':
      //   return Flexible(child: Article1Component(section: section ?? [],));
      // case 'FeatureList':
        // return Flexible(
        //   // fit: FlexFit.loose,
        //   child: FeatureList(section: section ?? [],));
      // case 'Image':
      //   return ImageCarousel(
      //     section: section,
      //     state: widget.state ?? 1,
      //     aspectRatio: (section['itemRatio'] ?? []).isNotEmpty ? section['itemRatio'][0] :  null,
      //     items: section['src'] ?? [],
      //   );
      // case 'Carousel':
      //   return BannerCarousel(
      //     state: widget.state,
      //     aspectRatio: section['ratio']?[0] ?? 8 / 5.6,
      //     items: section['items'] ?? [],
      // );
      // case 'Ahref':
      //   return Flexible(child: Ahref(section: section ?? {}));

      // case 'EmbeddedVideo':
      //   return Flexible(child: YoutubeVideoPlayer(section: section ?? {}));

      // case 'Testimonial':
      //   return Flexible(
      //     // fit: FlexFit.loose,
      //     child: Testimonial(section: section ?? {}),
      //   );
      
      case 'M2WSimulation':
        return Flexible(
          fit: FlexFit.loose,
          child: ContainerTailwind(
            extClass: section['class'] ?? '',
            child: M2WSimulation(
              url: widget.url ?? "",
            ),
          ),
        );
      // case 'HMCList':
      //   return HMCListView(hmc: section['items']?? [],);
      default:
        return Container();
    }
  }

  Widget _buildFooter(BuildContext context, dynamic section) {
    // MotorAgentView
    switch (section['type']) {
      case 'Flex':
        return 
        
        FlexTailwind(
          mainClass: section['class'] ?? '',
          // bgImage: section['bgImage'] is List ? "${Constants.baseURLImages}${section['bgImage']?[0]?['imageUrl'] ?? ""}" : "",

          children: [
          for (var item in section['items'] ?? [])
            _buildFooter(context, item ?? {})
        ]);
      case 'M2WSimulation':
        return M2WFooterView(
          state: widget.state,
          section: widget.section,
          // page: widget.page,
          // section: widget.section,
        );
      // case 'HMCList':
      //   return HMCListView(hmc: section['items']?? [],);
      default:
        return Container();
    }
  }

  

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
    ));

    return Scaffold(
    
    //
    appBar: AppBar(
    toolbarHeight: 67,
    automaticallyImplyLeading: false,
    backgroundColor: Constants.white,
    flexibleSpace:SizedBox(
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
    ),
    // collection component gabungan 2 folders tanpa didefinisikan
    // Optional
    // Column(children: [
    //   TailwindBuilder(
    //   section : section,
    // ),
    // BuilderSendiri()
    // ],)
    
    // TailwindIconList
    // TailwindFlashsale
    // TailwindTextBlock
    body: CustomRefreshIndicator(
      builder: MaterialIndicatorDelegate(
        builder: (context, controller) {
          return IconRefreshIndicator();
        },
      ),
      onRefresh: () async {
        
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: widget.section != null
            ? ListView.builder(
                padding: const EdgeInsets.all(0),
                addAutomaticKeepAlives: true,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                    (widget.section['components'] ?? []).length,
                itemBuilder: ((context, index) {
                  print("masuk body section");
                  return _buildSection(context, widget.section?['components']?[index]??[]);
                  // BodyBuilder(url: widget.url,section: widget.section?['components']?[index]??[],state: widget.state,);
                }),
              )
            :  Container(),
      ),
    ),
    bottomNavigationBar: SafeArea(
      child: ListView.builder( 
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      itemCount: (widget.section?['components'] ?? []).length ?? 0,
      itemBuilder: ((context, index) {
        // print("masuk footer section");
        // print("widget.section?['components']?[index]??[] ${widget.section?['components']?[index]??[]}");
        return 
        // Container();
        
        _buildFooter(context, widget.section?['components']?[index]??[]);
      }),
    ),
    ) ,
    
  );
  }
}


