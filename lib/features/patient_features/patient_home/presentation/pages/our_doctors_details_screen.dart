import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/constant/dimenssions/size_config.dart';
import 'package:gastric_cancer_detection/core/constant/images/images.dart';
import 'package:gastric_cancer_detection/core/constant/styles/styles.dart';
import 'package:gastric_cancer_detection/core/util/app_navigator.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/app_bar/default_app_bar.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/space/space.dart';
import 'package:gastric_cancer_detection/features/patient_features/patient_home/presentation/widgets/home_card.dart';

import '../../../../../core/widgets/comman/buttons/master_button/master_button.dart';
import '../../../../../core/widgets/rating_bar.dart';
import '../../../../auth/model/user.dart';
import '../../../make_appointment/presentation/pages/upload_your_scan_screen.dart';

class OurDotcorsDetailsScreen extends StatelessWidget {
  final Doctor doctorModel;
  const OurDotcorsDetailsScreen({
    super.key,
    required this.doctorModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        child: MasterButton(
          buttonColor: white,
          borderColor: white,
          buttonTextColor: mainColor,
          buttonText: tr("booking"),
          onPressed: () {
            AppNavigator.push(
                context: context,
                screen: UploadScanScrren(doctorModel: doctorModel));
          },
        ),
      ),
      appBar: DefaultAppBar(
          title: tr("details"),
          context: context,
          backgroundColor: mainColor,
          iconColor: white),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
                imageUrl:
                    "https://s3-eu-west-1.amazonaws.com/intercare-web-public/wysiwyg-uploads%2F1569586526901-doctor.jpg",
                height: 200.h,
                width: SizeConfig.screenWidth,
                fit: BoxFit.cover,
                placeholder: (context, url) => Image.asset(
                      logoImage,
                      height: 50.h,
                      fit: BoxFit.cover,
                    ),
                errorWidget: (context, url, error) => Image.asset(
                      logoImage,
                      height: 50.h,
                      fit: BoxFit.cover,
                    )),
            const Space(boxHeight: 20),
            Text(
              "${tr("info_about")} : ${doctorModel.firstName} ${doctorModel.lastName}",
              style: TextStyles.textViewBold20.copyWith(color: white),
            ),
            const Space(boxHeight: 20),
            FrostedGlassBox(
              theHeight: 260.h,
              borderRasius: 5.r,
              theChild: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${tr("speciality")} : ",
                          style: TextStyles.textViewMedium18
                              .copyWith(color: white),
                        ),
                        Text(
                          doctorModel.speciality,
                          style: TextStyles.textViewMedium15
                              .copyWith(color: white),
                        ),
                      ],
                    ),
                    const Space(boxHeight: 10),
                    Row(
                      children: [
                        Text(
                          "${tr("education")} : ",
                          style: TextStyles.textViewMedium18
                              .copyWith(color: white),
                        ),
                        Text(
                          doctorModel.education,
                          style: TextStyles.textViewMedium15
                              .copyWith(color: white),
                        ),
                      ],
                    ),
                    const Space(boxHeight: 10),
                    Text(
                      "${tr("experience")} : ",
                      style: TextStyles.textViewMedium18.copyWith(color: white),
                    ),
                    const Space(boxHeight: 5),
                    Text(
                      doctorModel.description,
                      maxLines: 5,
                      style: TextStyles.textViewMedium15.copyWith(color: white),
                    ),
                    const Space(boxHeight: 10),
                  ],
                ),
              ),
            ),
            const Space(boxHeight: 20),
            Text(
              "${tr("reviews")} ",
              style: TextStyles.textViewBold20.copyWith(color: white),
            ),
            const Space(boxHeight: 20),
            if (doctorModel.rates != null && doctorModel.rates!.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  itemCount: doctorModel.rates!.length,
                  itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: FrostedGlassBox(
                        theHeight: 100.h,
                        borderRasius: 10.r,
                        theChild: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(doctorModel
                                        .rates![index].image !=
                                    ''
                                ? doctorModel.rates![index].image
                                : 'https://s3-eu-west-1.amazonaws.com/intercare-web-public/wysiwyg-uploads%2F1569586526901-doctor.jpg'),
                          ),
                          title: Text(
                            doctorModel.rates![index].name,
                            style: TextStyles.textViewBold16
                                .copyWith(color: white),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctorModel.rates![index].comment,
                                softWrap: false,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.textViewRegular16
                                    .copyWith(color: white),
                              ),
                              ratingBar(
                                  value: double.parse(doctorModel
                                      .rates![index].rateCount
                                      .toString()),
                                  color: Colors.yellow),
                            ],
                          ),
                        ),
                      )),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
