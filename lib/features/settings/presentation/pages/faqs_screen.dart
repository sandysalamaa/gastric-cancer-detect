import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/constant/styles/styles.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/app_bar/default_app_bar.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/side_padding/side_padding.dart';

import '../../../../core/constant/images/images.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: DefaultAppBar(
          title: tr("faqs_title"), context: context, iconColor: white),
      body: Stack(
        children: [
          Image.asset(lifeStyleImage, width: double.infinity, fit: BoxFit.fill),
          SingleChildScrollView(
            child: SidePadding(
              sidePadding: 20,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(tr('faqs_content'),
                    style: TextStyles.textViewMedium18.copyWith(color: white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
