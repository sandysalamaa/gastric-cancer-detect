import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/constant/dimenssions/size_config.dart';
import 'package:gastric_cancer_detection/core/util/app_navigator.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/buttons/master_button/master_button.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/space/space.dart';
import 'package:gastric_cancer_detection/features/settings/presentation/pages/role_screen.dart';

import '../../../../core/constant/styles/styles.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/intro2.jpg'),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: mainColor.withOpacity(0.7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Space(boxHeight: SizeConfig.screenHeight / 3.5),
                const Center(
                  child: Text(
                    'Welcome To ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const LogoTextWidget(),
                const Space(boxHeight: 40),
                Center(
                  child: Text(
                    'Helping Your stay happy one ',
                    textAlign: TextAlign.center,
                    style: TextStyles.textViewBold23.copyWith(color: white),
                  ),
                ),
                const Space(boxHeight: 20),
                Center(
                  child: Text(
                    "Everyday we bring hope and smile \n to the patient we serve ",
                    textAlign: TextAlign.center,
                    style: TextStyles.textViewBold18
                        .copyWith(color: white.withOpacity(0.5)),
                  ),
                ),
                const Spacer(),
                MasterButton(
                  buttonText: tr("skip"),
                  buttonRadius: 50.r,
                  borderColor: white,
                  buttonTextColor: mainColor,
                  buttonColor: white,
                  buttonWidth: 180.w,
                  onPressed: () {
                    AppNavigator.push(
                        context: context, screen: const RoleScreen());
                  },
                ),
                const Space(boxHeight: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LogoTextWidget extends StatelessWidget {
  const LogoTextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'D',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: mainColor,
          ),
        ),
        Text(
          'C',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: mainColor.withOpacity(0.4),
          ),
        ),
        const Text(
          'G',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: white,
          ),
        ),
      ],
    );
  }
}
