import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kliknss77/application/style/constants.dart';

enum ButtonType { primary, secondary, minimal }

enum ButtonState { normal, disabled, loading }

class Button extends StatelessWidget {
  String? text;
  IconData? icon;
  String? iconSvg;
  VoidCallback? onPressed;
  double fontSize;
  ButtonType type; // primary|secondary|minimal, default: primary
  ButtonState state; // 1:normal|2:loading, default: 1

  Color? foregroundColor;
  Color? foregroundDisabledColor;
  Color? spinnerColor;
  Color? backgroundColor;
  Color? backgroundPressedColor;
  Color? borderColor;

  double? textHeight;
  double? textWidth;
  double? spinnerHeight;

  Button(
      {Key? key,
      this.text,
      this.icon,
      this.iconSvg,
      this.onPressed,
      this.fontSize = Constants.fontSizeMd,
      this.type = ButtonType.primary,
      this.state = ButtonState.normal})
      : super(key: key) {
    TextPainter textPainter = TextPainter()
      ..text = TextSpan(text: text, style: TextStyle(fontSize: fontSize))
      ..textDirection = TextDirection.ltr
      ..layout(minWidth: 0, maxWidth: double.infinity);

    textHeight = textPainter.size.height;
    textWidth = textPainter.size.width;
    spinnerHeight = (textHeight ?? 1) * .8;

    foregroundColor = type == ButtonType.primary
        ? Colors.white
        : (type == ButtonType.secondary
            ? Constants.gray.shade800
            : Constants.gray.shade800);

    foregroundDisabledColor = type == ButtonType.primary
        ? Constants.primaryColor.shade200
        : (type == ButtonType.secondary ? Constants.gray : Constants.gray);

    spinnerColor = type == ButtonType.primary
        ? Colors.white
        : (type == ButtonType.secondary
            ? Constants.gray.shade400
            : Constants.gray.shade400);

    backgroundPressedColor = type == ButtonType.primary
        ? Constants.primaryColor.shade600
        : (type == ButtonType.secondary
            ? Constants.gray.shade100
            : Constants.gray.shade200);

    backgroundColor = type == ButtonType.primary
        ? Constants.primaryColor
        : (type == ButtonType.secondary
            ? Constants.gray.shade200
            : Colors.transparent);

    borderColor = type == ButtonType.primary
        ? Constants.primaryColor.shade600
        : (type == ButtonType.secondary
            ? Constants.gray.shade300
            : Constants.gray.shade200);
  }

  Widget buildLoading(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: SizedBox(
              width: spinnerHeight,
              height: spinnerHeight,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: spinnerColor,
              ),
            ),
          )
        ]);
  }

  Widget buildText() {
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: fontSize),
          text != null
              ? const SizedBox(width: Constants.spacing2)
              : Container(),
          text != null
              ? Flexible(
                  child: Text(text ?? '',
                      style: TextStyle(
                          fontSize: fontSize,
                          overflow: TextOverflow.ellipsis,
                          fontFamily: Constants.primaryFontBold)))
              : Container()
        ],
      );
    } else if (iconSvg != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(iconSvg!,
              width: textHeight,
              height: textHeight,
              color: state == ButtonState.disabled
                  ? foregroundDisabledColor
                  : foregroundColor),
          text != null
              ? const SizedBox(width: Constants.spacing2)
              : Container(),
          text != null
              ? Flexible(
                  child: Text(text ?? '',
                      style: TextStyle(
                          fontSize: fontSize,
                          overflow: TextOverflow.ellipsis,
                          fontFamily: Constants.primaryFontBold)))
              : Container()
        ],
      );
    } else {
      return Text(text ?? '',
          style: TextStyle(
              fontSize: fontSize, fontFamily: Constants.primaryFontBold));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
        opacity: state == ButtonState.disabled ? .4 : 1,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(Size(
                    ((textWidth ?? 0) + (Constants.spacing3 * 4)).toDouble(),
                    ((textHeight ?? 0) + (Constants.spacing3 * 2)).toDouble())),
                padding: MaterialStateProperty.all(
                    const EdgeInsets.all(Constants.spacing3)),
                elevation: MaterialStateProperty.all(0),
                splashFactory: NoSplash.splashFactory,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return state == ButtonState.normal
                          ? backgroundPressedColor!
                          : backgroundColor!;
                    }
                    return backgroundColor!; // Use the component's default.
                  },
                ),
                foregroundColor: MaterialStateProperty.all(
                    state == ButtonState.normal
                        ? foregroundColor
                        : foregroundDisabledColor),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(
                        Radius.circular(Constants.spacing4)),
                    side: BorderSide(color: borderColor!)))),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: state == ButtonState.loading ? 0 : 1,
                  child: buildText(),
                ),
                state == ButtonState.loading
                    ? Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: buildLoading(context),
                        ),
                      )
                    : Container()
              ],
            )));
  }
}
