import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../utils/my_colors.dart';
import '../utils/my_fonts.dart';

class MyTextFormField extends StatefulWidget {
  const MyTextFormField({
    super.key,
    this.controller,
    this.borderRadius = 0,
    this.label,
    this.hintText,
    this.maxLines = 1,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.labelFontSize = 13,
    this.labelFontWeight = FontWeight.w400,
    this.textColor = MyColors.secondary,
    this.labelColor = MyColors.primary60,
    this.borderColor = MyColors.border,
    this.isPassword = false,
    this.obscureText = true,
    this.required = false,
    this.icPassOnTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.enabled = true,
    this.tapped = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
  });

  final TextEditingController? controller;
  final int maxLines;
  final String? label, errorText, hintText;
  final double borderRadius, labelFontSize;
  final FontWeight labelFontWeight;
  final Color textColor, labelColor, borderColor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool isPassword, obscureText;
  final VoidCallback? icPassOnTap;
  final ValueChanged<String>? onChanged, onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled, tapped, required;
  final Widget? prefixIcon, suffixIcon;
  final VoidCallback? onTap;

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.label != null,
          child: Column(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: (widget.label == null) ? "" : widget.label!.tr,
                      style: TextStyle(
                        color: widget.labelColor,
                        fontFamily: MyFonts.archivo,
                        fontSize: widget.labelFontSize,
                        fontWeight: widget.labelFontWeight,
                      ),
                    ),
                    TextSpan(
                      text: (widget.required) ? " *" : "",
                      style: TextStyle(
                        color: MyColors.redText,
                        fontFamily: MyFonts.archivo,
                        fontSize: widget.labelFontSize,
                        fontWeight: widget.labelFontWeight,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        InkWell(
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              color: widget.enabled
                  ? MyColors.primary
                  : MyColors.secondary.withValues(alpha: 0.1),
              border: .all(color: widget.borderColor),
              borderRadius: BorderRadius.all(
                Radius.circular(widget.borderRadius),
              ),
            ),
            child: TextFormField(
              controller: widget.controller,
              maxLines: widget.maxLines,
              enabled: (widget.tapped) ? false : widget.enabled,
              obscureText: widget.isPassword ? widget.obscureText : false,
              keyboardType: widget.isPassword
                  ? TextInputType.visiblePassword
                  : widget.keyboardType,
              textInputAction: widget.textInputAction,
              style: TextStyle(
                fontSize: 14,
                fontFamily: MyFonts.archivo,
                color: widget.textColor,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const .symmetric(
                  vertical: 14.5,
                  horizontal: 12,
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 40),
                suffixIconConstraints: const BoxConstraints(minWidth: 40),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: (widget.hintText != null)
                    ? widget.hintText!.tr
                    : "".tr,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  fontFamily: MyFonts.archivo,
                  color: MyColors.primary80,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                prefixIcon: widget.prefixIcon,
                suffixIcon: (widget.isPassword)
                    ? InkWell(
                        onTap: widget.icPassOnTap,
                        child: Icon(
                          (widget.obscureText)
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: MyColors.primary60,
                        ),
                      )
                    : widget.suffixIcon,
              ),
              inputFormatters: widget.inputFormatters,
              onChanged: widget.onChanged,
              onFieldSubmitted: widget.onFieldSubmitted,
            ),
          ),
        ),
      ],
    );
  }
}

class MyTextFormFieldNoBorder extends StatelessWidget {
  const MyTextFormFieldNoBorder({
    super.key,
    required this.controller,
    this.textAlign = TextAlign.center,
    this.textColor = MyColors.secondary,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
  });

  final TextEditingController controller;
  final TextAlign textAlign;
  final Color textColor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: MyFonts.archivo,
        color: textColor,
        fontWeight: fontWeight,
      ),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
      onChanged: onChanged,
    );
  }
}
