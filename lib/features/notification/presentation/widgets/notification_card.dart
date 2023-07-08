import 'package:flutter/material.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/constant/styles/styles.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/space/space.dart';

// ignore: must_be_immutable
class NotificationCard extends StatelessWidget {
  final String time;
  final String title;
  final String body;
  const NotificationCard({
    Key? key,
    required this.time,
    required this.title,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.clip,
            style: TextStyles.textViewRegular20.copyWith(color: white),
          ),
          const Space(boxHeight: 10),
          Text(
            body,
            maxLines: 2,
            overflow: TextOverflow.clip,
            style: TextStyles.textViewRegular20.copyWith(color: white),
          ),
          const Space(boxHeight: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                time,
                style: TextStyles.textViewMedium10.copyWith(color: white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
