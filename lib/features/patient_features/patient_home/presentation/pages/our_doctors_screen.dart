import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/constant/images/images.dart';
import 'package:gastric_cancer_detection/core/constant/styles/styles.dart';
import 'package:gastric_cancer_detection/core/util/app_navigator.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/app_bar/default_app_bar.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/side_padding/side_padding.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/space/space.dart';
import 'package:gastric_cancer_detection/features/auth/model/user.dart';
import 'package:gastric_cancer_detection/features/patient_features/patient_home/presentation/pages/our_doctors_details_screen.dart';
import 'package:gastric_cancer_detection/features/patient_features/patient_home/presentation/widgets/home_card.dart';

import '../../../../../core/widgets/loading.dart';

class OurDoctorsScreen extends StatelessWidget {
  const OurDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: DefaultAppBar(
          title: tr("Our_Doctors"),
          context: context,
          backgroundColor: mainColor,
          iconColor: white),
      body: SidePadding(
        sidePadding: 20,
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData) {
                return const Loading();
              }
              if (snapshot.hasError) {
                return const Center(child: Text('An error Occured !'));
              }
              final List<Doctor> doctorsList = snapshot.data!.docs
                  .where((element) => element.data()['type'] == 'doctor')
                  .map((doc) => Doctor.fromJson(doc.data()))
                  .toList();
              return doctorsList.isEmpty
                  ? Center(
                      child: Text(tr('doctor_list_empty'),
                          style:
                              TextStyles.textViewBold16.copyWith(color: white)),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: doctorsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return OurDoctorCard(doctorModel: doctorsList[index]);
                      });
            }),
      ),
    );
  }
}

class OurDoctorCard extends StatelessWidget {
  final Doctor doctorModel;
  const OurDoctorCard({
    super.key,
    required this.doctorModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          AppNavigator.push(
              context: context,
              screen: OurDotcorsDetailsScreen(doctorModel: doctorModel));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: CachedNetworkImage(
                  imageUrl: doctorModel.image != ''
                      ? doctorModel.image
                      : "https://s3-eu-west-1.amazonaws.com/intercare-web-public/wysiwyg-uploads%2F1569586526901-doctor.jpg",
                  height: 170.h,
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
            const Space(boxWidth: 5),
            Expanded(
              flex: 2,
              child: FrostedGlassBox(
                theHeight: 170.h,
                borderRasius: 5.r,
                theChild: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          '${doctorModel.firstName} ${doctorModel.lastName}',
                          style: TextStyles.textViewUnderlineRegular20
                              .copyWith(color: white),
                        ),
                      ),
                      const Space(boxHeight: 10),
                      Text(
                        "More than 20 years experience",
                        style: TextStyles.textViewBold16.copyWith(color: white),
                      ),
                      const Space(boxHeight: 10),
                      Text(
                        doctorModel.description,
                        maxLines: 3,
                        textAlign: TextAlign.end,
                        style: TextStyles.textViewBold16.copyWith(color: white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
