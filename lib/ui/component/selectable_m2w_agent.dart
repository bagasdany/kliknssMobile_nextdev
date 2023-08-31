import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';


class SelectableItemAgent extends StatefulWidget {

  Widget? child;
  bool selected;
  bool disabled;
  AlignmentGeometry? alignment;
  EdgeInsetsGeometry? padding;
  VoidCallback? onTap;

  SelectableItemAgent(this.child, this.selected,this.padding, {Key? key,
    this.alignment = Alignment.center, this.disabled = false,
    
    this.onTap }) : super(key: key);

  @override
  State<SelectableItemAgent> createState() => _SelectableItemAgentState();
}

class _SelectableItemAgentState extends State<SelectableItemAgent> {

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform(
            transform:  Matrix4.skewX(0.2),
            child: Container(
              height: 60,
              alignment: widget.alignment,
              padding: widget.padding,
              
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: widget.selected ? Constants.donker : Constants.donker.shade100,
                border: Border.all(color: widget.disabled ? Constants.gray.shade100 :(widget.selected ? Constants.donker.shade100 : Constants.gray.shade200)),
                // image:  DecorationImage(image: AssetImage('assets/images/bar_tenor.png'),fit: BoxFit.fill,colorFilter: widget.selected ?   ColorFilter.mode(Colors.white.withOpacity(1),BlendMode.dstATop):  ColorFilter.mode(Colors.white.withOpacity(0.6), BlendMode.dstATop),),
                // borderRadius:  BorderRadius.only(
                //           topLeft: widget.selected ? const Radius.circular(30)  :const Radius.circular(60),
                //           topRight:Radius.zero,
                //           bottomLeft: Radius.zero,
                //           bottomRight: widget.selected ? const Radius.circular(30)  :const Radius.circular(60),
                //         ),
              ),
            ),
          ),
          Container(
            alignment: widget.alignment,
            padding: widget.padding,
            // height: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child:  widget.child as Widget,
            ),
          ),

        ],
      ),
    );
  }
}
