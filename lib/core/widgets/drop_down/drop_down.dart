import 'package:flutter/material.dart';

import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/constant/styles/styles.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/side_padding/side_padding.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/space/space.dart';

class BuildDropDown<T> extends StatelessWidget {
  final double? buttonHeight;
  final double? buttonWidth;
  final Color? textColor;
  final double? buttonRadius;
  final Color? dropdownColor;
  final Color? buildDropColor;
  final Widget? icon;
  final bool? isExpanded;
  final String hint;
  final String? image;
  final dynamic value;
  final dynamic onChange;
  final List<DropdownMenuItem<T>> items;

  const BuildDropDown({
    Key? key,
    this.dropdownColor,
    this.buildDropColor,
    this.textColor,
    this.icon,
    this.buttonHeight,
    this.buttonWidth,
    this.buttonRadius,
    required this.isExpanded,
    required this.hint,
    required this.value,
    required this.onChange,
    required this.items,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: LimitedBox(
        maxHeight: buttonHeight ?? 70,
        child: Container(
          decoration: BoxDecoration(
            color: buildDropColor ?? textFieldColor,
            borderRadius: BorderRadius.circular(buttonRadius ?? 15),
          ),
          child: SidePadding(
            sidePadding: 10,
            child: DropdownButton<T>(
              isExpanded: isExpanded!,
              elevation: 0,
              hint: Row(
                children: [
                  const Space(
                    boxWidth: 10,
                  ),
                  image == null
                      ? const SizedBox()
                      : Image.asset(image!, height: 20, fit: BoxFit.contain),
                  const Space(
                    boxWidth: 5,
                  ),
                  Text(
                    hint,
                    style: TextStyles.textViewRegular20
                        .copyWith(color: textColor ?? mainColor),
                  ),
                ],
              ),
              icon: icon ??
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: mainColor,
                    size: 30,
                  ),
              dropdownColor: dropdownColor ?? white,
              style: TextStyles.textViewMedium15.copyWith(color: mainColor),
              borderRadius: BorderRadius.circular(10),
              value: value,
              onChanged: onChange,
              items: items,
            ),
          ),
        ),
      ),
    );
  }
}
