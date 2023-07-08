import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/util/app_navigator.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/app_bar/default_app_bar.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/space/space.dart';
import 'package:gastric_cancer_detection/features/chat/domain/entities/order_user.dart';
import 'package:gastric_cancer_detection/features/chat/presentation/pages/chat_page.dart';
import 'package:gastric_cancer_detection/features/doctor_features/doctor_home/presentation/pages/docter_home_screen.dart';
import 'package:gastric_cancer_detection/features/patient_features/make_appointment/order_model.dart';

import '../../../../../core/constant/styles/styles.dart';
import '../../../../../core/firebase/auth_stream.dart';
import '../../../../../core/widgets/loading.dart';
import '../../../patient_home/presentation/widgets/home_card.dart';
import '../widget/cancel_order_dialog.dart';

class MyBookingScreen extends StatefulWidget {
  const MyBookingScreen({Key? key}) : super(key: key);

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  final tabsList = [
    tr("pending"),
    tr("current"),
    tr("canceled"),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: DefaultAppBar(
            title: tr("my_booking"), context: context, iconColor: white),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: TabBar(
                indicatorColor: Colors.grey,
                labelColor: blackColor,
                unselectedLabelColor: white,
                unselectedLabelStyle:
                    TextStyles.textViewMedium18.copyWith(color: mainColor),
                labelStyle:
                    TextStyles.textViewMedium18.copyWith(color: mainColor),
                isScrollable: true,
                indicator: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                tabs: <Widget>[
                  ...List.generate(
                    tabsList.length,
                    (index) {
                      return Container(
                        decoration: BoxDecoration(
                            // color: greyColor,

                            borderRadius: BorderRadius.circular(10.r)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              tabsList[index],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  PendingCard(status: 'pending'),
                  PendingCard(status: 'current'),
                  PendingCard(status: 'canceled'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PendingCard extends StatelessWidget {
  final String status;

  const PendingCard({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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
          final orderList = tempOrderList
              .where((element) => element.status == status)
              .toList();
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: orderList.length,
                itemBuilder: (BuildContext context, int index) {
                  return orderList.isEmpty
                      ? Center(
                          child: Text(tr('order_list_empty'),
                              style: TextStyles.textViewBold16
                                  .copyWith(color: white)),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: FrostedGlassBox(
                            theHeight: 230.h,
                            borderRasius: 10.r,
                            theChild: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text(
                                    "#${orderList[index].id}",
                                    style: TextStyles.textViewBold20
                                        .copyWith(color: white),
                                  ),
                                  const Space(boxHeight: 10),
                                  RowDataWidget(
                                      title: tr("doctor_name"),
                                      value: orderList[index].doctorName),
                                  RowDataWidget(
                                      title: tr("appoint_date"),
                                      value: orderList[index].bookingDate),
                                  RowDataWidget(
                                      title: tr("appoint_time"),
                                      value: orderList[index].bookingTime),
                                  if (orderList[index].status == 'pending')
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => WillPopScope(
                                            onWillPop: () {
                                              return Future.value(false);
                                            },
                                            child: CancelOrderDialog(
                                                orderModel: orderList[index]),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          color: white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                            child: Text(
                                          tr('cancel'),
                                          style: TextStyles.textViewMedium15
                                              .copyWith(color: red),
                                        )),
                                      ),
                                    ),
                                  if (orderList[index].status == 'current')
                                    GestureDetector(
                                      onTap: () {
                                        AppNavigator.push(
                                            context: context,
                                            screen: ChatPage(
                                              user1: ChatUser(
                                                fcmToken: orderList[index]
                                                    .patientFcmToken,
                                                id: orderList[index].patientId,
                                                image:
                                                    "https://journal.ahima.org/Portals/0/EasyDNNNews/2216/1000360c383EDNmainDiesing-July-Feature.jpg",
                                                username: orderList[index]
                                                    .patientName,
                                              ),
                                              user2: ChatUser(
                                                fcmToken: orderList[index]
                                                    .doctorFcmToken,
                                                id: orderList[index].doctorId,
                                                image:
                                                    "https://s3-eu-west-1.amazonaws.com/intercare-web-public/wysiwyg-uploads%2F1569586526901-doctor.jpg",
                                                username:
                                                    orderList[index].doctorName,
                                              ),
                                            ));
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          color: white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                            child: Text(
                                          tr('chat'),
                                          style: TextStyles.textViewMedium15
                                              .copyWith(color: mainColor),
                                        )),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                }),
          );
        });
  }
}
