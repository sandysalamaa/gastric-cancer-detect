import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/util/app_navigator.dart';
import 'package:gastric_cancer_detection/core/util/validator.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/buttons/master_button/master_button.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/buttons/master_textfield/master_textfield.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/side_padding/side_padding.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/space/space.dart';
import 'package:gastric_cancer_detection/core/widgets/loading.dart';
import 'package:gastric_cancer_detection/core/widgets/show_snack_bar.dart';
import 'package:gastric_cancer_detection/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:gastric_cancer_detection/features/auth/presentation/pages/register_screen.dart';

import '../../../../core/constant/styles/styles.dart';
import '../../model/user.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  final UserType type;
  LoginScreen({super.key, required this.type});
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              LoginTextCard(
                text: tr("login"),
              ),
              Expanded(
                child: SidePadding(
                  sidePadding: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Space(
                        boxHeight: 55,
                      ),
                      MasterTextField(
                        prefixIcon: Icons.email,
                        hintText: tr("email"),
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        validate: (value) => Validator.email(value),
                      ),
                      const Space(
                        boxHeight: 15,
                      ),
                      MasterTextField(
                        prefixIcon: Icons.lock,
                        borderRadius: 50,
                        hintText: tr("password"),
                        isPassword: true,
                        controller: passwordController,
                        validate: (value) => Validator.defaultValidator(value),
                      ),
                      // const Space(
                      //   boxHeight: 20,
                      // ),
                      // InkWell(
                      //   onTap: () {},
                      //   child: Text(
                      //     tr("forget_password"),
                      //     style: TextStyles.textViewUnderlineRegular15
                      //         .copyWith(color: mainColor),
                      //   ),
                      // ),
                      const Space(
                        boxHeight: 70,
                      ),
                      Center(
                        child: BlocConsumer<LoginCubit, LoginState>(
                          listener: (context, state) {
                            if (state is LoginError) {
                              showSnackBarError(
                                  context: context, message: state.message);
                            }
                          },
                          builder: (context, state) {
                            if (state is LoginLoading) {
                              return const Loading();
                            }
                            return MasterButton(
                              buttonText: tr("login"),
                              onPressed: () {
                                context.read<LoginCubit>().fLogin(
                                      context: context,
                                      formKey: formKey,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      userType: type,
                                    );
                              },
                            );
                          },
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tr("don't_have_an_account"),
                            style: TextStyles.textViewBold15
                                .copyWith(color: blackColor),
                          ),
                          TextButton(
                              onPressed: () {
                                AppNavigator.push(
                                    context: context,
                                    screen: RegisterScreen(type: type));
                              },
                              child: Text(
                                tr("create_a_new_account"),
                                style: TextStyles.textViewUnderlineRegular15
                                    .copyWith(color: mainColor),
                              ))
                        ],
                      ),
                    ],
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
