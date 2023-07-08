import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gastric_cancer_detection/core/constant/styles/styles.dart';
import 'package:gastric_cancer_detection/core/util/app_navigator.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/buttons/master_button/master_button.dart';
import 'package:gastric_cancer_detection/core/widgets/loading.dart';
import 'package:gastric_cancer_detection/features/patient_features/make_appointment/order_model.dart';

class CancelOrderDialog extends StatefulWidget {
  final OrderModel orderModel;
  const CancelOrderDialog({
    super.key,
    required this.orderModel,
  });

  @override
  State<CancelOrderDialog> createState() => _CancelOrderDialogState();
}

class _CancelOrderDialogState extends State<CancelOrderDialog> {
  bool isLoading = false;
  toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.only(top: 30, bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: 80.w,
            child: Text(
              tr("are_you_sure_to_cancel_order"),
              style: TextStyles.textViewMedium20,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          )),
      actions: [
        isLoading
            ? const Loading()
            : Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MasterButton(
                      buttonText: tr("yes"),
                      buttonHeight: 40,
                      buttonWidth: 100.w,
                      onPressed: () async {
                        toggleLoading();
                        final firebaseMessaging = FirebaseMessaging.instance;
                        final patientFcmToken =
                            await firebaseMessaging.getToken();
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.orderModel.patientId)
                            .collection('orders')
                            .doc(widget.orderModel.id)
                            .update({
                          "status": "canceled",
                          "patient_fcm_token": patientFcmToken,
                        });
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.orderModel.doctorId)
                            .collection('orders')
                            .doc(widget.orderModel.id)
                            .delete();

                        toggleLoading();
                        // ignore: use_build_context_synchronously
                        AppNavigator.pop(context: context);
                      },
                    ),
                    MasterButton(
                      buttonText: tr("no"),
                      buttonHeight: 40,
                      buttonWidth: 100.w,
                      onPressed: () {
                        AppNavigator.pop(context: context);
                      },
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
