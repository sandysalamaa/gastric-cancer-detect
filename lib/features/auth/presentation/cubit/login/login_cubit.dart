import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastric_cancer_detection/core/widgets/toast.dart';
import 'package:gastric_cancer_detection/features/auth/model/user.dart';

import '../../../../../core/util/app_navigator.dart';
import '../../../firebase_routes.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  BaseUser? _baseUser;
  set setbaseUser(BaseUser user) {
    _baseUser = user;
  }

  BaseUser? get baseUser => _baseUser;

  Patient? _patient;
  Patient get patient => _patient!;

  Future<void> fLogin({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String email,
    required String password,
    required UserType userType,
  }) async {
    if (!formKey.currentState!.validate()) {
      return;
    } else {
      emit(LoginLoading());
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (userCredential.user != null) {
          final user = await FirebaseFirestore.instance
              .doc(FirebaseRoute.userRoute(userCredential.user!.uid))
              .get();
          if (userType == UserType.patient) {
            if (user.data()!['type'] != "patient") {
              await FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              AppNavigator.popToFrist(context: context);
              showToast(tr('type_is_invalid'));
              emit(LoginSuccess(user: userCredential.user!));
              return;
            }
          }
          if (userType == UserType.doctor) {
            if (user.data()!['type'] != "doctor") {
              await FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              AppNavigator.popToFrist(context: context);
              emit(LoginSuccess(user: userCredential.user!));
              return;
            }
          }
        }
        emit(LoginSuccess(user: userCredential.user!));
        // ignore: use_build_context_synchronously
        AppNavigator.popToFrist(context: context);
      } on FirebaseAuthException catch (e) {
        emit(LoginError(
            message: e.message ?? "An error Occured ,please try again later"));
      }
    }
  }
}
