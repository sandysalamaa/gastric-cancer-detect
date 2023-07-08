import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gastric_cancer_detection/core/constant/styles/styles.dart';
import 'package:gastric_cancer_detection/core/remote/fcm_remote_datasource.dart';
import 'package:gastric_cancer_detection/core/widgets/loading.dart';
import 'package:gastric_cancer_detection/core/widgets/show_snack_bar.dart';
import 'package:gastric_cancer_detection/features/patient_features/make_appointment/order_model.dart';

import '../../../../../core/constant/colors/colors.dart';
import '../../../../../core/util/validator.dart';
import '../../../../../core/widgets/comman/app_bar/default_app_bar.dart';
import '../../../../../core/widgets/comman/buttons/master_button/master_button.dart';
import '../../../../../core/widgets/comman/buttons/master_textfield/master_textfield.dart';

class AddReportScreen extends StatefulWidget {
  final OrderModel orderModel;
  const AddReportScreen({super.key, required this.orderModel});

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  final titleC = TextEditingController();
  final descriptionC = TextEditingController();
  final hintC = TextEditingController();
  final warningC = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: DefaultAppBar(
          title: tr("report"), context: context, iconColor: white),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                MasterTextField(
                  hintText: tr("title"),
                  keyboardType: TextInputType.text,
                  controller: titleC,
                  validate: (value) => Validator.defaultValidator(value),
                ),
                const SizedBox(height: 10),
                MasterTextField(
                  hintText: tr("hint"),
                  keyboardType: TextInputType.text,
                  controller: hintC,
                  minLines: 4,
                  maxLines: 5,
                  validate: (value) => Validator.defaultValidator(value),
                ),
                const SizedBox(height: 10),
                MasterTextField(
                  hintText: tr("warning"),
                  keyboardType: TextInputType.text,
                  controller: warningC,
                  minLines: 4,
                  maxLines: 5,
                  validate: (value) => Validator.defaultValidator(value),
                ),
                const SizedBox(height: 10),
                MasterTextField(
                  hintText: tr("description"),
                  keyboardType: TextInputType.text,
                  controller: descriptionC,
                  minLines: 6,
                  maxLines: 7,
                  validate: (value) => Validator.defaultValidator(value),
                ),
                const SizedBox(height: 10),
                Center(
                  child: isLoading
                      ? const LoadingWhite()
                      : MasterButton(
                          buttonText: tr("add_report"),
                          buttonStyle: TextStyles.textViewBold16
                              .copyWith(color: mainColor),
                          buttonColor: white,
                          onPressed: () async {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }
                            toggleLoading();
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.orderModel.patientId)
                                .collection('reports')
                                .doc(Random().nextInt(1000000).toString())
                                .set({
                              "title": titleC.text,
                              "hint": hintC.text,
                              "description": descriptionC.text,
                              "warning": warningC.text,
                            }).whenComplete(() async {
                              showSnackBarSuccess(
                                  context: context,
                                  message: tr('report_add_success'));
                              titleC.clear();
                              hintC.clear();
                              descriptionC.clear();
                              warningC.clear();
                              await FCMRemoteDataSource.sendFCM(
                                toFCM: widget.orderModel.patientFcmToken,
                                title: 'New Report',
                                body:
                                    'Doctor : ${widget.orderModel.doctorName} just uploaded a report',
                                reciverId: widget.orderModel.patientId,
                              );
                            });
                            toggleLoading();
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
