import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/constant/dimenssions/size_config.dart';
import 'package:gastric_cancer_detection/core/util/app_navigator.dart';
import 'package:gastric_cancer_detection/core/util/validator.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/buttons/master_button/master_button.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/buttons/master_textfield/master_textfield.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/side_padding/side_padding.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/space/space.dart';
import 'package:gastric_cancer_detection/core/widgets/show_snack_bar.dart';
import 'package:gastric_cancer_detection/features/auth/presentation/cubit/register/register_cubit.dart';

import '../../../../core/constant/styles/styles.dart';
import '../../model/user.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {
  final UserType type;
  RegisterScreen({super.key, required this.type});
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Form(
        key: formKey,
        child: SafeArea(
          child: Column(
            children: [
              LoginTextCard(
                text: tr("new_register"),
              ),
              Expanded(
                child: SidePadding(
                  sidePadding: 10,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Space(
                          boxHeight: 55,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: MasterTextField(
                                prefixIcon: Icons.person,
                                hintText: tr("first_name"),
                                keyboardType: TextInputType.text,
                                controller: firstNameController,
                                validate: (value) =>
                                    Validator.defaultValidator(value),
                                onChanged: (String value) {},
                              ),
                            ),
                            const Space(boxWidth: 10),
                            Expanded(
                              child: MasterTextField(
                                prefixIcon: Icons.person,
                                hintText: tr("last_name"),
                                keyboardType: TextInputType.text,
                                controller: lastNameController,
                                validate: (value) =>
                                    Validator.defaultValidator(value),
                                onChanged: (String value) {},
                              ),
                            ),
                          ],
                        ),
                        const Space(
                          boxHeight: 15,
                        ),
                        MasterTextField(
                          prefixIcon: Icons.phone,
                          hintText: tr("phone_number"),
                          keyboardType: TextInputType.number,
                          controller: phoneController,
                          validate: (value) =>
                              Validator.defaultValidator(value),
                        ),
                        const Space(
                          boxHeight: 15,
                        ),
                        MasterTextField(
                          prefixIcon: Icons.email,
                          hintText: tr("email"),
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          validate: (value) => Validator.email(value),
                        ),
                        const Space(boxHeight: 15),
                        MasterTextField(
                          prefixIcon: Icons.calendar_today,
                          borderRadius: 50,
                          hintText: tr("age"),
                          keyboardType: TextInputType.number,
                          controller: ageController,
                          validate: (value) =>
                              Validator.defaultValidator(value),
                          onChanged: (String value) {},
                        ),
                        const Space(boxHeight: 15),
                        if (type == UserType.doctor)
                          Column(
                            children: [
                              MasterTextField(
                                prefixIcon: Icons.folder_special,
                                borderRadius: 50,
                                hintText: tr("speciality"),
                                keyboardType: TextInputType.text,
                                validate: (value) =>
                                    Validator.defaultValidator(value),
                                onChanged: (String value) {
                                  context.read<RegisterCubit>().speciality =
                                      value;
                                },
                              ),
                              const Space(boxHeight: 15),
                              MasterTextField(
                                prefixIcon: Icons.school_outlined,
                                borderRadius: 50,
                                hintText: tr("education"),
                                keyboardType: TextInputType.text,
                                validate: (value) =>
                                    Validator.defaultValidator(value),
                                onChanged: (String value) {
                                  context.read<RegisterCubit>().education =
                                      value;
                                },
                              ),
                              const Space(boxHeight: 15),
                              MasterTextField(
                                prefixIcon: Icons.description,
                                borderRadius: 50,
                                hintText: tr("description"),
                                keyboardType: TextInputType.text,
                                validate: (value) =>
                                    Validator.defaultValidator(value),
                                onChanged: (String value) {
                                  context.read<RegisterCubit>().description =
                                      value;
                                },
                              ),
                              const Space(boxHeight: 15),
                            ],
                          ),
                        MasterTextField(
                          prefixIcon: Icons.lock,
                          borderRadius: 50,
                          hintText: tr("password"),
                          isPassword: true,
                          controller: passwordController,
                          validate: (value) => Validator.password(value),
                          onChanged: (String value) {},
                        ),
                        const Space(
                          boxHeight: 15,
                        ),
                        MasterTextField(
                          prefixIcon: Icons.lock,
                          borderRadius: 50,
                          hintText: tr("confirm_password"),
                          isPassword: true,
                          controller: confirmPasswordController,
                          validate: (value) => Validator.confirmPassword(
                              value, passwordController.text),
                          onChanged: (String value) {},
                        ),
                        const Space(
                          boxHeight: 50,
                        ),
                        Center(
                          child: BlocConsumer<RegisterCubit, RegisterState>(
                            listener: (context, state) {
                              if (state is RegisterError) {
                                showSnackBarError(
                                    context: context, message: state.message);
                              }
                            },
                            builder: (context, state) {
                              if (state is RegisterLoading) {
                                return const Center(
                                    child:
                                        CircularProgressIndicator.adaptive());
                              }
                              return MasterButton(
                                buttonText: tr("register"),
                                onPressed: () {
                                  context.read<RegisterCubit>().fRegister(
                                        context: context,
                                        formKey: formKey,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        firstName: firstNameController.text,
                                        phone: phoneController.text,
                                        lastName: lastNameController.text,
                                        type: type,
                                      );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginTextCard extends StatelessWidget {
  final String text;
  const LoginTextCard({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return EasyLocalization.of(context)!.currentLocale!.languageCode == "ar"
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  AppNavigator.pop(context: context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: mainColor,
                ),
              ),
              const Spacer(),
              Container(
                height: 200.h,
                width: SizeConfig.screenWidth / 1.5,
                decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(110.r),
                    )),
                child: Center(
                  child: Text(
                    text,
                    style: TextStyles.textViewBold25.copyWith(color: white),
                  ),
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  AppNavigator.pop(context: context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: mainColor,
                ),
              ),
              const Spacer(),
              Container(
                height: 200.h,
                width: SizeConfig.screenWidth / 1.5,
                decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(110.r),
                    )),
                child: Center(
                  child: Text(
                    text,
                    style: TextStyles.textViewBold25.copyWith(color: white),
                  ),
                ),
              ),
            ],
          );
  }
}
