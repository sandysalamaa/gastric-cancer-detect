import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/constant/styles/styles.dart';
import 'package:gastric_cancer_detection/core/util/validator.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/app_bar/default_app_bar.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/space/space.dart';
import 'package:gastric_cancer_detection/core/widgets/loading.dart';
import 'package:gastric_cancer_detection/core/widgets/show_snack_bar.dart';
import 'package:gastric_cancer_detection/features/patient_features/patient_home/presentation/cubit/patient_home_cubit.dart';

import '../../../../../core/widgets/comman/buttons/master_button/master_button.dart';
import '../../../../../core/widgets/comman/buttons/master_textfield/master_textfield.dart';
import '../../../../auth/model/user.dart';

// ignore: must_be_immutable
class BookingDoctorScreen extends StatefulWidget {
  final Doctor doctorModel;
  const BookingDoctorScreen({super.key, required this.doctorModel});

  @override
  State<BookingDoctorScreen> createState() => _BookingDoctorScreenState();
}

class _BookingDoctorScreenState extends State<BookingDoctorScreen> {
  TextEditingController messageController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        backgroundColor: mainColor,
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: BlocConsumer<PatientHomeCubit, PatientHomeState>(
            listener: (context, state) {
              if (state is CreateOrderError) {
                showSnackBarError(context: context, message: state.message);
              }
              if (state is CreateOrderSuccess) {
                context.read<PatientHomeCubit>().resetParams();
              }
            },
            builder: (context, state) {
              if (state is CreateOrderLoading) {
                return const LoadingWhite();
              }
              return MasterButton(
                buttonColor: white,
                borderColor: white,
                buttonTextColor: mainColor,
                buttonText: tr("confirm"),
                onPressed: () async {
                  context.read<PatientHomeCubit>().createBookingOrder(
                        context: context,
                        doctorModel: widget.doctorModel,
                        formKey: formKey,
                        notes: messageController.text.trim(),
                      );
                },
              );
            },
          ),
        ),
        appBar: DefaultAppBar(
            title: tr("booking"),
            context: context,
            backgroundColor: mainColor,
            iconColor: white),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Space(boxHeight: 20),
              Text(
                "${tr("المواعيد المتاحة")} : ",
                style: TextStyles.textViewBold20.copyWith(color: white),
              ),
              if (widget.doctorModel.times != null &&
                  widget.doctorModel.times!.isNotEmpty)
                BlocBuilder<PatientHomeCubit, PatientHomeState>(
                  builder: (context, state) {
                    final selectedTime =
                        context.watch<PatientHomeCubit>().selectedTime;
                    return SizedBox(
                      height: 300.h,
                      child: Scrollbar(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: widget.doctorModel.times!
                              .where((element) => !element.isReserved)
                              .toList()
                              .length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                context.read<PatientHomeCubit>().changeTime(
                                    time:
                                        widget.doctorModel.times![index].time);
                                context.read<PatientHomeCubit>().changeDay(
                                    day: widget.doctorModel.times![index].day);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Chip(
                                  backgroundColor: selectedTime ==
                                          widget.doctorModel.times![index].time
                                      ? Colors.green
                                      : white,
                                  label: Text(
                                    "${widget.doctorModel.times![index].time} ${widget.doctorModel.times![index].day}",
                                    style: TextStyles.textViewMedium18.copyWith(
                                        color: selectedTime ==
                                                widget.doctorModel.times![index]
                                                    .time
                                            ? white
                                            : blackColor),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              // const Space(boxHeight: 10),
              // Text(
              //   "${tr("الايام المتاحة")} : ",
              //   style: TextStyles.textViewBold20.copyWith(color: white),
              // ),
              // const Space(boxHeight: 20),
              // if (widget.doctorModel.times != null &&
              //     widget.doctorModel.times!.isNotEmpty)
              //   BlocBuilder<PatientHomeCubit, PatientHomeState>(
              //     builder: (context, state) {
              //       final selectedDay =
              //           context.watch<PatientHomeCubit>().selectedDay;
              //       return SizedBox(
              //           height: 62.h,
              //           child: ListView.builder(
              //             scrollDirection: Axis.horizontal,
              //             physics: const BouncingScrollPhysics(),
              //             itemCount: widget.doctorModel.times!.length,
              //             itemBuilder: (context, index) => Padding(
              //                 padding:
              //                     const EdgeInsets.symmetric(horizontal: 5),
              //                 child: InkWell(
              //                   onTap: () {

              //                   },
              //                   child: DayCard(
              //                     text: widget.doctorModel.times![index].day,
              //                     isSelected: selectedDay ==
              //                         widget.doctorModel.times![index].day,
              //                   ),
              //                 )),
              //           ));
              //     },
              //   ),
              // const Space(boxHeight: 20),
              const Space(boxHeight: 20),
              MasterTextField(
                fieldHeight: 60,
                borderRadius: 10,
                maxLines: 8,
                minLines: 8,
                textFieldColor: textFieldColor,
                controller: messageController,
                hintText: tr("write_message"),
                keyboardType: TextInputType.text,
                validate: (value) => Validator.defaultValidator(value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
