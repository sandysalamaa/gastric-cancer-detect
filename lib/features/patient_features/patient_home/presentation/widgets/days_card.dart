import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/constant/styles/styles.dart';

class DayCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  const DayCard({Key? key, required this.text, required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(
          height: 70.h,
          width: 80.w,
          decoration: BoxDecoration(
              color: isSelected ? Colors.green : Colors.white,
              borderRadius: BorderRadius.circular(10.r)),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              softWrap: false,
              style: TextStyles.textViewMedium15
                  .copyWith(color: isSelected ? white : blackColor),
            ),
          ),
        ),
      ),
    );
  }
}

class SelectTrackCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  const SelectTrackCard(
      {Key? key, required this.text, required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Center(
        child: Container(
          width: 100.w,
          decoration: BoxDecoration(
              color: isSelected ? mainColor : Colors.grey,
              borderRadius: BorderRadius.circular(10.r)),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.clip,
              style: TextStyles.textViewMedium15
                  .copyWith(color: isSelected ? white : blackColor),
            ),
          ), //Text
        ),
      ),
    );
  }
}
