// ignore: file_names
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gastric_cancer_detection/core/constant/dimenssions/size_config.dart';
import 'package:gastric_cancer_detection/core/constant/images/images.dart';
import 'package:gastric_cancer_detection/core/constant/styles/styles.dart';
import 'package:gastric_cancer_detection/core/util/app_navigator.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/buttons/master_button/master_button.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/side_padding/side_padding.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/space/space.dart';

import '../../../../../core/constant/colors/colors.dart';

class CheckUpScreen extends StatefulWidget {
  const CheckUpScreen({super.key});

  @override
  State<CheckUpScreen> createState() => _CheckUpScreenState();
}

class _CheckUpScreenState extends State<CheckUpScreen> {
  final List<Question> _questions = [
    Question(tr('You have diabetes ?')),
    Question(tr('You have hypertension ?')),
    Question(tr('You have recently suffered an injury ?')),
    Question(tr('Do you often feel discomfort after eating ?')),
    Question(tr('Is there bloating after eating small amounts of food ?')),
    Question(tr(
        'Is there weight loss without intentionally trying to lose weight ?')),
    Question(tr('Do you often feel nausea and vomiting?')),
    Question(tr('Do you often feel abdominal pain ?')),
    Question(tr('Is there difficulty swallowing when eating or drinking ?')),
    Question(tr('Do you feel tired or fatigue most of the time ?')),
  ];

  int _currentIndex = 0;

  void _handleAnswer(bool answer) {
    setState(() {
      _questions[_currentIndex].answer = answer;
      if (_currentIndex < _questions.length - 1) {
        _currentIndex++;
      } else {
        _showDialog();
      }
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              tr('Thanks for using GCD'),
              style: TextStyles.textViewBold20.copyWith(color: blackColor),
            ),
          ),
          content: Text(
            tr('Thanks for answering all the questions!'),
            textAlign: TextAlign.end,
            style: TextStyles.textViewBold18.copyWith(color: blackColor),
          ),
          actions: [
            Center(
              child: MasterButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    for (var question in _questions) {
                      question.answer = null;
                    }
                    _currentIndex = 0;
                  });
                },
                buttonText: 'OK',
                buttonWidth: 150.w,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: mainColor,
              height: SizeConfig.screenHeight / 2,
              width: SizeConfig.screenWidth,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          AppNavigator.pop(context: context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: white,
                        ),
                      ),
                      Space(boxWidth: SizeConfig.screenWidth / 5),
                      Column(
                        children: [
                          Image.asset(
                            logoImage,
                            height: 100.h,
                          ),
                          Text(
                            tr("Symptom Checker"),
                            style: TextStyles.textViewBold20
                                .copyWith(color: white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight,
                decoration: BoxDecoration(
                  color: white,
                  // image: const DecorationImage(
                  //     image: AssetImage(checkUpImage), fit: BoxFit.fill),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(70.r),
                      topLeft: Radius.circular(70.r)),
                ),
                child: SidePadding(
                  sidePadding: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        _questions[_currentIndex].text!,
                        textAlign: TextAlign.center,
                        style: TextStyles.textViewBold23
                            .copyWith(color: mainColor),
                      ),
                      const SizedBox(height: 30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MasterButton(
                            onPressed: () {
                              _handleAnswer(true);
                            },
                            buttonText: tr('Yes'),
                            buttonWidth: 120.w,
                          ),
                          MasterButton(
                            onPressed: () {
                              _handleAnswer(false);
                            },
                            buttonText: tr('no'),
                            buttonWidth: 120.w,
                          ),
                        ],
                      ),
                      const Space(boxHeight: 20),
                      MasterButton(
                        buttonWidth: 120.w,
                        onPressed: () {
                          _handleAnswer(false);
                        },
                        buttonText: tr('Dont know'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Question {
  String? text;
  bool? answer;

  Question(this.text);
}
