import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/constant/styles/styles.dart';

import '../../../../util/validator.dart';

class MasterTextField extends StatefulWidget {
  final double? sidePadding;
  final double? fieldHeight;
  final double? fieldWidth;
  final double? iconHeight;
  final double? suffixIconHeight;
  final TextEditingController? controller;
  final Color? hintColor;
  final TextInputType? keyboardType;
  final bool? isPassword;
  final bool? autofocus;
  final Color? borderColor;
  final Color? textFieldColor;
  final String? errorText;
  final String hintText;
  final String? labelText;
  final TextStyle? hintStyle;
  final double? elevation;
  final Color? shadowColor;
  final bool? enabled;
  final bool? readOnly;
  final double? borderRadius;
  final IconData? prefixIcon;
  final String? suffixText;
  final IconData? suffixIcon;
  final bool? label;
  final List<TextInputFormatter>? inputFormatters;

//final List<TextInputFormatter>? inputFormatters;
  final Color? suffixColor;
  final int? maxLines;
  final int? minLines;
  final Function(String)? onChanged;
  final int? borderWidth;
  final Function(String)? onSubmit;
  final Function()? onTap;
  final String? Function(String?) validate;
  final Widget? suffix;
  final Color? fillColor;
  final TextAlign? textAlign;

  final void Function(String?)? onSaved;
  final TextDirection? textDirection;
  const MasterTextField({
    Key? key,
    this.autofocus,
    this.label,
    this.textAlign,
    this.readOnly,
    this.labelText,
    this.fieldWidth,
    this.elevation,
    this.shadowColor,
    this.inputFormatters,
    this.borderColor,
    this.textFieldColor,
    this.suffixIconHeight,
    this.iconHeight,
    this.controller,
    this.fieldHeight,
    this.errorText,
    required this.hintText,
    this.textDirection = TextDirection.ltr,
    this.hintStyle,
    this.enabled,
    this.borderWidth,
    this.borderRadius,
    this.isPassword,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixText,
    this.suffixColor,
    this.sidePadding,
    this.maxLines,
    this.minLines,
    this.onChanged,
    this.onSubmit,
    this.onSaved,
    this.validate = Validator.defaultEmptyValidator,
    this.suffix,
    this.onTap,
    this.hintColor,
    this.fillColor,
    // this.inputFormatters,
  }) : super(key: key);

  @override
  State<MasterTextField> createState() => _MasterTextFieldState();
}

class _MasterTextFieldState extends State<MasterTextField> {
  bool secure = false;
  TextDirection? textDirection;
  String? fontFamily;
  @override
  void initState() {
    super.initState();
    secure = widget.isPassword ?? false;
    textDirection = widget.textDirection;
    if (widget.keyboardType == TextInputType.number) {
      fontFamily = "Almarai";
    }
  }

  @override
  void didUpdateWidget(covariant MasterTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  void _checkForArabicLetter(String text) {
    final arabicRegex = RegExp(r'[ء-ي-_ \.]*$');
    final englishRegex = RegExp(r'[a-zA-Z ]');
    final spi = RegExp("[\$&+,:;=?@#|'<>.^*()%!-]+");
    final numbers = RegExp("^[0-9]*\$");
    setState(() {
      text.contains(arabicRegex) &&
              !text.startsWith(englishRegex) &&
              !text.startsWith(spi) &&
              !text.startsWith(numbers)
          ? textDirection = TextDirection.rtl
          : textDirection = TextDirection.ltr;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // color: white,
          // border: Border.all(color: mainColor),
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 30.r)),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        //autocorrect: true,

        controller: widget.controller,

        onChanged: (value) {
          _checkForArabicLetter(value);
          if (widget.onChanged != null) widget.onChanged!(value);
        },
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
          }
          if (widget.controller!.selection ==
              TextSelection.fromPosition(
                  TextPosition(offset: widget.controller!.text.length - 1))) {
            setState(() {
              widget.controller!.selection = TextSelection.fromPosition(
                  TextPosition(offset: widget.controller!.text.length));
            });
          }
        },
        keyboardType: widget.keyboardType,

        obscureText: secure,
        cursorColor: mainColor,
        maxLines: widget.maxLines ?? 1,
        minLines: widget.minLines ?? 1,
        autofocus: widget.autofocus ?? false,
        style: TextStyles.textViewMedium20
            .copyWith(color: textColor, fontFamily: fontFamily),
        enabled: widget.enabled,
        onSaved: widget.onSaved,
        readOnly: widget.readOnly ?? false,
        validator: widget.validate,
        inputFormatters: widget.inputFormatters,
        onFieldSubmitted: widget.onSubmit,
        textDirection: textDirection,

        // inputFormatters: inputFormatters,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
          //fillColor: widget.textFieldColor ?? textColor.withOpacity(0.2),
          filled: true,
          fillColor: widget.fillColor ?? white,
          focusColor: mainColor,

          errorMaxLines: 2,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 30.0.r),
            borderSide: BorderSide(
              color: widget.borderColor ?? mainColor,
              width: 1,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 30.0.r),
            borderSide: const BorderSide(
              color: mainColor,
              width: 1,
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 30.0.r),
            borderSide: BorderSide(
              color: widget.enabled == true ? red : mainColor,
              width: 1,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: mainColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 30.r),
          ),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(widget.borderRadius ?? 30.r)),
              borderSide: BorderSide(
                color: widget.errorText != null ? red : mainColor,
                width: 1,
                style: BorderStyle.solid,
              )),

          hintText: widget.hintText,
          labelText: widget.labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,

          alignLabelWithHint: widget.label,
          labelStyle: TextStyles.textViewRegular20.copyWith(color: blackColor),
          hintStyle: TextStyles.textViewRegular20
              .copyWith(color: mainColor.withOpacity(0.5)),
          suffixIconColor: widget.suffixColor ?? mainColor,
          suffix: widget.suffix,
          prefixIcon: widget.prefixIcon == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Icon(
                    widget.prefixIcon,
                    color: mainColor,
                  ),
                ),
          suffixIcon: widget.isPassword ?? false
              ? IconButton(
                  onPressed: () => setState(() {
                        secure = !secure;
                      }),
                  icon: Icon(
                    !secure ? Icons.visibility : Icons.visibility_off,
                    color: mainColor,
                  ))
              : widget.suffixIcon == null
                  ? null
                  : Icon(
                      widget.suffixIcon,
                      color: mainColor,
                    ),
        ),
      ),
    );
  }
}
