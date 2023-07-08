import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/space/space.dart';
import 'package:readmore/readmore.dart';

import '../../../../../core/constant/styles/styles.dart';

class CancerStagesBody extends StatelessWidget {
  CancerStagesBody({
    super.key,
  });
  final List<String> stages = [
    tr('stage_0'),
    tr('stage_1'),
    tr('stage_2'),
    tr('stage_3'),
    tr('stage_4'),
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: stages.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "${tr("stage")} $index ",
                      style: TextStyles.textViewBold16.copyWith(color: white),
                    ),
                  ),
                  const Space(boxHeight: 10),
                  ReadMoreText(
                    stages[index],
                    style: TextStyles.textViewMedium15.copyWith(color: white),
                    colorClickableText: mainColor,
                    trimMode: TrimMode.Length,
                    trimCollapsedText: tr("readMore"),
                    trimExpandedText: tr("readLess"),
                    moreStyle: TextStyles.textViewMedium15
                        .copyWith(color: Colors.greenAccent),
                    lessStyle: TextStyles.textViewMedium15
                        .copyWith(color: Colors.redAccent),
                  )
                ],
              ),
            ),
          );
        });
  }
}
