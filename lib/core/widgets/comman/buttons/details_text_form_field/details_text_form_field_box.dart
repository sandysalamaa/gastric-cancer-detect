import 'package:flutter/material.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/constant/styles/styles.dart';

class TextFormFieldBox extends StatelessWidget {
  final String text;
  final int? maxLines;
  final TextEditingController? controller;

  const TextFormFieldBox(
      {Key? key, required this.text, this.maxLines, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      color: white,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: mainColor, width: 1),
            ),
            focusColor: mainColor,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: mainColor, width: 1),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: mainColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: mainColor, width: 1),
            ),
            hintText: text,
            hintStyle: TextStyles.textViewRegular20.copyWith(color: textColor),
            fillColor: white,
            alignLabelWithHint: false,
            filled: true),
        keyboardType: TextInputType.multiline,
        maxLines: maxLines ?? 8,
        textInputAction: TextInputAction.done,
      ),
    );
  }
}
