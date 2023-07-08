import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gastric_cancer_detection/features/settings/presentation/pages/role_screen.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/styles/styles.dart';
import '../../../../core/util/app_navigator.dart';

class BackToLoginDialog extends StatelessWidget {
  const BackToLoginDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tr('please_login_first'), style: TextStyles.textViewBold15),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              AppNavigator.push(context: context, screen: const RoleScreen());
            },
            child: Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                  color: mainColor, borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(tr('back_to_login'),
                    style: TextStyles.textViewBold15.copyWith(color: white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
