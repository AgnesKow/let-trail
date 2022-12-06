import 'package:flutter/material.dart';

import '../utils_exporter.dart';

class LabelAndInputField extends StatefulWidget {
  final String? label;
  final TextInputType inputType;
  final bool obscureText, needBorder;
  final TextEditingController fieldController;
  final Color? fieldColor, hintStyle, borderColor, labelColor, textColor;
  final EdgeInsetsGeometry? fieldPadding;
  final TextAlign? textAlign;
  final double? fieldHeight, fontSize, labelSize, borderRadius;
  final int? maxLines;
  final Widget? prefixIcon, suffixIcon;

  const LabelAndInputField({
    Key? key,
    required this.fieldController,
    required this.label,
    this.inputType = TextInputType.text,
    this.obscureText = false,
    this.needBorder = true,
    this.borderRadius,
    this.fieldColor,
    this.borderColor,
    this.labelColor,
    this.textColor,
    this.hintStyle,
    this.fieldPadding,
    this.textAlign,
    this.fieldHeight,
    this.fontSize,
    this.labelSize,
    this.maxLines,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  State<LabelAndInputField> createState() => _LabelAndInputFieldState();
}

class _LabelAndInputFieldState extends State<LabelAndInputField> {
  bool _showPassword = false;

  void _toggleVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.fieldColor,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 5.0),
      ),
      padding: widget.fieldPadding,
      child: SizedBox(
        height: widget.fieldHeight,
        child: TextFormField(
          controller: widget.fieldController,
          keyboardType: widget.inputType,
          autocorrect: false,
          enableSuggestions: true,
          obscureText: widget.obscureText ? !_showPassword : false,
          decoration: InputDecoration(
            isDense: true,
            labelText: widget.label,
            labelStyle: TextStyle(
              fontSize: widget.labelSize ?? 15.0,
              color: widget.labelColor ??
                  AppColors.appBlackColor.withOpacity(0.65),
            ),
            suffixIcon: widget.obscureText
                ? InkWell(
                    onTap: () => _toggleVisibility(),
                    child: _showPassword
                        ? const Icon(
                            Icons.visibility,
                            size: 20.0,
                            color: AppColors.primaryColor,
                          )
                        : const Icon(
                            Icons.visibility_off,
                            size: 20.0,
                            color: AppColors.appGreyColor,
                          ),
                  )
                : widget.suffixIcon,
            border: widget.needBorder ? outlinedBorder() : null,
            disabledBorder: widget.needBorder ? outlinedBorder() : null,
            enabledBorder: widget.needBorder ? outlinedBorder() : null,
            errorBorder: widget.needBorder ? outlinedBorder() : null,
            focusedBorder: widget.needBorder ? outlinedBorder() : null,
            focusedErrorBorder: widget.needBorder ? outlinedBorder() : null,
            filled: true,
            prefixIcon: widget.prefixIcon,
            fillColor: widget.fieldColor,
          ),
          style: TextStyle(
            color: widget.textColor ?? AppColors.appBlackColor,
            fontSize: widget.fontSize ?? 18.0,
            // fontFamily: "DINNextLTPro_Medium",
          ),
          textAlign: widget.textAlign ?? TextAlign.start,
          maxLines: widget.maxLines ?? 1,
        ),
      ),
    );
  }

  OutlineInputBorder outlinedBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          width: 1,
          color: widget.borderColor ?? AppColors.appBlackColor,
        ),
      );
}
