import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/util/app_navigator.dart';
import '../../../../../core/widgets/toast.dart';
import '../../../firebase_routes.dart';
import '../../../model/user.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> fRegister({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required UserType type,
  }) async {
    if (!formKey.currentState!.validate()) {
      return;
    } else {
      emit(RegisterLoading());
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (userCredential.user != null) {
          final firebaseM = FirebaseMessaging.instance;
          final fcmToken = await firebaseM.getToken();
          if (type == UserType.patient) {
            final patient = Patient(
              image: "",
              fcmToken: fcmToken!,
              id: userCredential.user!.uid,
              type: type,
              firstName: firstName,
              lastName: lastName,
              email: email,
              phone: phone,
            );
            await FirebaseFirestore.instance
                .doc(FirebaseRoute.userRoute(userCredential.user!.uid))
                .set(patient.toMap());
          } else {
            final doctor = Doctor(
              image: '',
              id: userCredential.user!.uid,
              type: type,
              firstName: firstName,
              fcmToken: fcmToken!,
              lastName: lastName,
              email: email,
              phone: phone,
              education: education!,
              speciality: speciality!,
              description: description!,
              rates: <RateModel>[],
              times: <TimeModel>[],
            );
            await FirebaseFirestore.instance
                .doc(FirebaseRoute.userRoute(userCredential.user!.uid))
                .set(doctor.toMap());
          }

          // ignore: use_build_context_synchronously
          AppNavigator.popToFrist(context: context);
        }
        emit(RegisterSuccess());
      } on FirebaseAuthException catch (e) {
        showToast(e.message);
        emit(RegisterError(
            message: e.message ?? "An error Occured ,please try again later"));
      }
    }
  }

  String? education;
  String? speciality;
  String? description;
}
