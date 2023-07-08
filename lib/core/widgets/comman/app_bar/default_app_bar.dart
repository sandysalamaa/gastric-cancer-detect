import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/constant/styles/styles.dart';
import 'package:gastric_cancer_detection/core/util/app_navigator.dart';

// ignore: non_constant_identifier_names
DefaultAppBar(
    {required String title,
    VoidCallback? tap1,
    VoidCallback? tap2,
    String? icon1,
    String? icon2,
    Color? backgroundColor,
    Color? iconColor,
    bool? isbutton = true,
    required BuildContext context,
    // String? actionIcon,
    VoidCallback? backPressed}) {
  return AppBar(
    backgroundColor: backgroundColor ?? transparent,
    elevation: 0.0,
    title: Text(title,
        style: TextStyles.textViewMedium25
            .copyWith(color: iconColor ?? mainColor)),
    leading: IconButton(
      onPressed: backPressed ?? () => AppNavigator.pop(context: context),
      icon: isbutton == true
          ? Icon(
              CupertinoIcons.back,
              color: iconColor ?? mainColor,
            )
          : const SizedBox(),
    ),
    actions: [
      icon1 == null
          ? const SizedBox()
          : IconButton(
              onPressed: tap1,
              icon: Image.asset(
                icon1,
                color: mainColor,
              ),
            ),
      icon2 == null
          ? const SizedBox()
          : IconButton(
              onPressed: tap2,
              icon: Image.asset(icon2),
            ),
    ],
  );
}
