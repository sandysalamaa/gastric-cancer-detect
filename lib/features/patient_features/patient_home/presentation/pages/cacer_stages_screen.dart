import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/app_bar/default_app_bar.dart';
import 'package:gastric_cancer_detection/features/patient_features/patient_home/presentation/widgets/patient_home_body_widget.dart';

import '../../../../../core/constant/styles/styles.dart';

class CancerStagesScreen extends StatelessWidget {
  const CancerStagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: DefaultAppBar(
          title: tr(
            "Cancer_Stages",
          ),
          iconColor: white,
          context: context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(tr('cancer_specs'),
                  style: TextStyles.textViewMedium15.copyWith(color: white)),
            ),
            const SizedBox(height: 10),
            CancerStagesBody(),
          ],
        ),
      ),
    );
  }
}
