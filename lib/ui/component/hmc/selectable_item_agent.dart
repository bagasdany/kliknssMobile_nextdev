import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';


class SelectableItemHmcAgent extends StatefulWidget {

  Widget? child;
  bool selected;
  bool disabled;
  AlignmentGeometry? alignment;
  EdgeInsetsGeometry? padding;
  VoidCallback? onTap;

  SelectableItemHmcAgent(this.child, this.selected, {Key? key,
    this.alignment = Alignment.center, this.disabled = false,
    this.padding = const EdgeInsets.all(Constants.spacing3),
    this.onTap }) : super(key: key);

  @override
  State<SelectableItemHmcAgent> createState() => _SelectableItemHmcAgentState();
}

class _SelectableItemHmcAgentState extends State<SelectableItemHmcAgent> {

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: Transform(
            transform: Matrix4.skewX(0.3),
            child: Container(
              alignment: widget.alignment,
              padding: widget.padding,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: widget.selected ? Constants.donker.shade500 : Constants.donker.shade100,
                border: Border.all(color: widget.disabled ? Constants.gray.shade100 :(widget.selected ? Constants.donker.shade100 : Constants.gray.shade200)),
                // borderRadius: const BorderRadius.all(Radius.circular(Constants.spacing3))
              ),
              child: Transform(
                transform:   Matrix4.skewX(-0.3),
                child: widget.child),
            ),
          ),
        ),
        Visibility(
          visible: false,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              child: widget.child,
            ),
          ),
        )
        // widget.child as Widget,
      ],
      
    );
  }
}
