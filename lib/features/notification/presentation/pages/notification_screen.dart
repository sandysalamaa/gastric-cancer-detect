import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/constant/styles/styles.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/app_bar/default_app_bar.dart';
import 'package:gastric_cancer_detection/features/notification/notifications_model.dart';
import 'package:gastric_cancer_detection/features/patient_features/patient_home/presentation/widgets/home_card.dart';

import '../../../../core/firebase/auth_stream.dart';
import '../../../../core/widgets/comman/side_padding/side_padding.dart';
import '../../../../core/widgets/loading.dart';
import '../widgets/notification_card.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: DefaultAppBar(
          title: tr("notifications"), context: context, iconColor: white),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentFirebaseUser()!.uid)
              .collection('notifications')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return const LoadingWhite();
            }
            if (snapshot.hasError) {
              return const Center(child: Text('An error Occured !'));
            }
            final List<NotificationModel> notificationList = snapshot.data!.docs
                .map((doc) => NotificationModel.fromMap(
                    doc.data() as Map<String, dynamic>))
                .toList();

            return notificationList.isEmpty
                ? Center(
                    child: Text(tr('no_notifications_list'),
                        style:
                            TextStyles.textViewBold18.copyWith(color: white)))
                : SidePadding(
                    sidePadding: 20,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: notificationList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: FrostedGlassBox(
                              borderRasius: 10.r,
                              theHeight: 160.h,
                              theChild: NotificationCard(
                                  time:
                                      "${notificationList[index].createdAt.year}/${notificationList[index].createdAt.month}/${notificationList[index].createdAt.day}",
                                  body: notificationList[index].body,
                                  title: notificationList[index].title),
                            ),
                          );
                        }),
                  );
          }),
    );
  }
}
