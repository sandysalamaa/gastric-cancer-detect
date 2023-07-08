import 'package:flutter/material.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/constant/styles/styles.dart';
import 'package:gastric_cancer_detection/core/util/app_navigator.dart';

import '../../../../notification/presentation/pages/notification_screen.dart';

// ignore: non_constant_identifier_names
HomeAppBar(BuildContext context, bool isPatient) {
  return AppBar(
    backgroundColor: mainColor,
    title: Text("GCD", style: TextStyles.textViewBold25.copyWith(color: white)),
    leading: !isPatient
        ? Container()
        : IconButton(
            onPressed: () {
              AppNavigator.push(
                  context: context, screen: const NotificationScreen());
            },
            icon: const Icon(
              Icons.notification_add_rounded,
            ),
          ),
    iconTheme: const IconThemeData(color: white),
    centerTitle: true,
  );
}
