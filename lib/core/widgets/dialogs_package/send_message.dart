import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/constant/styles/styles.dart';
import '../comman/buttons/master_button/master_button.dart';
import '../comman/space/space.dart';

class SendMessageAlert extends StatelessWidget {
  const SendMessageAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Simple Alert Dialog'),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const SendMessageDialog();
                });
          },
        ),
      ),
    );
  }
}

class SendMessageDialog extends StatelessWidget {
  const SendMessageDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Column(
        children: [
          Text(
            tr("send_message"),
            textAlign: TextAlign.center,
            style: TextStyles.textViewMedium25.copyWith(color: mainColor),
          ),
          const Space(boxHeight: 40),
          MasterButton(
            buttonText: tr("ok"),
            onPressed: () {},
            borderColor: lightOrangeColor,
            buttonColor: lightOrangeColor,
            buttonHeight: 53,
            buttonRadius: 50,
          ),
        ],
      ),
    );
  }
}
