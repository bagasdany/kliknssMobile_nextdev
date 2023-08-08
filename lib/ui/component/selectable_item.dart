import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';


class SelectableItem extends StatefulWidget {

  Widget? child;
  bool selected;
  bool disabled;
  AlignmentGeometry? alignment;
  EdgeInsetsGeometry? padding;
  VoidCallback? onTap;

  SelectableItem(this.child, this.selected, {Key? key,
    this.alignment = Alignment.center, this.disabled = false,
    this.padding = const EdgeInsets.all(Constants.spacing3),
    this.onTap }) : super(key: key);

  @override
  State<SelectableItem> createState() => _SelectableItemState();
}

class _SelectableItemState extends State<SelectableItem> {

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: Container(
            alignment: widget.alignment,
            padding: widget.padding,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: widget.selected ? Constants.primaryColor.shade50 : Colors.transparent,
              border: Border.all(color: widget.disabled ? Constants.gray.shade100 :(widget.selected ? Constants.primaryColor : Constants.gray.shade200)),
              borderRadius: const BorderRadius.all(Radius.circular(Constants.spacing3))
            ),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
