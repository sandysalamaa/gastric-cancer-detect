import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/constant/styles/styles.dart';
import 'package:gastric_cancer_detection/core/firebase/auth_stream.dart';
import 'package:gastric_cancer_detection/core/util/app_navigator.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/buttons/master_button/master_button.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/side_padding/side_padding.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/space/space.dart';
import 'package:gastric_cancer_detection/features/doctor_features/doctor_home/presentation/pages/patient_details_screen.dart';
import 'package:gastric_cancer_detection/features/patient_features/patient_home/presentation/widgets/home_card.dart';

import '../../../../../core/remote/fcm_remote_datasource.dart';
import '../../../../../core/widgets/loading.dart';
import '../../../../chat/domain/entities/order_user.dart';
import '../../../../chat/presentation/pages/chat_page.dart';
import '../../../../patient_features/make_appointment/order_model.dart';
import '../../../../patient_features/patient_home/presentation/widgets/drawer_home_widget.dart';
import '../../../../patient_features/patient_home/presentation/widgets/home_appbar.dart';
import 'add_report_screen.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: HomeAppBar(context, false),
      endDrawer: const DrawerHomeWidget(),
      body: SidePadding(
        sidePadding: 20,
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(currentFirebaseUser()!.uid)
                .collection('orders')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData) {
                return const Loading();
              }
              if (snapshot.hasError) {
                return const Center(child: Text('An error Occured !'));
              }
              final List<OrderModel> tempOrderList = snapshot.data!.docs
                  .map((doc) =>
                      OrderModel.fromJson(doc.data() as Map<String, dynamic>))
                  .toList();
              // final orderList = tempOrderList
              //     .where((element) => element.status == 'pending')
              //     .toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr("requests"),
                    style: TextStyles.textViewBold20.copyWith(color: white),
                  ),
                  const Space(boxHeight: 20),
                  tempOrderList.isEmpty
                      ? Center(
                          child: Padding(
                          padding: const EdgeInsets.only(top: 120.0),
                          child: Text(tr('no_order_list'),
                              style: TextStyles.textViewBold20
                                  .copyWith(color: white)),
                        ))
                      : Expanded(
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: tempOrderList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: GestureDetector(
                                      onTap: () {
                                        AppNavigator.push(
                                            context: context,
                                            screen: PatientDetailsScreen(
                                                orderModel:
                                                    tempOrderList[index]));
                                      },
                                      child: AcceptAndRefuesdCard(
                                          orderModel: tempOrderList[index])),
                                );
                              }),
                        ),
                ],
              );
            }),
      ),
    );
  }
}

class AcceptAndRefuesdCard extends StatefulWidget {
  final OrderModel orderModel;

  const AcceptAndRefuesdCard({
    super.key,
    required this.orderModel,
  });

  @override
  State<AcceptAndRefuesdCard> createState() => _AcceptAndRefuesdCardState();
}

class _AcceptAndRefuesdCardState extends State<AcceptAndRefuesdCard> {
  bool isLoading = false;
  toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FrostedGlassBox(
        theHeight: 200.h,
        borderRasius: 10.r,
        theChild: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "#${widget.orderModel.id}",
                style: TextStyles.textViewBold16.copyWith(color: white),
              ),
              RowDataWidget(
                title: tr("patient_name"),
                value: widget.orderModel.patientName,
              ),
              RowDataWidget(
                title: tr("appointment_time"),
                value:
                    '${widget.orderModel.bookingDate} ${widget.orderModel.bookingTime}',
              ),
              const Spacer(),
              if (widget.orderModel.status == 'pending')
                SidePadding(
                  sidePadding: 10,
                  child: isLoading
                      ? const LoadingWhite()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MasterButton(
                              buttonText: tr("accept"),
                              buttonRadius: 15.r,
                              borderColor: white,
                              buttonColor: white,
                              buttonTextColor: mainColor,
                              onPressed: () async {
                                toggleLoading();
                                final firebaseMessaging =
                                    FirebaseMessaging.instance;
                                final doctorFcmToken =
                                    await firebaseMessaging.getToken();
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.orderModel.patientId)
                                    .collection('orders')
                                    .doc(widget.orderModel.id)
                                    .update({
                                  "status": "current",
                                  "doctor_fcm_token": doctorFcmToken
                                });
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(currentFirebaseUser()!.uid)
                                    .collection('orders')
                                    .doc(widget.orderModel.id)
                                    .update({
                                  "status": "current",
                                  "doctor_fcm_token": doctorFcmToken
                                });
                                await FCMRemoteDataSource.sendFCM(
                                  toFCM: widget.orderModel.patientFcmToken,
                                  title: 'New Order status',
                                  body:
                                      'Doctor : ${widget.orderModel.doctorName} has Accepted your request',
                                  reciverId: widget.orderModel.patientId,
                                );
                                toggleLoading();
                              },
                              buttonHeight: 35.h,
                              buttonWidth: 100.w,
                            ),
                            MasterButton(
                              buttonText: tr("refused"),
                              onPressed: () async {
                                toggleLoading();
                                final firebaseMessaging =
                                    FirebaseMessaging.instance;
                                final doctorFcmToken =
                                    await firebaseMessaging.getToken();
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.orderModel.patientId)
                                    .collection('orders')
                                    .doc(widget.orderModel.id)
                                    .update({
                                  "status": "rejected",
                                  "doctor_fcm_token": doctorFcmToken
                                });
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(currentFirebaseUser()!.uid)
                                    .collection('orders')
                                    .doc(widget.orderModel.id)
                                    .delete();
                                await FCMRemoteDataSource.sendFCM(
                                  toFCM: widget.orderModel.patientFcmToken,
                                  title: 'New Order status',
                                  body:
                                      'Doctor : ${widget.orderModel.doctorName} has rejected your request',
                                  reciverId: widget.orderModel.patientId,
                                );
                                toggleLoading();
                              },
                              buttonRadius: 15.r,
                              borderColor: white,
                              buttonColor: white,
                              buttonTextColor: mainColor,
                              buttonHeight: 35.h,
                              buttonWidth: 100.w,
                            )
                          ],
                        ),
                ),
              if (widget.orderModel.status == 'current')
                SidePadding(
                  sidePadding: 10,
                  child: isLoading
                      ? const LoadingWhite()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MasterButton(
                              buttonText: tr("chat"),
                              buttonRadius: 15.r,
                              borderColor: white,
                              buttonColor: white,
                              buttonTextColor: mainColor,
                              onPressed: () {
                                AppNavigator.push(
                                    context: context,
                                    screen: ChatPage(
                                      user2: ChatUser(
                                        fcmToken:
                                            widget.orderModel.patientFcmToken,
                                        id: widget.orderModel.patientId,
                                        image:
                                            "https://journal.ahima.org/Portals/0/EasyDNNNews/2216/1000360c383EDNmainDiesing-July-Feature.jpg",
                                        username: widget.orderModel.patientName,
                                      ),
                                      user1: ChatUser(
                                        fcmToken:
                                            widget.orderModel.doctorFcmToken,
                                        id: widget.orderModel.doctorId,
                                        image:
                                            "https://s3-eu-west-1.amazonaws.com/intercare-web-public/wysiwyg-uploads%2F1569586526901-doctor.jpg",
                                        username: widget.orderModel.doctorName,
                                      ),
                                    ));
                              },
                              buttonHeight: 35.h,
                              buttonWidth: 100.w,
                            ),
                            MasterButton(
                              buttonText: tr("report"),
                              onPressed: () {
                                AppNavigator.push(
                                    context: context,
                                    screen: AddReportScreen(
                                      orderModel: widget.orderModel,
                                    ));
                              },
                              buttonRadius: 15.r,
                              borderColor: white,
                              buttonColor: white,
                              buttonTextColor: mainColor,
                              buttonHeight: 35.h,
                              buttonWidth: 100.w,
                            )
                          ],
                        ),
                ),
            ],
          ),
        ));
  }
}

class RowDataWidget extends StatelessWidget {
  final String title;
  final String value;
  const RowDataWidget({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            "$title : ",
            style: TextStyles.textViewMedium18.copyWith(color: white),
          ),
          Text(
            value,
            maxLines: 1,
            style: TextStyles.textViewMedium15.copyWith(color: white),
          ),
        ],
      ),
    );
  }
}
