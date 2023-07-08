import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/constant/dimenssions/size_config.dart';
import 'package:gastric_cancer_detection/core/constant/images/images.dart';
import 'package:gastric_cancer_detection/core/constant/styles/styles.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/app_bar/default_app_bar.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/space/space.dart';
import 'package:gastric_cancer_detection/features/doctor_features/doctor_home/presentation/pages/docter_home_screen.dart';
import 'package:gastric_cancer_detection/features/doctor_features/doctor_home/presentation/widgets/zoom_image.dart';
import 'package:gastric_cancer_detection/features/patient_features/make_appointment/order_model.dart';
import 'package:gastric_cancer_detection/features/patient_features/patient_home/presentation/widgets/home_card.dart';

class PatientDetailsScreen extends StatelessWidget {
  final OrderModel orderModel;
  const PatientDetailsScreen({super.key, required this.orderModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: DefaultAppBar(
          title: tr("patient_details"), context: context, iconColor: white),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: FrostedGlassBox(
          theHeight: SizeConfig.screenHeight,
          borderRasius: 10.r,
          theChild: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "#${orderModel.id}",
                  style: TextStyles.textViewBold16.copyWith(color: white),
                ),
                RowDataWidget(
                  title: tr("patient_name"),
                  value: orderModel.patientName,
                ),
                RowDataWidget(
                  title: tr("appointment_time"),
                  value: "${orderModel.bookingTime} ${orderModel.bookingDate}",
                ),
                const Space(boxHeight: 5),
                Text(
                  "${tr("details")} : ",
                  style: TextStyles.textViewBold16.copyWith(color: white),
                ),
                const Space(boxHeight: 5),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: white, width: 0.5),
                      borderRadius: BorderRadius.circular(10.r)),
                  child: Text(
                    orderModel.notes,
                    style: TextStyles.textViewRegular17.copyWith(color: white),
                  ),
                ),
                const Space(boxHeight: 20),
                Text(
                  "${tr("xray_image")} : ",
                  style: TextStyles.textViewBold16.copyWith(color: white),
                ),
                const Space(boxHeight: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) {
                        return Scaffold(
                          backgroundColor: mainColor,
                          appBar: DefaultAppBar(
                              title: '', context: context, iconColor: white),
                          body: ZoomableImage(
                            imageUrl: orderModel.image,
                            heroTag: 'xray_image',
                          ),
                        );
                      }),
                    );
                  },
                  child: Hero(
                    tag: 'xray_image',
                    child: CachedNetworkImage(
                        imageUrl: orderModel.image,
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
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
