import 'dart:io';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastric_cancer_detection/core/util/app_navigator.dart';
import 'package:gastric_cancer_detection/core/widgets/show_snack_bar.dart';
import 'package:gastric_cancer_detection/features/auth/model/user.dart';
import 'package:gastric_cancer_detection/features/patient_features/make_appointment/order_model.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/firebase/auth_stream.dart';
import '../../../../auth/presentation/cubit/login/login_cubit.dart';

part 'patient_home_state.dart';

class PatientHomeCubit extends Cubit<PatientHomeState> {
  PatientHomeCubit() : super(PatientHomeInitial());
  String? selectedTime;
  changeTime({required String time}) {
    if (selectedTime == null) {
      selectedTime = time;
    } else {
      selectedTime = null;
    }
    emit(SelectDayState());
    emit(PatientHomeInitial());
  }

  String? selectedDay;
  changeDay({required String day}) {
    if (selectedDay == null) {
      selectedDay = day;
    } else {
      selectedDay = null;
    }
    emit(SelectDayState());
    emit(PatientHomeInitial());
  }

  /////
  final picker = ImagePicker();
  File? image;
  Future getImage(
    BuildContext context,
    ImageSource imageSource,
  ) async {
    final pickerFile = await picker.pickImage(
      source: imageSource,
      maxHeight: 480,
      maxWidth: 640,
    );
    if (pickerFile != null) {
      image = File(pickerFile.path);
      if (image != null) {
        emit(ImagesChangeStates(image: image!));
        emit(PatientHomeInitial());
      }
    }
  }

  Future<void> createBookingOrder({
    required BuildContext context,
    required Doctor doctorModel,
    required String notes,
    required GlobalKey<FormState> formKey,
  }) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (selectedTime == null) {
      showSnackBarError(
          context: context, message: tr('selected_time_required'));
      return;
    }
    if (selectedDay == null) {
      showSnackBarError(context: context, message: tr('selected_day_required'));
      return;
    }
    emit(CreateOrderLoading());
    final FirebaseStorage storage = FirebaseStorage.instance;
    final Reference ref = storage.ref().child('images/$image');
    final metadata = SettableMetadata(contentType: 'image/jpeg');
    final uploadTask = ref.putFile(image!, metadata);
    final downloadUrl = await uploadTask
        .then((TaskSnapshot snapshot) => snapshot.ref.getDownloadURL());
    // ignore: use_build_context_synchronously
    final currentUser = context.read<LoginCubit>().baseUser;
    final randomId = math.Random().nextInt(10000).toString();
    try {
      final firebaseMessage = FirebaseMessaging.instance;
      final patientFcmToken = await firebaseMessage.getToken();
      final orderModel = OrderModel(
          id: randomId,
          doctorName: '${doctorModel.firstName} ${doctorModel.lastName}',
          patientName: '${currentUser!.firstName} ${currentUser.lastName}',
          doctorId: doctorModel.id,
          patientId: currentUser.id,
          image: downloadUrl,
          status: 'pending',
          bookingDate: selectedDay!,
          bookingTime: selectedTime!,
          notes: notes,
          doctorFcmToken: '',
          patientFcmToken: patientFcmToken!);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentFirebaseUser()!.uid)
          .collection('orders')
          .doc(randomId)
          .set(orderModel.toJson());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(doctorModel.id)
          .collection('orders')
          .doc(randomId)
          .set(orderModel.toJson());
      // await FirebaseFirestore.instance
      //     .collection('orders')
      //     .doc(randomId)
      //     .set(orderModel.toJson());
      // ignore: use_build_context_synchronously
      showSnackBarSuccess(context: context, message: tr('order_add_success'));
      // ignore: use_build_context_synchronously
      AppNavigator.popToFrist(context: context);
      // List<TimeModel> tempList = doctorModel.times!;
      // tempList.removeWhere((element) =>
      //     (element.day == selectedDay && element.date == selectedTime));
      // log(tempList.length.toString());
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(doctorModel.id)
      //     .update({'times': tempList});
      emit(CreateOrderSuccess());
    } on FirebaseException catch (error) {
      emit(CreateOrderError(
          message:
              error.message ?? "An error Occured ,please try again later"));
    }
  }

  resetParams() {
    image = null;
    selectedDay = null;
    selectedTime = null;
    emit(ResetParamsState());
    emit(PatientHomeInitial());
  }
}
