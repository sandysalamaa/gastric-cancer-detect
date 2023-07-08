import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/constant/styles/styles.dart';
import 'package:gastric_cancer_detection/core/util/api_basehelper.dart';
import 'package:gastric_cancer_detection/core/util/app_navigator.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/app_bar/default_app_bar.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/side_padding/side_padding.dart';

import '../../../../injection_container.dart';
import '../../../../main.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../patient_features/patient_home/presentation/widgets/home_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final local = EasyLocalization.of(context)!.currentLocale!.languageCode;
      if (local == 'ar') {
        groupValue = 'ar';
      } else {
        groupValue = 'en';
      }
    });
  }

  String? groupValue;
  final List<AppLang> listOfLang = [
    AppLang("ar", tr("arabic")),
    AppLang("en", tr("english"))
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: DefaultAppBar(
          title: tr("settings"), context: context, iconColor: white),
      body: SidePadding(
        sidePadding: 20,
        child: FrostedGlassBox(
          theHeight: 300.h,
          theChild: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...listOfLang
                    .map<Widget>((e) => Container(
                          height: 62.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(color: white, width: 1)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Radio(
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.disabled)) {
                                      return white.withOpacity(0.8);
                                    }
                                    return white;
                                  }),
                                  value: e.code,
                                  groupValue: groupValue,
                                  onChanged: (value) {
                                    setState(() {
                                      groupValue = e.code;
                                      EasyLocalization.of(context)!
                                          .setLocale(Locale(groupValue!));
                                      sl<ApiBaseHelper>()
                                          .updateLocalInHeaders(groupValue!);
                                      final user =
                                          context.read<LoginCubit>().baseUser;
                                      if (user == null) {
                                        AppNavigator.popToFrist(
                                            context: context);
                                        return;
                                      }
                                      //     AppNavigator.popToFrist(context: context);
                                      //     if (user.type == UserType.patient) {
                                      AppNavigator.push(
                                          context: context,
                                          screen: const GCDApp());
                                      //     } else {
                                      //      AppNavigator.push(
                                      //          context: context,
                                      //          screen: const DoctorHomeScreen());
                                      //   }
                                      // AppNavigator.pop(context: context);
                                    });
                                  }),
                              Text(e.title,
                                  style: TextStyles.textViewMedium18
                                      .copyWith(color: white)),
                            ],
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppLang {
  final String code;
  final String title;

  AppLang(
    this.code,
    this.title,
  );
}
