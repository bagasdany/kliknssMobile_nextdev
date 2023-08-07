// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:kliknss77/ui/component/handle_error/maintenance_page.dart';
import 'package:kliknss77/ui/component/handle_error/network_error.dart';
import 'package:kliknss77/ui/component/handle_error/page_lost.dart';
import 'package:kliknss77/ui/shimmer/home_shimmer.dart';


  // case 2 = onNetwork Error
class ErrorBuilder extends StatefulWidget {
  int? state;
  final Function? onSuccess;
  ErrorBuilder(
      {Key? key,
      this.onSuccess,
      this.state,})
      : super(key: key);

  @override
  _ErrorBuilderState createState() => _ErrorBuilderState();
}

class _ErrorBuilderState extends State<ErrorBuilder> {
  @override
  Widget build(BuildContext context) {
    switch (widget.state) {
      // Floating Header
      case 4:
        return NetworkErrorPage(
          onSuccess: widget.onSuccess,
        );
      case 3:
        return const MaintenancePage();
        
     
      default:
        return HomeShimmer(aspectRatio: 8/5.6,);
    }
  }
}
