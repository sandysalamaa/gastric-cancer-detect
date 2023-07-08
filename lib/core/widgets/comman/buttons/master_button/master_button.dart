import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/constant/styles/styles.dart';
import '../../side_padding/side_padding.dart';
import '../../space/space.dart';

class MasterButton extends StatelessWidget {
  final Color? buttonColor;
  final Color? borderColor;
  final Color? iconColor;
  final Color? buttonTextColor;

  final double? buttonHeight;
  final double? buttonWidth;
  final double? buttonRadius;
  final double? sidePadding;
  final double? iconSize;
  final String? icon;
  final String buttonText;
  final TextStyle? buttonStyle;
  final VoidCallback? onPressed;
  final String? secIcon;

  const MasterButton({
    Key? key,
    required this.buttonText,
    this.buttonColor,
    this.buttonTextColor,
    this.borderColor,
    this.buttonHeight,
    this.buttonRadius,
    this.buttonWidth,
    this.buttonStyle,
    this.onPressed,
    this.sidePadding,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.secIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SidePadding(
      sidePadding: sidePadding ?? 0,
      child: ElevatedButton(
        onPressed: onPressed,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        style: ElevatedButton.styleFrom(
          foregroundColor: white,
          backgroundColor: buttonColor ?? mainColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: borderColor ?? mainColor,
              width: 2,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(buttonRadius == null ? 50.r : buttonRadius!),
            ),
          ),
        ),
        child: SizedBox(
          height: buttonHeight == null ? 55.h : buttonHeight!,
          width: buttonWidth == null ? 270.w : buttonWidth!,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              secIcon != null
                  ? Image.asset(
                      secIcon!,
                      height: iconSize,
                      color: iconColor,
                    )
                  : const SizedBox(),
              const Space(
                boxWidth: 10,
              ),
              Text(
                buttonText,
                style: buttonStyle ??
                    TextStyles.textViewBold20
                        .copyWith(color: buttonTextColor ?? white),
              ),
              icon != null
                  ? Image.asset(
                      icon!,
                      height: iconSize,
                      color: iconColor,
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
