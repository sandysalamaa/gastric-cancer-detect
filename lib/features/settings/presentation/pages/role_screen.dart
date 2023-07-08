import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/constant/images/images.dart';
import 'package:gastric_cancer_detection/core/util/app_navigator.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/space/space.dart';
import 'package:gastric_cancer_detection/features/auth/model/user.dart';
import 'package:gastric_cancer_detection/features/auth/presentation/pages/login_screen.dart';
import 'package:gastric_cancer_detection/features/patient_features/patient_home/presentation/pages/patient_home_screen.dart';
import 'package:gastric_cancer_detection/features/settings/presentation/cubit/role/role_cubit.dart';

import '../../../../core/constant/styles/styles.dart';
import '../../../../core/widgets/comman/buttons/master_button/master_button.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({Key? key}) : super(key: key);

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleCubit, RoleState>(builder: (context, state) {
      final bloc = RoleCubit.get(context);
      return Scaffold(
        backgroundColor: mainColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            children: [
              Image.asset(
                logoImage,
                width: 220.w,
                height: 220.h,
              ),
              const Space(
                boxHeight: 40,
              ),
              Text(
                tr("register_new_account"),
                style: TextStyles.textViewBold25.copyWith(color: white),
              ),
              const Space(
                boxHeight: 20,
              ),
              InkWell(
                onTap: () {
                  bloc.fUpdateRoleValue(registerType: RegisterType.patient);
                },
                child: Material(
                  borderRadius: BorderRadius.circular(50.r),
                  elevation: 2,
                  color: white,
                  shadowColor: lightMainColor,
                  child: Container(
                    height: 80.h,
                    padding: const EdgeInsets.all(1),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.r),
                      border: Border.all(
                          color: bloc.roleValue == "patient"
                              ? white
                              : whiteOpacityColor,
                          width: 2.w),
                    ),
                    child: Row(
                      children: [
                        Radio(
                          activeColor: mainColor,
                          value: "patient",
                          groupValue: bloc.roleValue,
                          onChanged: (t) => bloc.fUpdateRoleValue(
                              registerType: RegisterType.patient),
                        ),
                        Text(
                          tr("patient"),
                          style: TextStyles.textViewMedium20
                              .copyWith(color: mainColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Space(
                boxHeight: 20,
              ),
              InkWell(
                onTap: () {
                  bloc.fUpdateRoleValue(registerType: RegisterType.doctor);
                },
                child: Material(
                  borderRadius: BorderRadius.circular(50.r),
                  elevation: 2,
                  color: white,
                  shadowColor: lightMainColor,
                  child: Container(
                    height: 80.h,
                    padding: const EdgeInsets.all(1),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.r),
                      border: Border.all(
                          color: bloc.roleValue == "doctor"
                              ? white
                              : whiteOpacityColor,
                          width: 2.w),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio(
                          activeColor: mainColor,
                          value: "doctor",
                          groupValue: bloc.roleValue,
                          onChanged: (t) => bloc.fUpdateRoleValue(
                              registerType: RegisterType.doctor),
                        ),
                        Text(
                          tr("doctor"),
                          style: TextStyles.textViewMedium20
                              .copyWith(color: mainColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              MasterButton(
                borderColor: white,
                buttonTextColor: mainColor,
                buttonColor: white,
                buttonWidth: 200.w,
                onPressed: () {
                  AppNavigator.push(
                      context: context,
                      screen: LoginScreen(
                        type: bloc.roleValue == 'patient'
                            ? UserType.patient
                            : UserType.doctor,
                      ));
                },
                buttonText: tr("continue"),
              ),
              const SizedBox(height: 10),
              MasterButton(
                borderColor: mainColor,
                buttonTextColor: white,
                buttonColor: mainColor,
                buttonWidth: 200.w,
                onPressed: () {
                  AppNavigator.push(
                      context: context, screen: const PatientHomeScreen());
                },
                buttonText: tr("skip"),
              ),
            ],
          ),
        ),
      );
    });
  }
}
