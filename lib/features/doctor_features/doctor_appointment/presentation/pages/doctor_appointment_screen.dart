import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/constant/styles/styles.dart';
import 'package:gastric_cancer_detection/core/firebase/auth_stream.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/app_bar/default_app_bar.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/buttons/master_button/master_button.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/side_padding/side_padding.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/space/space.dart';
import 'package:gastric_cancer_detection/core/widgets/show_snack_bar.dart';
import 'package:gastric_cancer_detection/features/auth/model/user.dart';
import 'package:gastric_cancer_detection/features/patient_features/patient_home/presentation/widgets/days_card.dart';

import '../../../../../core/widgets/loading.dart';

class DoctorAppointmentScrren extends StatefulWidget {
  const DoctorAppointmentScrren({super.key});

  @override
  State<DoctorAppointmentScrren> createState() =>
      _DoctorAppointmentScrrenState();
}

class _DoctorAppointmentScrrenState extends State<DoctorAppointmentScrren> {
  TimeOfDay? _selectedTime;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 12, minute: 00),
    );
    if (newTime != null) {
      setState(() {
        _selectedTime = newTime;
      });
    }
  }

  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  String? _selecedDay;

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );
    if (newDate != null) {
      setState(() {
        _selectedDate = newDate;
        _selecedDay = DateFormat('EEEE').format(newDate);
      });
    }
  }

  bool isLoading = false;
  toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  List<dynamic>? _timeList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: DefaultAppBar(
        title: tr("doctor_appointment"),
        context: context,
        iconColor: white,
      ),
      body: SidePadding(
        sidePadding: 10,
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentFirebaseUser()!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData) {
                    return const Loading();
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('An error Occured !'));
                  }
                  final List<dynamic> myList = snapshot.data!['times'];
                  final List<TimeModel> timesList = myList
                      .map(
                        (data) => TimeModel(
                          day: data['day'],
                          time: data['time'],
                          date: data['date'],
                          isReserved: data['is_reserved'],
                        ),
                      )
                      .toList();
                  _timeList = myList;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "#1",
                              style: TextStyles.textViewBold20
                                  .copyWith(color: white),
                            ),
                            // const Icon(
                            //   Icons.delete,
                            //   color: white,
                            // )
                          ],
                        ),
                        const Space(boxHeight: 10),
                        Text(
                          "${tr("times")} : ",
                          style:
                              TextStyles.textViewBold20.copyWith(color: white),
                        ),
                        SizedBox(
                          height: 400.h,
                          child: Scrollbar(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: timesList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Chip(
                                    label: Text(
                                      "${timesList[index].time} ${timesList[index].day}",
                                      style: TextStyles.textViewMedium18
                                          .copyWith(color: blackColor),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        // const SizedBox(height: 10),
                        // Text(
                        //   "${tr("days")} : ",
                        //   style: TextStyles.textViewBold20
                        //       .copyWith(color: white),
                        // ),
                        // SizedBox(
                        //     height: 60.h,
                        //     child: ListView.builder(
                        //       scrollDirection: Axis.horizontal,
                        //       physics: const BouncingScrollPhysics(),
                        //       itemCount: timesList.length,
                        //       itemBuilder: (context, index) => Padding(
                        //           padding: const EdgeInsets.symmetric(
                        //               horizontal: 5),
                        //           child: DayCard(
                        //             text: timesList[index].day,
                        //             isSelected: false,
                        //           )),
                        //     ))
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _selectTime(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${tr('time')} : ',
                        style: TextStyles.textViewBold20.copyWith(color: white),
                      ),
                      Text(
                        _selectedTime == null
                            ? "00:00 AM"
                            : "${_selectedTime!.hour < 10 ? "0${_selectedTime!.hour}" : _selectedTime!.hour}:${_selectedTime!.minute < 10 ? "0${_selectedTime!.minute}" : _selectedTime!.minute}",
                        style: TextStyles.textViewBold20.copyWith(color: white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Row(
                      children: [
                        Text(
                          "${tr('date')} : ",
                          style:
                              TextStyles.textViewBold20.copyWith(color: white),
                        ),
                        if (_selectedDate != null)
                          Text(
                            '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                            style: TextStyles.textViewBold20
                                .copyWith(color: white),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
                height: 60.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: daysOfWeek.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: DayCard(
                      text: daysOfWeek[index],
                      isSelected: _selecedDay == daysOfWeek[index],
                    ),
                  ),
                )),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation<Color>(white)))
                : MasterButton(
                    buttonText: tr("add"),
                    onPressed: () async {
                      if (_selectedTime == null) {
                        showSnackBarError(
                            context: context,
                            message: tr('selected_time_required'));
                        return;
                      }
                      if (_selecedDay == null) {
                        showSnackBarError(
                            context: context,
                            message: tr('selected_day_required'));
                        return;
                      }
                      if (_selectedDate == null) {
                        showSnackBarError(
                            context: context,
                            message: tr('selected_date_required'));
                        return;
                      }
                      toggleLoading();
                      TimeModel timeModel = TimeModel(
                        time:
                            "${_selectedTime!.hour}:${_selectedTime!.minute} ",
                        date:
                            "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                        day: _selecedDay!,
                        isReserved: false,
                      );
                      _timeList!.add(timeModel.toJson());
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentFirebaseUser()!.uid)
                          .update({"times": _timeList}).whenComplete(() {
                        setState(() {
                          _selecedDay = null;
                          _selectedDate = null;
                          _selectedTime = null;
                        });
                      });
                      toggleLoading();
                    },
                    borderColor: white,
                    buttonColor: white,
                    buttonRadius: 10.r,
                    buttonTextColor: mainColor,
                  ),
          ],
        ),
      ),
    );
  }
}
