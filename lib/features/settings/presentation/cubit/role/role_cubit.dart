import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastric_cancer_detection/core/error/exceptions.dart';
import 'package:gastric_cancer_detection/injection_container.dart';

part 'role_state.dart';

enum RegisterType {
  patient,
  doctor;

  factory RegisterType.fromValue({required String registerType}) {
    if (registerType == "patient") {
      return RegisterType.patient;
    } else if (registerType == "doctor") {
      return RegisterType.doctor;
    } else {
      throw Exception(CacheException);
    }
  }
}

class RoleCubit extends Cubit<RoleState> {
  RoleCubit() : super(RoleInitial());
  static RoleCubit get(BuildContext context) => BlocProvider.of(context);

  String roleValue = "patient";
  fUpdateRoleValue({required RegisterType registerType}) {
    emit(RoleLoading());
    switch (registerType) {
      case RegisterType.patient:
        roleValue = "patient";
        log("patient");
        break;
      case RegisterType.doctor:
        roleValue = 'doctor';
        log("doctor ");
        break;
    }
    emit(RoleInitial());
  }

  changeRole({required RegisterType registerType}) {
    switch (registerType) {
      case RegisterType.patient:
        sharedPreferences.setString('registerType', registerType.name);
        emit(PatientRoleState());
        log("patient");
        break;
      case RegisterType.doctor:
        sharedPreferences.setString('registerType', registerType.name);
        roleValue = "doctor";
        emit(DoctorRoleState());
        log("doctor");
        break;
    }
  }
}
