import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';


class ReferralCodeComponent extends StatefulWidget {
  bool? isChanged;
  final Function(String)? onChangedTextField;
  Color? textColor;

  ReferralCodeComponent({
    Key? key,
    this.isChanged,
    this.onChangedTextField,
    this.textColor,
  }) : super(key: key);

  @override
  State<ReferralCodeComponent> createState() => _ReferralCodeComponentState();
}

class _ReferralCodeComponentState extends State<ReferralCodeComponent> {
  final TextEditingController referralController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: const EdgeInsets.symmetric(horizontal: Constants.spacing4),
      duration: const Duration(milliseconds: 200),
      width: widget.isChanged == true ? 80 : 0,
      curve: Constants.cubicAnimateMediumToFast,
      height: widget.isChanged == true ? 80 : 0,
      decoration: BoxDecoration(
        // color: widget.isChanged == true ? Colors.orange : Colors.blue,
        borderRadius: BorderRadius.all(
          Radius.circular(widget.isChanged == true ? 16 : 0),
        ),
        // border: Border.all(
        //   color: widget.isChanged == true ? Constants.gray : Colors.transparent,
        //   width: 1,
        // ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kode Referral',
                style: TextStyle(
                  fontSize: Constants.fontSizeSm,
                  color: widget.textColor ?? Constants.black,
                )),
            const SizedBox(height: Constants.spacing1),
            TextField(
              controller: referralController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Constants.white,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: Constants.spacing3),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Constants.gray.shade200),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(Constants.spacing3))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Constants.gray.shade200),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(Constants.spacing3)))),
              onChanged: (text) {
                if (widget.onChangedTextField != null) {
                  widget.onChangedTextField!(text);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
