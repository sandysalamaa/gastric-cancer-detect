import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/app_bar/default_app_bar.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/side_padding/side_padding.dart';
import 'package:gastric_cancer_detection/core/widgets/pick_image.dart';
import 'package:gastric_cancer_detection/features/auth/model/user.dart';
import 'package:gastric_cancer_detection/features/patient_features/make_appointment/presentation/pages/booking_doctor_screen.dart';
import 'package:gastric_cancer_detection/features/patient_features/patient_home/presentation/cubit/patient_home_cubit.dart';
import 'package:gastric_cancer_detection/features/patient_features/patient_home/presentation/widgets/home_card.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/constant/dimenssions/size_config.dart';
import '../../../../../core/constant/images/images.dart';
import '../../../../../core/constant/styles/styles.dart';
import '../../../../../core/util/app_navigator.dart';
import '../../../../../core/widgets/comman/buttons/master_button/master_button.dart';
import '../../../../../core/widgets/comman/space/space.dart';

class UploadScanScrren extends StatelessWidget {
  final Doctor doctorModel;
  const UploadScanScrren({super.key, required this.doctorModel});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<PatientHomeCubit>();
    return Scaffold(
      backgroundColor: mainColor,
      appBar: DefaultAppBar(title: "", context: context, iconColor: white),
      body: Stack(
        children: [
          Image.asset(
            uploadImage,
            fit: BoxFit.fill,
            width: double.infinity,
          ),
          SidePadding(
            sidePadding: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (cubit.image != null)
                  Text(
                    "${tr("Upload Your Scan here ")} ",
                    style: TextStyles.textViewBold25.copyWith(color: white),
                  ),
                const Space(boxHeight: 50),
                FrostedGlassBox(
                    borderRasius: 10.r,
                    theHeight: 200.h,
                    theChild: cubit.image == null
                        ? Center(
                            child: Text("${tr("Upload Your Scan here ")} ",
                                style: TextStyles.textViewBold25
                                    .copyWith(color: white)))
                        : Image(
                            fit: BoxFit.cover,
                            width: SizeConfig.screenWidth,
                            image: FileImage(
                              cubit.image!,
                            ),
                          )),
                const Space(boxHeight: 50),
                FrostedGlassBox(
                  borderRasius: 10.r,
                  theWidth: 100.w,
                  theHeight: 50.h,
                  theChild: Center(
                    child: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return GetImageFromGallery(
                                cameraOnTap: () {
                                  cubit.getImage(
                                    context,
                                    ImageSource.camera,
                                  );
                                  Navigator.pop(context);
                                },
                                galleryOnTap: () {
                                  cubit.getImage(
                                    context,
                                    ImageSource.gallery,
                                  );
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.add,
                          color: white,
                        )),
                  ),
                ),
                const Spacer(),
                if (cubit.image != null)
                  MasterButton(
                    buttonColor: white,
                    borderColor: white,
                    buttonTextColor: mainColor,
                    buttonText: tr("next"),
                    onPressed: () {
                      AppNavigator.push(
                          context: context,
                          screen:
                              BookingDoctorScreen(doctorModel: doctorModel));
                    },
                  ),
                const Space(boxHeight: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
