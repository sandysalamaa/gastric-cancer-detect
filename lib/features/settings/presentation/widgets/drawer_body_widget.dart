import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/util/app_navigator.dart';
import 'package:gastric_cancer_detection/core/widgets/static_screen.dart';
import 'package:gastric_cancer_detection/features/doctor_features/doctor_appointment/presentation/pages/doctor_appointment_screen.dart';
import 'package:gastric_cancer_detection/features/patient_features/make_appointment/presentation/pages/my_booking_screen.dart';
import 'package:gastric_cancer_detection/features/settings/presentation/pages/faqs_screen.dart';
import 'package:gastric_cancer_detection/features/settings/presentation/pages/profile_screen.dart';
import 'package:gastric_cancer_detection/features/settings/presentation/pages/settings_screen.dart';
import 'package:gastric_cancer_detection/features/settings/presentation/pages/who_us_screen.dart';

import '../../../../../core/constant/styles/styles.dart';
import '../../../../../core/widgets/logout_dialog.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../cubit/role/role_cubit.dart';
import '../pages/contact_us_screen.dart';
import '../pages/web_view_screen.dart';
import 'back_to_login_dialog.dart';

class DrawerBodyWidget extends StatelessWidget {
  const DrawerBodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final roleValue = context.watch<RoleCubit>().roleValue;
    List<ProfileItemClass> profileItems = [
      ProfileItemClass(
        icon: Icons.person,
        route: const ProfileScreen(),
        title: tr("my_profile"),
      ),
      ProfileItemClass(
        icon: Icons.source,
        route: roleValue == "patient"
            ? const MyBookingScreen()
            : const DoctorAppointmentScrren(),
        title: roleValue == "patient"
            ? tr("My_bookings")
            : tr("doctor_appointment"),
      ),
      ProfileItemClass(
        icon: Icons.settings,
        route: const SettingsScreen(),
        title: tr("settings"),
      ),
      ProfileItemClass(
        icon: Icons.scanner,
        route: const WebViewScreen(),
        title: tr("scan_image_using_ai"),
      ),
      ProfileItemClass(
        icon: Icons.article,
        route: const WhoUsScreen(),
        title: tr("who_are_you"),
      ),
      ProfileItemClass(
        icon: Icons.format_quote,
        route: const FaqScreen(),
        title: tr("faqs_title"),
      ),
      ProfileItemClass(
        icon: Icons.contact_phone_outlined,
        route: const ContactUsScreen(),
        title: tr("Contact_Us"),
      ),
      ProfileItemClass(
        icon: Icons.logout,
        route: StaticScreen(),
        title: tr("log_out"),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListTile(
              onTap: index == profileItems.length - 1
                  ? () {
                      final user = context.read<LoginCubit>().baseUser;
                      if (user == null) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const BackToLoginDialog();
                          },
                        );
                        return;
                      }
                      showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) {
                            return const LogoutDialog();
                          });
                    }
                  : () {
                      final user = context.read<LoginCubit>().baseUser;
                      if (user == null) {
                        if (index == 0 || index == 1) {
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
                              screen: profileItems[index].route);
                        }
                      } else {
                        AppNavigator.push(
                            context: context,
                            screen: profileItems[index].route);
                      }
                    },
              leading: Icon(
                profileItems[index].icon,
                color: white,
              ),
              title: Text(profileItems[index].title,
                  style: index != profileItems.length - 1
                      ? TextStyles.textViewMedium18.copyWith(color: white)
                      : TextStyles.textViewMedium22.copyWith(color: white)),
              trailing: index != profileItems.length - 1
                  ? const Icon(
                      Icons.chevron_right,
                      color: white,
                    )
                  : const SizedBox(),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(),
        itemCount: profileItems.length,
      ),
    );
  }
}

class ProfileItemClass {
  final IconData icon;
  final Widget route;
  final String title;
  ProfileItemClass({
    required this.icon,
    required this.route,
    required this.title,
  });
}
