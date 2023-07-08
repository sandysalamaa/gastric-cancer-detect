import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/constant/images/images.dart';
import 'package:gastric_cancer_detection/core/constant/styles/styles.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/app_bar/default_app_bar.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/side_padding/side_padding.dart';

class WhoUsScreen extends StatelessWidget {
  const WhoUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: DefaultAppBar(
          title: tr("who_are_you"), context: context, iconColor: white),
      body: Stack(
        children: [
          SvgPicture.asset(whoUsSvg, width: double.infinity, fit: BoxFit.fill),
          SingleChildScrollView(
            child: SidePadding(
              sidePadding: 20,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(tr('who_are_content'),
                    style: TextStyles.textViewMedium18.copyWith(color: white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
