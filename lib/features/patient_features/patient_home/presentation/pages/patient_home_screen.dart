import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/util/app_navigator.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/space/space.dart';
import 'package:gastric_cancer_detection/core/widgets/grid_view_center.dart';
import 'package:gastric_cancer_detection/core/widgets/static_screen.dart';
import 'package:gastric_cancer_detection/features/patient_features/patient_home/presentation/pages/cacer_stages_screen.dart';
import 'package:gastric_cancer_detection/features/patient_features/patient_home/presentation/pages/check_up_screen.dart';
import 'package:gastric_cancer_detection/features/patient_features/patient_home/presentation/pages/our_doctors_screen.dart';
import 'package:gastric_cancer_detection/features/patient_features/patient_home/presentation/widgets/drawer_home_widget.dart';
import 'package:gastric_cancer_detection/features/patient_features/patient_home/presentation/widgets/home_appbar.dart';
import 'package:gastric_cancer_detection/features/settings/presentation/widgets/back_to_login_dialog.dart';

import '../../../../../core/constant/images/images.dart';
import '../../../../../core/constant/styles/styles.dart';
import '../../../../auth/presentation/cubit/login/login_cubit.dart';
import '../widgets/home_card.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  final List<CardItemClass> listCardItem = [
    CardItemClass(
      route: const CancerStagesScreen(),
      title: Text(
        tr("Cancer_Stages"),
        style: TextStyles.textViewBold18.copyWith(color: white),
      ),
    ),
    CardItemClass(
      route: const CheckUpScreen(),
      title: Text(
        tr("Check_Up"),
        style: TextStyles.textViewBold18.copyWith(color: white),
      ),
    ),
    CardItemClass(
      route: const OurDoctorsScreen(),
      title: Text(
        tr("Our_Doctors"),
        style: TextStyles.textViewBold18.copyWith(color: white),
      ),
    ),
    CardItemClass(
      route: StaticScreen(),
      title: Text(
        tr("Recive_Reports"),
        style: TextStyles.textViewBold18.copyWith(color: white),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mainColor,
        appBar: HomeAppBar(context, true),
        endDrawer: const DrawerHomeWidget(),
        body: SafeArea(
          child: Stack(
            children: [
              Image.asset(
                homePageImage,
                fit: BoxFit.fill,
                width: double.infinity,
              ),
              Column(
                children: [
                  const Space(boxHeight: 20),
                  Text(
                    tr('welcome_to'),
                    style: TextStyles.textViewBold40.copyWith(color: white),
                  ),
                  Image.asset(
                    logoImage,
                    height: 150,
                    width: 100,
                    fit: BoxFit.fill,
                  ),
                  Text(
                    tr('help_stay_happy'),
                    style: TextStyles.textViewBold40
                        .copyWith(color: white, fontSize: 25),
                  ),
                  Text(
                    tr('everyday_we_bring_happy'),
                    style: TextStyles.textViewBold40
                        .copyWith(color: white, fontSize: 15),
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCountAndCentralizedLastElement(
                      itemCount: 5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.4,
                      crossAxisCount: 2,
                    ),
                    itemCount: listCardItem.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GestureDetector(
                          onTap: () {
                            final user = context.read<LoginCubit>().baseUser;
                            if (user == null) {
                              if (index == 2 || index == 3) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const BackToLoginDialog();
                                  },
                                );
                                return;
                              } else {
                                AppNavigator.push(
                                    context: context,
                                    screen: listCardItem[index].route);
                              }
                            } else {
                              AppNavigator.push(
                                  context: context,
                                  screen: listCardItem[index].route);
                            }
                          },
                          child: FrostedGlassBox(
                              theHeight: 100.h,
                              theChild: Center(
                                  child: Container(
                                      child: listCardItem[index].title))),
                        ),
                      );
                    },
                  )
                ],
              ),
            ],
          ),
        ));
  }
}

class CardItemClass {
  final Widget route;
  final Widget title;
  CardItemClass({
    required this.route,
    required this.title,
  });
}
