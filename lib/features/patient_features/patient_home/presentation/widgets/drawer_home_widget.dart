import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/features/settings/presentation/widgets/drawer_body_widget.dart';

class DrawerHomeWidget extends StatelessWidget {
  const DrawerHomeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      width: 350.w,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), bottomRight: Radius.circular(20))),
      backgroundColor: mainColor,
      child: const DrawerBodyWidget(),
    );
  }
}
